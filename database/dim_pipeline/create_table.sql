-- Create dim_pipeline table
-- Uses if_salesforce.if_Opportunity phase field for pipeline stages
-- Key: stage_name (natural key)

CREATE OR REPLACE TABLE `dm_business_planning.dim_pipeline` AS
WITH stage_data AS (
  SELECT DISTINCT
    phase as stage_name
  FROM `if_salesforce.if_Opportunity`
  WHERE phase IS NOT NULL
)
SELECT 
  stage_name,  -- Primary key (natural key)
  
  -- Standardized stage name for reporting
  CASE 
    WHEN stage_name = '0.TQL' THEN 'TQL'
    WHEN stage_name IN ('1.SAL', 'SAL') THEN 'SAL'
    WHEN stage_name IN ('2.SQL', 'SQL') THEN 'SQL'
    WHEN stage_name IN ('3.SQO-D', 'SQO-D') THEN 'SQO-D'
    WHEN stage_name IN ('4.SQO-C', 'SQO-C') THEN 'SQO-C'
    WHEN stage_name = '5.SQO-B' THEN 'SQO-B'
    WHEN stage_name IN ('6.SQO-A', 'SQO-A') THEN 'SQO-A'
    WHEN stage_name IN ('7.CLOSED WON', 'CLOSED WON') THEN 'CLOSED WON'
    WHEN stage_name = 'CLOSED LOST' THEN 'CLOSED LOST'
    WHEN stage_name = 'CLOSED RECYCLE' THEN 'CLOSED RECYCLE'
    WHEN stage_name = 'CLOSED OTHER' THEN 'CLOSED OTHER'
    WHEN stage_name = 'Get Appt' THEN 'Get Appt'
    WHEN stage_name = 'Pre-Evaluation' THEN 'Pre-Evaluation'
    WHEN stage_name = 'Recycle' THEN 'Recycle'
    WHEN stage_name = 'ERROR' THEN 'ERROR'
    ELSE stage_name
  END as standardized_stage,
  
  -- Phase numbering for funnel analysis
  CASE 
    WHEN stage_name IN ('Get Appt', 'Pre-Evaluation') THEN 0  -- Pre-stages
    WHEN stage_name = '0.TQL' THEN 1
    WHEN stage_name IN ('1.SAL', 'SAL') THEN 2
    WHEN stage_name IN ('2.SQL', 'SQL') THEN 3
    WHEN stage_name IN ('3.SQO-D', 'SQO-D') THEN 4
    WHEN stage_name IN ('4.SQO-C', 'SQO-C') THEN 5
    WHEN stage_name = '5.SQO-B' THEN 6
    WHEN stage_name IN ('6.SQO-A', 'SQO-A') THEN 7
    WHEN stage_name IN ('7.CLOSED WON', 'CLOSED WON') THEN 8
    WHEN stage_name = 'CLOSED LOST' THEN 9
    WHEN stage_name IN ('CLOSED RECYCLE', 'Recycle') THEN 10
    WHEN stage_name = 'CLOSED OTHER' THEN 11
    WHEN stage_name = 'ERROR' THEN NULL
    ELSE NULL
  END as phase_number,
  
  -- Business categorization
  CASE 
    WHEN stage_name IN ('7.CLOSED WON', 'CLOSED WON') THEN 'Won'
    WHEN stage_name = 'CLOSED LOST' THEN 'Lost'
    WHEN stage_name IN ('CLOSED RECYCLE', 'Recycle') THEN 'Recycled'
    WHEN stage_name = 'CLOSED OTHER' THEN 'Other Closed'
    WHEN stage_name = 'ERROR' THEN 'Error'
    WHEN stage_name IN ('Get Appt', 'Pre-Evaluation') THEN 'Pre-Qualification'
    ELSE 'Active'
  END as stage_category,
  
  -- Business logic flags
  CASE 
    WHEN stage_name LIKE '%CLOSED%' THEN TRUE 
    ELSE FALSE 
  END as is_closed,
  
  CASE 
    WHEN stage_name IN ('7.CLOSED WON', 'CLOSED WON') THEN TRUE 
    ELSE FALSE 
  END as is_won,
  
  -- Qualification level
  CASE
    WHEN stage_name IN ('Get Appt', 'Pre-Evaluation') THEN 'Pre-Qualification'
    WHEN stage_name IN ('0.TQL') THEN 'Lead'
    WHEN stage_name IN ('1.SAL', 'SAL') THEN 'Sales Accepted'
    WHEN stage_name IN ('2.SQL', 'SQL') THEN 'Sales Qualified'
    WHEN stage_name LIKE '%SQO%' THEN 'Sales Qualified Opportunity'
    WHEN stage_name LIKE '%CLOSED%' THEN 'Closed'
    WHEN stage_name IN ('Recycle') THEN 'Recycled'
    ELSE 'Other'
  END as qualification_level,
  
  -- Metadata
  CURRENT_TIMESTAMP() as created_at,
  CURRENT_TIMESTAMP() as updated_at
FROM stage_data
ORDER BY phase_number, stage_name;

-- Table Description:
-- Contains all pipeline stages from Salesforce Opportunity phase field
-- Data source: if_salesforce.if_Opportunity (authoritative Salesforce table)
-- Specification:
-- - stage_name: Original phase value from Salesforce (primary key)
-- - standardized_stage: Clean version for reporting
-- - phase_number: Sequential number for funnel analysis (0-11)
-- - stage_category: Business grouping (Active/Won/Lost/Recycled/Pre-Qualification/Error)
-- - is_closed: TRUE for closed stages
-- - is_won: TRUE for won stages only
-- - qualification_level: Lead qualification progression level