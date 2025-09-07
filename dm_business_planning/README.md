# Database Schema Documentation

## Dimension Tables Structure

This directory contains the SQL creation scripts for all dimension tables in the `dm_business_planning` dataset.

### 📁 Directory Structure

```
database/
├── dim_company/
│   └── create_table.sql      # Company dimension (324,062 records)
├── dim_member/
│   └── create_table.sql      # Sales member dimension (390 records)
├── dim_pipeline/
│   └── create_table.sql      # Pipeline stage dimension (21 records)
├── dim_product/
│   └── create_table.sql      # Product combination dimension (8 records)
├── dim_revenue/
│   └── create_table.sql      # Revenue category dimension (7 records)
├── dim_time/
│   └── create_table.sql      # Time dimension
└── README.md                 # This documentation
```

### 📊 Table Overview

| Table | Records | Primary Key | Description |
|-------|---------|-------------|-------------|
| **dim_company** | 324,062 | `account_id` | Company master with FORCAS intelligence |
| **dim_member** | 390 | `fs_owner_id` | Sales team from if_User and if_UserRole |
| **dim_pipeline** | 21 | `stage_name` | Opportunity stages from if_Opportunity |
| **dim_product** | 8 | `product_key` | Product combinations (Drawer/Quote/Solution) |
| **dim_revenue** | 7 | `revenue_name` | MRR movement categories |
| **dim_time** | Dynamic | `jst_month` | Calendar and fiscal year structure |

### 🔑 Key Design Principles

#### 1. **Natural Keys Usage**
- Uses existing business keys (`account_id`, `stage_name`, `jst_month`)
- Product combinations as natural keys (`Full_Suite`, `Drawer_Quote`, etc.)
- Revenue categories by name (`new_logo`, `upsell`, etc.)

#### 2. **Salesforce Integration**
- **dim_member**: Direct from `if_salesforce.if_User` JOIN `if_UserRole`
- **dim_pipeline**: Direct from `if_salesforce.if_Opportunity.phase`
- Clean organizational structure from UserRole.developername

#### 3. **Business Logic Integration**
- **Pipeline stages**: `is_closed`, `is_won`, `qualification_level`
- **Sales members**: `is_admin`, `is_manager` flags
- **Revenue categories**: `sort_order` for consistent reporting

### 🚀 Usage Examples

#### Company Analysis
```sql
SELECT 
  company_fit,
  company_size,
  COUNT(*) as company_count
FROM dm_business_planning.dim_company
GROUP BY company_fit, company_size;
```

#### Sales Team Structure
```sql
SELECT 
  department,
  region,
  customer_segment,
  customer_segment_detail,
  area,
  COUNT(*) as member_count
FROM dm_business_planning.dim_member
WHERE is_admin = FALSE
GROUP BY 1,2,3,4,5;
```

#### Pipeline Funnel Analysis
```sql
SELECT 
  phase_number,
  standardized_stage,
  stage_category,
  qualification_level,
  is_closed
FROM dm_business_planning.dim_pipeline
ORDER BY phase_number;
```

#### Product Combination Analysis
```sql
SELECT 
  product_key,
  product_count,
  has_drawer,
  has_quote,
  has_solution
FROM dm_business_planning.dim_product
ORDER BY product_count DESC;
```

#### Revenue Movement Analysis
```sql
SELECT 
  revenue_name,
  display_name,
  revenue_type,
  mrr_impact,
  sort_order
FROM dm_business_planning.dim_revenue
ORDER BY sort_order;
```

#### Time Period Analysis
```sql
SELECT 
  jst_month,
  fiscal_year,
  fiscal_quarter,
  quarter_name,
  month_name
FROM dm_business_planning.dim_time
WHERE fiscal_year = 2024
ORDER BY jst_month;
```

### 📅 Maintenance

Each table includes `created_at` and `updated_at` timestamps for audit tracking.

**Last Updated**: 2025-09-07
**Schema Version**: v2.0
**Created by**: Claude Code Data Analysis