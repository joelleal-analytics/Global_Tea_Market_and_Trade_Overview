/*
=============================================================================================================
Script: 02_pricing_and_unit_economics.sql
Business Objective: Determine which countries command the highest implied export price per unit.
Key techniques: Data Integrity (COALESCE and NULLIF), HAVING clause
=============================================================================================================
*/

USE global_tea_market_and_trade_overview_db;

SELECT 
Country AS country,
SUM(CASE WHEN Metric = 'Export Value' THEN Value ELSE 0 END) AS total_export_value,
SUM(CASE WHEN Metric = 'Export Quantity' THEN Value ELSE 0 END) AS total_export_quantity,

-- NULLIF turns a 0 into NULL to avoid division-by-zero errors. COALESCE then cathces the NULL and replaces it with 0 in the final value.
ROUND(
	COALESCE(
		SUM(CASE WHEN Metric = 'Export Value' THEN Value ELSE 0 END) /
        NULLIF(SUM(CASE WHEN Metric = 'Export Quantity' THEN Value ELSE 0 END), 0),
        0), 2) AS implied_price_per_unit
FROM fact_global_tea_data
GROUP BY country

-- Filters out exporters that have exported less than 100,000 units in total.
HAVING total_export_quantity >= 100000
ORDER BY implied_price_per_unit DESC
LIMIT 5
;
