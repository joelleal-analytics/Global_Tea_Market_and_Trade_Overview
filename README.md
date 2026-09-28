# Global Tea Market and Trade Overview

## Executive Summary
An executive-level Power BI case study analyzing multi-decade global tea production, trade volumes, import/export values, and unit economics across major international markets from 1990 - 2021. By transforming raw FAOSTAT commodity data into a unified Star Schema model, this dashboard enables stakeholders to quickly identify primary supply centers, trade deficits, and pricing power anomalies across global markets.

> **Dashboard Preview**

![Global Tea Market and Trade Overview](https://github.com/joelleal-analytics/Global_Tea_Market_and_Trade_Overview/blob/main/Power%20BI%20images/Tea%20Data%20Global%20Overview.png)

> **Focus:** Evaluating market efficiency, net trade balance, primary production trends, and implied export price performance across top global tea-producing and trading nations.

## Business Problem and Project Goals

Global commodities trade data often suffers from fragmented reporting across volume, value, and production datasets making it difficult for analysts to evaluate total market performance. This addresses these challenges by:
1. **Consolidate multi-decade global tea data** (1990-2021) into a clean, analytical model.
2. **Evaluate trade performance** by measuring Net Trade Volume, Import/Export Values, and Trade Balance per country.
3. **Analyze unit economics** using measure branching to calculate the Implied Export Price per Unit.
4. **Deliver an executive dashboard** built with clean visual hierarchy, intuitive conditional formatting, and clean dynamic feedback.

## Key Business Insights

1. **Top Net Exporters:** Sri Lanka and China dominate global net trade balances with Sri Lanka demonstrating exceptional export-to-production alignment.
2. **Trade Deficit Highlights:** Major global transit hubs and consuming regions (e.g., Hong Kong SAR, UK, UAE) show consistent trade deficits , reflecting heavy reliance on primary producing countries.
3. **Unit Economics and Pricing Discrepancies:** Calculating the Implied Export Price per unit reveals stark operational contrasts that is, bulk raw commodity exporters average \$2,000-\$2,500/unit, whereas value-add and re-export centers realize premium values exceeding \$8,000+/unit.

## Data Architecture and Star Schema

The data was transformed and structured into a standard **Star Schema** to optimize query performance and simplify DAX measure logic.

* **`Fact_Global_Tea_Data`**: Unpivoted and standardized fact table containing metrics for Production Quantity, Export Quantity, Import Quantity, Export Value, and Import Value.
* **`Dim_Year`**: Continuous year dimension that enables seamless time-series filtering.
* **`Dim_Country`**: Dimension table containing unique countries and regional custom territories.

## Key DAX Measures and Logic

To maintain clean code and maximum reusability, calculations were built using **Measure Branching**:

```dax
1. Core base Metrics
Total Value = SUM ('Fact_Global_Tea_Data'[Value])

2. Import and Export Values, and Trade Balance
Import value = 
  CALCULATE (
    [Total Value],
    'Fact_Global_Tea_Data'[Metric] = "Import Value"
  )

Export Value =
  CALCULATE (
   [Total Value],
    'Fact_Global_Tea_Data'[Metric] = "Export Value"
  )

Trade Balance = [Export Value] - [Import Value]

3. Unit Economics
Implied Export Price per Unit =
  DIVIDE (
    [Export Value],
    [Export Quantity]
  )

4. Dynamic Visual Formatting
Bar Color Trade Balance =
  IF (
    [Trade Balance] < 0,
    "#B84A39",
    "#2E3A24"
  )
```

## Data Integrity and Governance Audit

During data validation and cross-entity inspection, an interesting reporting anomaly was uncovered:
* Observation: **China, Mainland** generated **$24B Trade Balance** but showed zero Primary Production Quantity in coutry-level filtering.
* Root Cause Analysis: Direct inspection if Fact_Table_Tea_Data revealed that FAOSTAT reports trade metrics (Import/Export) under specific custom territories (e.g., China Mainland, China Hon Kong SAR, China Taiwan Province, and China Macao SAR), whereas primary harvest production quantity is aggreagated under the parent entity label (i.e., China).
* Engineering Recommendation: In an enterprise ETL production environment, an entity-resolution mapping layer (using standardized ISO alpha-3 country codes) should be applied prior to loading into the star schema to merge territorial production into the parent/mainland customs boundary seamlessly.
