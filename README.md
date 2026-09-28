# Global Tea Market and Trade Overview
An executive-level Power BI case study analyzing multi-decade global tea production, trade volumes, import/export values, and unit economics across major international markets.

## Executive Dashboard Preview
![Global Tea Market and Trade Overview](https://github.com/joelleal-analytics/Global_Tea_Market_and_Trade_Overview/blob/main/Power%20BI%20images/Tea%20Data%20Global%20Overview.png)

> **Focus:** Evaluating market efficiency, net trade balance, primary production trends, and implied export price performance across top global tea-producing and trading nations.

## Business Problem and Project Goals

Global commodities trade data often suffers from fragmented reporting across volume, value, and production datasets. This project aims to:
1. **Consolidate multi-decade global tea data** (1990-2021) into a clean, analytical model.
2. **Evaluate trade performance** by measuring Net Trade Volume, Import/Export Values, and Trade Balance per country.
3. **Analyze unit economics** using measure branching to calculate the Implied Export Price per Unit.
4. **Deliver an executive dashboard** built with clean visual hierarchy, intuitive conditional formatting, and clean dynamic feedback.

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
