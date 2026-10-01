/*
=========================================================================================================
 Script: 01_trade_analysis.sql
 Business Ojectives: Identify the five countries with the highest export volume as well as the 
					 five countries with the highest import volume.
 Key Techniques: CTEs, Window Functions (DENSE RANK), 
=========================================================================================================
*/

USE global_tea_market_and_trade_overview_db;

WITH countrybalances AS (
SELECT
Country AS country,

-- Aggregates export values, and import values while ignoring other values in the Metric column.
SUM(CASE WHEN Metric = 'Export Value' THEN Value ELSE 0 END) AS total_export_value,
SUM(CASE WHEN Metric = 'Import Value' THEN Value ELSE 0 END) AS total_import_value,

-- Evaluates net trade balance (export value - import value).
SUM(CASE WHEN Metric = 'Export Value' THEN Value ELSE 0 END) - 
SUM(CASE WHEN Metric = 'Import Value' THEN Value ELSE 0 END) AS net_trade_balance
FROM fact_global_tea_data
GROUP BY Country
),
countryranks AS (
SELECT
country,
total_export_value,
total_import_value,
net_trade_balance,

-- Rank countries based on their net trade balance. DESC ranks from highest with 1, and ASC ranks lowest with 1.
DENSE_RANK () OVER (ORDER BY net_trade_balance DESC) AS exporter_rank,
DENSE_RANK () OVER (ORDER BY net_trade_balance ASC) AS importer_rank
FROM countrybalances
)
SELECT 
country,
total_export_value,
total_import_value,
net_trade_balance,
CASE 
	WHEN exporter_rank <=5 THEN 'Top Exporter'
    WHEN importer_rank <=5 THEN 'Top Importer'
END AS category
FROM countryranks
WHERE exporter_rank <=5 OR importer_rank <=5
ORDER BY net_trade_balance DESC
;


