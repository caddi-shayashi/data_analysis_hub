-- Create dim_time table
-- Simplified time dimension without surrogate keys
-- Key: jst_month (YYYY-MM format)

CREATE OR REPLACE TABLE `dm_business_planning.dim_time` AS
WITH date_range AS (
  SELECT 
    DATE_ADD(DATE '2021-01-01', INTERVAL n DAY) as date
  FROM 
    UNNEST(GENERATE_ARRAY(0, DATE_DIFF(CURRENT_DATE(), DATE '2021-01-01', DAY))) as n
)
SELECT DISTINCT
  FORMAT_DATE('%Y-%m', date) as jst_month,  -- Natural key
  EXTRACT(YEAR FROM date) as year,
  EXTRACT(QUARTER FROM date) as quarter,
  EXTRACT(MONTH FROM date) as month,
  FORMAT_DATE('%Y-Q%Q', date) as quarter_name,
  FORMAT_DATE('%B', date) as month_name,
  
  -- Japanese fiscal year (starts April 1)
  CASE 
    WHEN EXTRACT(MONTH FROM date) >= 4 THEN EXTRACT(YEAR FROM date)
    ELSE EXTRACT(YEAR FROM date) - 1
  END as fiscal_year,
  
  CASE 
    WHEN EXTRACT(MONTH FROM date) IN (4, 5, 6) THEN 1
    WHEN EXTRACT(MONTH FROM date) IN (7, 8, 9) THEN 2
    WHEN EXTRACT(MONTH FROM date) IN (10, 11, 12) THEN 3
    WHEN EXTRACT(MONTH FROM date) IN (1, 2, 3) THEN 4
  END as fiscal_quarter,
  
  -- Metadata
  CURRENT_TIMESTAMP() as created_at,
  CURRENT_TIMESTAMP() as updated_at
FROM date_range
WHERE date <= CURRENT_DATE()
ORDER BY jst_month;

-- Table Description:
-- Time dimension table with calendar and fiscal year structure
-- Data source: Generated date range from 2021-01-01 to current date
-- Specification:
-- - jst_month: Year-Month in YYYY-MM format (primary key)
-- - year: Calendar year
-- - quarter: Calendar quarter (1-4)
-- - month: Calendar month (1-12)
-- - quarter_name: Formatted quarter (e.g., 2024-Q1)
-- - month_name: Full month name (e.g., January)
-- - fiscal_year: Japanese fiscal year (April-March)
-- - fiscal_quarter: Japanese fiscal quarter (Q1: Apr-Jun, Q2: Jul-Sep, Q3: Oct-Dec, Q4: Jan-Mar)