# BigQuery Business Logic Management

## 概要
BigQueryのネイティブ機能を活用したビジネスロジック管理システム

## 実装構成

### 1. テーブル・カラムのDescription管理
```sql
-- テーブルにビジネスロジック説明を追加
ALTER TABLE `dm_business_planning.dim_revenue`
SET OPTIONS (
  description = """
  収益カテゴリマスタ
  ビジネスロジック:
  - new_logo: 新規顧客の初回契約
  - upsell: 既存顧客の契約金額増加
  - crosssell: 既存顧客への新製品販売
  - downsell: 契約金額の減少
  - product_churn: 特定製品の解約
  - pause: 一時停止
  - logo_churn: 顧客の完全離脱
  
  Version: 2.0
  Owner: Business Planning Team
  Last Updated: 2025-09-07
  """
);

-- カラムレベルの説明
ALTER TABLE `dm_business_planning.dim_revenue`
ALTER COLUMN mrr_impact SET OPTIONS (
  description = "MRRへの影響: positive=増収, negative=減収, neutral=変化なし"
);
```

### 2. Labels活用
```sql
-- テーブルにラベル付与
ALTER TABLE `dm_business_planning.dim_product`
SET OPTIONS (
  labels = [
    ("owner", "business-planning"),
    ("category", "master-data"),
    ("sensitivity", "internal"),
    ("version", "v2-0"),
    ("update-frequency", "monthly")
  ]
);
```

### 3. Persistent UDFs（ビジネスロジック関数）
```sql
-- MRR計算ロジック
CREATE OR REPLACE FUNCTION `dm_business_planning.calculate_mrr`(
  amount FLOAT64,
  revenue_type STRING
)
RETURNS FLOAT64
AS (
  CASE 
    WHEN revenue_type IN ('new_logo', 'upsell', 'crosssell') THEN amount
    WHEN revenue_type IN ('downsell', 'product_churn', 'logo_churn') THEN -amount
    WHEN revenue_type = 'pause' THEN 0
    ELSE NULL
  END
);

-- 企業セグメント判定
CREATE OR REPLACE FUNCTION `dm_business_planning.get_company_segment`(
  employee_count INT64,
  annual_revenue FLOAT64
)
RETURNS STRING
AS (
  CASE 
    WHEN employee_count >= 1000 OR annual_revenue >= 1000000000 THEN 'Enterprise'
    WHEN employee_count >= 100 OR annual_revenue >= 100000000 THEN 'Mid-Market'
    WHEN employee_count >= 10 OR annual_revenue >= 10000000 THEN 'SMB'
    ELSE 'Startup'
  END
);

-- 営業ステージのスコアリング
CREATE OR REPLACE FUNCTION `dm_business_planning.calculate_opportunity_score`(
  stage_name STRING,
  amount FLOAT64,
  probability INT64
)
RETURNS STRUCT<
  weighted_amount FLOAT64,
  risk_level STRING,
  priority_score INT64
>
AS (
  STRUCT(
    amount * (probability / 100.0) AS weighted_amount,
    CASE 
      WHEN probability < 30 THEN 'High Risk'
      WHEN probability < 70 THEN 'Medium Risk'
      ELSE 'Low Risk'
    END AS risk_level,
    CAST(probability * LOG(amount + 1) / 10 AS INT64) AS priority_score
  )
);
```

### 4. Stored Procedures（複雑なビジネスロジック）
```sql
-- 月次集計処理
CREATE OR REPLACE PROCEDURE `dm_business_planning.sp_monthly_revenue_aggregation`(
  target_month STRING
)
BEGIN
  DECLARE row_count INT64;
  
  -- 既存データのバックアップ
  CREATE OR REPLACE TABLE `dm_business_planning.backup_monthly_revenue_{target_month}`
  AS SELECT * FROM `dm_business_planning.fact_monthly_revenue`
  WHERE jst_month = target_month;
  
  -- 新規データの集計
  DELETE FROM `dm_business_planning.fact_monthly_revenue`
  WHERE jst_month = target_month;
  
  INSERT INTO `dm_business_planning.fact_monthly_revenue`
  SELECT 
    target_month AS jst_month,
    product_key,
    revenue_type,
    SUM(amount) AS total_amount,
    COUNT(DISTINCT account_id) AS customer_count,
    `dm_business_planning.calculate_mrr`(SUM(amount), revenue_type) AS mrr_impact
  FROM `dm_business_planning.raw_transactions`
  WHERE DATE_TRUNC(transaction_date, MONTH) = target_month
  GROUP BY product_key, revenue_type;
  
  SET row_count = @@row_count;
  
  -- ログ記録
  INSERT INTO `dm_business_planning.etl_log`
  VALUES (
    GENERATE_UUID(),
    'sp_monthly_revenue_aggregation',
    target_month,
    row_count,
    CURRENT_TIMESTAMP()
  );
END;
```

### 5. INFORMATION_SCHEMAでのメタデータ管理
```sql
-- ビジネスロジック関数の一覧取得
SELECT 
  routine_schema,
  routine_name,
  routine_type,
  routine_definition,
  created,
  last_altered
FROM `dm_business_planning.INFORMATION_SCHEMA.ROUTINES`
WHERE routine_type IN ('FUNCTION', 'PROCEDURE')
ORDER BY last_altered DESC;

-- テーブル説明とラベルの取得
SELECT 
  table_name,
  option_name,
  option_value
FROM `dm_business_planning.INFORMATION_SCHEMA.TABLE_OPTIONS`
WHERE option_name IN ('description', 'labels')
ORDER BY table_name;

-- カラム説明の一覧
SELECT 
  table_name,
  column_name,
  data_type,
  description
FROM `dm_business_planning.INFORMATION_SCHEMA.COLUMN_FIELD_PATHS`
WHERE description IS NOT NULL
ORDER BY table_name, ordinal_position;
```

### 6. Materialized Views（事前計算されたKPI）
```sql
-- 日次更新されるKPIビュー
CREATE MATERIALIZED VIEW `dm_business_planning.mv_daily_kpis`
PARTITION BY DATE(calculation_date)
CLUSTER BY product_key
AS
SELECT 
  CURRENT_DATE() AS calculation_date,
  product_key,
  
  -- ARR計算
  SUM(CASE 
    WHEN revenue_type = 'new_logo' THEN amount * 12
    WHEN revenue_type IN ('upsell', 'crosssell') THEN amount * 12
    ELSE 0 
  END) AS arr,
  
  -- Churn Rate
  SAFE_DIVIDE(
    COUNT(DISTINCT CASE WHEN revenue_type = 'logo_churn' THEN account_id END),
    COUNT(DISTINCT account_id)
  ) AS churn_rate,
  
  -- Net Revenue Retention
  SUM(CASE 
    WHEN revenue_type IN ('upsell', 'crosssell') THEN amount
    WHEN revenue_type IN ('downsell', 'product_churn') THEN -amount
    ELSE 0
  END) / NULLIF(SUM(CASE WHEN revenue_type = 'new_logo' THEN amount END), 0) AS nrr

FROM `dm_business_planning.fact_revenue`
WHERE DATE(transaction_date) = CURRENT_DATE() - 1
GROUP BY product_key;
```

### 7. Scheduled Queries（定期実行）
```sql
-- 毎日午前2時に実行されるKPI更新
CREATE OR REPLACE SCHEDULED QUERY 
  `dm_business_planning.daily_kpi_calculation`
OPTIONS (
  query = """
    CALL dm_business_planning.sp_monthly_revenue_aggregation(
      FORMAT_DATE('%Y-%m', CURRENT_DATE())
    );
  """,
  destination_dataset_id = 'dm_business_planning',
  schedule = 'every day 02:00',
  time_zone = 'Asia/Tokyo'
);
```

### 8. Row Access Policies（部門別アクセス制御）
```sql
-- 営業チーム別のデータアクセス制御
CREATE OR REPLACE ROW ACCESS POLICY sales_team_access
ON `dm_business_planning.fact_opportunities`
GRANT TO ("group:sales-team@company.com")
FILTER USING (owner_team = SESSION_USER());

-- 地域別アクセス制御
CREATE OR REPLACE ROW ACCESS POLICY region_access
ON `dm_business_planning.dim_member`
GRANT TO ("group:japan-team@company.com")
FILTER USING (region IN ('Japan', 'Global'));
```

## 管理クエリ集

### ビジネスロジック棚卸し
```sql
-- 全UDF/Stored Procedureの一覧
SELECT 
  routine_type,
  routine_name,
  created,
  last_altered,
  routine_definition
FROM `dm_business_planning.INFORMATION_SCHEMA.ROUTINES`
ORDER BY routine_type, routine_name;
```

### メタデータ検索
```sql
-- 特定のビジネス用語を含むテーブル/カラムを検索
SELECT 
  table_name,
  column_name,
  description
FROM `dm_business_planning.INFORMATION_SCHEMA.COLUMN_FIELD_PATHS`
WHERE LOWER(description) LIKE '%revenue%'
   OR LOWER(description) LIKE '%売上%';
```

### 依存関係分析
```sql
-- ビューの依存関係
SELECT 
  table_name AS view_name,
  base_table_name,
  base_table_type
FROM `dm_business_planning.INFORMATION_SCHEMA.VIEW_TABLE_DEPENDENCIES`
ORDER BY table_name, base_table_name;
```

## ベストプラクティス

1. **Description規約**
   - 必ず日本語と英語で記載
   - バージョン番号を含める
   - オーナー情報を明記
   - 更新履歴を記録

2. **UDF命名規則**
   - `calculate_*`: 計算処理
   - `get_*`: 取得処理
   - `validate_*`: 検証処理
   - `transform_*`: 変換処理

3. **ラベル活用**
   - owner: 責任者/チーム
   - sensitivity: public/internal/confidential
   - update-frequency: daily/weekly/monthly/static
   - version: セマンティックバージョニング

4. **定期メンテナンス**
   - 月次でINFORMATION_SCHEMAから棚卸し
   - 四半期ごとにUDF/SPの見直し
   - 年次でアクセスポリシーの監査

## 次のステップ

1. 既存テーブルへのdescription/labels追加
2. 共通ビジネスロジックのUDF化
3. 定期集計処理のScheduled Query設定
4. アクセス制御ポリシーの実装