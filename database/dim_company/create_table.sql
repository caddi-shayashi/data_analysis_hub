-- Create dim_company table
-- Replaces: dim_company_segment
-- Key: account_id (matches existing schema)

CREATE OR REPLACE TABLE `dm_business_planning.dim_company` AS
SELECT 
  account_id,  -- Primary key (natural key from Salesforce)
  account_name, -- Company name
  NULLIF(country_region, 'Unknown') as country_region,  -- NULL if 'Unknown'
  NULLIF(company_type, 'Not Classified') as company_type,  -- NULL if 'Not Classified'
  NULLIF(company_size, 'Not Classified') as company_size,  -- NULL if 'Not Classified'
  NULLIF(company_size_detail, 'Not Classified') as company_size_detail,  -- NULL if 'Not Classified'
  NULLIF(company_fit, 'Unknown') as company_fit,  -- NULL if 'Unknown'
  
  -- FORCAS data (external company intelligence)
  fsjp_custom_forcas_pref_name as fsjp_custom_forcas_pref_name,
  fsjp_custom_forcas_main_industry as fsjp_custom_forcas_main_industry,
  fsjp_custom_forcas_main_sector as fsjp_custom_forcas_main_sector,
  fsjp_custom_forcas_main_subsector as fsjp_custom_forcas_main_subsector,
  fsjp_custom_forcas_stock as fsjp_custom_forcas_stock,
  
  -- Company metrics
  number_of_employees,
  normalization_total_sales_range__c,
  production_method,
  
  -- Metadata
  CURRENT_TIMESTAMP() as created_at,
  CURRENT_TIMESTAMP() as updated_at
FROM `dm_business_planning.salesforce_account_mart`
WHERE account_id IS NOT NULL;

-- Table Description:
-- Contains all unique companies with enhanced attributes from FORCAS
-- Total records: 324,062 companies
-- All unique account_ids preserved (no deduplication)
-- NULL values returned for unknown/unclassified data instead of placeholder strings