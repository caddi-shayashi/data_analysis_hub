-- Create dim_product table
-- Product combinations dimension for CADDi's three products
-- Key: product_combination (natural key)

CREATE OR REPLACE TABLE `dm_business_planning.dim_product` AS
SELECT 
  product_combination as product_key,  -- Natural key (product_combination is unique)
  has_drawer,
  has_quote,
  has_solution,
  -- Product count
  CAST(has_drawer AS INT64) + CAST(has_quote AS INT64) + CAST(has_solution AS INT64) as product_count,
  CURRENT_TIMESTAMP() as created_at,
  CURRENT_TIMESTAMP() as updated_at
FROM (
  SELECT DISTINCT
    CASE 
      WHEN has_drawer AND has_quote AND has_solution THEN 'Full_Suite'
      WHEN has_drawer AND has_quote AND NOT has_solution THEN 'Drawer_Quote'
      WHEN has_drawer AND NOT has_quote AND has_solution THEN 'Drawer_Solution'
      WHEN has_drawer AND NOT has_quote AND NOT has_solution THEN 'Drawer'
      WHEN NOT has_drawer AND has_quote AND has_solution THEN 'Quote_Solution'
      WHEN NOT has_drawer AND has_quote AND NOT has_solution THEN 'Quote'
      WHEN NOT has_drawer AND NOT has_quote AND has_solution THEN 'Solution'
      WHEN NOT has_drawer AND NOT has_quote AND NOT has_solution THEN 'None'
    END as product_combination,
    has_drawer,
    has_quote,
    has_solution
  FROM (
    SELECT TRUE as has_drawer UNION ALL SELECT FALSE
  ) d
  CROSS JOIN (
    SELECT TRUE as has_quote UNION ALL SELECT FALSE
  ) q
  CROSS JOIN (
    SELECT TRUE as has_solution UNION ALL SELECT FALSE
  ) s
)
ORDER BY product_count DESC, product_combination;

-- Table Description:
-- Contains all possible product combinations (8 patterns)
-- Specification:
-- - product_key: Natural key using product_combination string
-- - has_drawer: TRUE if Drawer is included
-- - has_quote: TRUE if Quote is included
-- - has_solution: TRUE if Solution is included
-- - product_count: Number of products in the combination (0-3)
-- Combinations:
-- - Full_Suite: All three products
-- - Drawer_Quote: Drawer + Quote
-- - Drawer_Solution: Drawer + Solution
-- - Quote_Solution: Quote + Solution
-- - Drawer: Drawer only
-- - Quote: Quote only
-- - Solution: Solution only
-- - None: No products