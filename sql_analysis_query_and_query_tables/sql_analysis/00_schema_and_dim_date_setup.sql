/*
===================================================================
Script: 00_schema_and_dim_date_setup.sql
Key Techniques: UNION ALL, Recursive CTE
===================================================================
*/

CREATE DATABASE global_tea_market_and_trade_overview_db;

CREATE TABLE dim_date (
	year INT PRIMARY KEY
    );
    
INSERT INTO dim_date (year)
WITH RECURSIVE years AS (
	SELECT 1990 AS year
    UNION ALL
    SELECT year + 1 FROM years WHERE year < 2021
    )
SELECT year FROM years;