/*
=======================================================================================
Script: 03_yoy_growth_volatility.sql
Business Objective: Measure annual export quantity growth and track volatility across 
					global tea markets to identify stable trade partners.
Key Techniques: Window Function (LAG with PARTITION BY)
=======================================================================================
*/
USE global_tea_market_and_trade_overview_db;

SELECT
Country AS country,
Year AS year,
SUM(CASE WHEN Metric = 'Export Quantity' THEN Value ELSE 0 END) AS current_year_export_quantity,

-- PARTITION BY  Country ensures that LAG evaluates the prior export quantity of that same country.
LAG(SUM(CASE WHEN Metric = 'Export Quantity' THEN Value ELSE 0 END), 1) OVER (PARTITION BY Country ORDER BY Year) AS prior_year_export_quantity,

-- This formula calculates the YoY % growth for each Country.
ROUND(
	COALESCE(
		(SUM(CASE WHEN Metric = 'Export Quantity' THEN Value ELSE 0 END) -
		LAG(SUM(CASE WHEN Metric = 'Export Quantity' THEN Value ELSE 0 END), 1) OVER ( PARTITION BY Country ORDER BY Year)) /
        NULLIF(
			LAG(SUM(CASE WHEN Metric = 'Export Quantity' THEN Value ELSE 0 END), 1) OVER (PARTITION BY Country ORDER BY Year),
		0),
	0),
2) AS YoY_growth_pct
FROM fact_global_tea_data
GROUP BY country, year
ORDER BY country, year DESC
;
