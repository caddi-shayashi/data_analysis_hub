-- Create dim_revenue table
-- Revenue category dimension for MRR movement classification
-- Key: revenue_name (natural key)

CREATE OR REPLACE TABLE `dm_business_planning.dim_revenue` AS
SELECT 
  category_name as revenue_name,  -- Natural key
  category_display_name as display_name,
  category_group as revenue_group,
  category_description as description,
  business_impact,
  
  -- Revenue type classification
  CASE 
    WHEN category_group = 'new_logo' THEN 'New Business'
    WHEN category_group = 'expansion' THEN 'Expansion'
    WHEN category_group = 'contraction' THEN 'Contraction'
    WHEN category_group = 'logo_churn' THEN 'Churn'
    ELSE 'Other'
  END as revenue_type,
  
  -- Impact on MRR
  CASE 
    WHEN business_impact = 'Positive' THEN 'Increase'
    WHEN business_impact = 'Negative' THEN 'Decrease'
    ELSE 'Neutral'
  END as mrr_impact,
  
  -- Is retention related
  CASE 
    WHEN category_group IN ('expansion', 'contraction', 'logo_churn') THEN TRUE
    ELSE FALSE
  END as is_retention_related,
  
  -- Sort order for reports
  CASE category_name
    WHEN 'new_logo' THEN 1
    WHEN 'upsell' THEN 2
    WHEN 'crosssell' THEN 3
    WHEN 'downsell' THEN 4
    WHEN 'product_churn' THEN 5
    WHEN 'pause' THEN 6
    WHEN 'logo_churn' THEN 7
  END as sort_order,
  
  -- Metadata
  CURRENT_TIMESTAMP() as created_at,
  CURRENT_TIMESTAMP() as updated_at
FROM (
  SELECT 'new_logo' as category_name, 'New Logo' as category_display_name, 'new_logo' as category_group, 'New customer acquisition' as category_description, 'Positive' as business_impact
  UNION ALL
  SELECT 'upsell', 'Upsell', 'expansion', 'Existing customer product upgrade', 'Positive'
  UNION ALL
  SELECT 'crosssell', 'Cross-sell', 'expansion', 'Existing customer new product addition', 'Positive'
  UNION ALL
  SELECT 'downsell', 'Downsell', 'contraction', 'Customer product downgrade', 'Negative'
  UNION ALL
  SELECT 'product_churn', 'Product Churn', 'contraction', 'Customer product cancellation', 'Negative'
  UNION ALL
  SELECT 'pause', 'Pause', 'contraction', 'Customer contract pause', 'Negative'
  UNION ALL
  SELECT 'logo_churn', 'Logo Churn', 'logo_churn', 'Complete customer loss', 'Negative'
)
ORDER BY 
  CASE category_name
    WHEN 'new_logo' THEN 1
    WHEN 'upsell' THEN 2
    WHEN 'crosssell' THEN 3
    WHEN 'downsell' THEN 4
    WHEN 'product_churn' THEN 5
    WHEN 'pause' THEN 6
    WHEN 'logo_churn' THEN 7
  END;

-- Table Description:
-- Contains revenue movement categories for MRR analysis
-- Specification:
-- - revenue_name: Natural key (new_logo, upsell, crosssell, downsell, product_churn, pause, logo_churn)
-- - display_name: User-friendly display name
-- - revenue_group: Category grouping (new_logo, expansion, contraction, logo_churn)
-- - description: Detailed description of the revenue category
-- - business_impact: Positive or Negative impact on business
-- - revenue_type: Business classification (New Business, Expansion, Contraction, Churn)
-- - mrr_impact: Impact on Monthly Recurring Revenue (Increase/Decrease)
-- - is_retention_related: TRUE for existing customer revenue movements