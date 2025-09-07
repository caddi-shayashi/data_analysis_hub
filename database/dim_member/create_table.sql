-- Create dim_member table
-- Uses proper Salesforce User and UserRole tables for accurate organizational structure
-- Key: fs_owner_id (matches existing schema)

CREATE OR REPLACE TABLE `dm_business_planning.dim_member` AS
SELECT 
  u.Id as fs_owner_id,  -- Primary key
  u.Name as owner_name,  -- Member name (matches existing schema)
  r.developername as owner_team,  -- Role developer name (cleaner than parsed owner_team)
  
  -- Department: Combine function_role and department field
  COALESCE(
    CASE 
      WHEN r.developername LIKE '%_FS%' OR r.developername LIKE '%FS_%' THEN 'Field Sales'
      WHEN r.developername LIKE '%_CS%' OR r.developername LIKE '%CS_%' THEN 'Customer Success'
      WHEN r.developername LIKE '%_IS%' OR r.developername LIKE '%IS_%' THEN 'Inside Sales'
      WHEN r.developername LIKE '%_MK%' OR r.developername LIKE '%MK_%' THEN 'Marketing'
      WHEN r.developername LIKE '%_OPS%' OR r.developername LIKE '%OPS_%' THEN 'Operations'
      WHEN r.developername LIKE '%_PD%' OR r.developername LIKE '%PD_%' THEN 'Product Development'
      WHEN r.developername LIKE '%Alliance%' THEN 'Alliance Sales'
      WHEN r.developername LIKE '%Government%' THEN 'Government Sales'
      WHEN r.developername LIKE '%Solution_Architect%' THEN 'Solution Architect'
      WHEN r.developername LIKE '%Quote%' OR r.developername LIKE '%QUOTE%' THEN 'Quote'
      WHEN r.developername LIKE '%BIZDEV%' THEN 'Business Development'
      ELSE NULL
    END,
    u.Department
  ) as department,
  
  -- Region: Extract from role prefix
  CASE 
    WHEN r.developername LIKE 'JP_%' THEN 'JP'
    WHEN r.developername LIKE 'US_%' THEN 'US'
    WHEN r.developername LIKE 'TH_%' THEN 'TH'
    WHEN r.developername LIKE 'MY_%' THEN 'MY'
    WHEN r.developername LIKE 'VN_%' THEN 'VN'
    WHEN r.developername LIKE 'SG_%' THEN 'SG'
    WHEN r.developername LIKE 'ASEAN_%' THEN 'ASEAN'
    WHEN r.developername LIKE 'Global_%' THEN 'Global'
    ELSE NULL
  END as region,
  
  -- Customer Segment: Only Enterprise or Maker
  CASE 
    WHEN r.developername LIKE '%_Maker_%' THEN 'Maker'
    WHEN r.developername LIKE '%_ENT%' THEN 'Enterprise'
    ELSE NULL
  END as customer_segment,
  
  -- Customer Segment Detail: Detailed classification
  CASE 
    -- Maker segment details
    WHEN r.developername LIKE '%_Maker_%' THEN
      CASE
        WHEN r.developername LIKE '%_SB_%' OR r.developername LIKE '%_SB' THEN 'Small Business'
        WHEN r.developername LIKE '%_MID_%' OR r.developername LIKE '%_MID' THEN 'Mid-Size Business'
        ELSE 'Maker'  -- Default Maker without specific sub-segment
      END
    -- Enterprise stays as Enterprise
    WHEN r.developername LIKE '%_ENT%' THEN 'Enterprise'
    -- Other segments that are not Maker or Enterprise
    WHEN r.developername LIKE '%_SB_%' OR r.developername LIKE '%_SB' THEN 'Small Business'
    WHEN r.developername LIKE '%_MID_%' OR r.developername LIKE '%_MID' THEN 'Mid-Size Business'
    WHEN r.developername LIKE '%_MB%' THEN 'Mid-Size Business'
    WHEN r.developername LIKE '%_FAB%' THEN 'Fabrication'
    ELSE NULL
  END as customer_segment_detail,
  
  -- Product Unit: Extract Quote-related roles
  CASE 
    WHEN r.developername LIKE '%_Quote_%' OR r.developername LIKE '%QUOTE%' THEN 'Quote'
    ELSE NULL
  END as product_unit,
  
  -- Area (Geographic Region): Extract sub-regional areas
  CASE 
    WHEN r.developername LIKE '%_EAST%' THEN 'EAST'
    WHEN r.developername LIKE '%_WEST%' THEN 'WEST'  
    WHEN r.developername LIKE '%_KYUSHU%' THEN 'KYUSHU'
    WHEN r.developername LIKE '%_CENT%' THEN 'CENTRAL'
    ELSE NULL
  END as area,
  
  -- Team Tier: Extract organizational tier
  CASE 
    WHEN r.developername LIKE '%_1st%' OR r.developername LIKE '%1%' THEN '1st'
    WHEN r.developername LIKE '%_2nd%' OR r.developername LIKE '%2%' THEN '2nd'
    WHEN r.developername LIKE '%_3rd%' OR r.developername LIKE '%3%' THEN '3rd'
    WHEN r.developername LIKE '%_MGR%' OR r.developername LIKE '%Manager%' THEN 'Manager'
    WHEN r.developername LIKE '%_GM%' THEN 'GM'
    WHEN r.developername LIKE 'Directors_And_GeneralManagers' THEN 'Director/GM'
    ELSE NULL
  END as team_tier,
  
  -- Is Admin: TRUE if admin/system role
  CASE 
    WHEN r.developername LIKE '%_Admin_%' OR r.developername LIKE '%Admin%' 
         OR r.developername LIKE '%_System%' OR r.developername LIKE '%System%' THEN TRUE
    ELSE FALSE
  END as is_admin,
  
  -- Is Manager: TRUE if manager role
  CASE 
    WHEN r.developername LIKE '%_MGR%' OR r.developername LIKE '%Manager%' 
         OR r.developername LIKE '%_GM%' OR r.developername LIKE 'Directors_And_GeneralManagers' THEN TRUE
    ELSE FALSE
  END as is_manager,
  
  -- Additional fields from User table
  u.IsActive,
  u.Email,
  u.EmployeeNumber,
  
  -- Metadata
  CURRENT_TIMESTAMP() as created_at,
  CURRENT_TIMESTAMP() as updated_at
FROM `if_salesforce.if_User` u
LEFT JOIN `if_salesforce.if_UserRole` r ON u.UserRoleId = r.Id
WHERE u.IsActive = TRUE
  AND u.UserType = 'Standard'
ORDER BY u.Name;

-- Table Description:
-- Contains all active Salesforce users with organizational structure from UserRole
-- Data source: if_salesforce.if_User JOIN if_UserRole (authoritative Salesforce tables)
-- Enhanced organizational parsing from clean UserRole.developername patterns
-- Specification:
-- - department: Combines function role from UserRole and Department from User table
-- - region: JP/US/TH/MY/VN/SG/ASEAN/Global from role prefix
-- - customer_segment: Only Enterprise or Maker
-- - customer_segment_detail: SB->Small Business, MID->Mid-Size Business for Maker; Enterprise for Enterprise
-- - product_unit: Quote roles mapped to Quote
-- - area: EAST/WEST/KYUSHU/CENTRAL for geographic sub-regions
-- - team_tier: 1st/2nd/3rd/Manager/GM/Director organizational levels
-- - is_admin: TRUE for Admin_System roles, FALSE otherwise
-- - is_manager: TRUE for Manager/GM/Director roles, FALSE otherwise