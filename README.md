# Retail Sales Analysis 2024–2025

End-to-end data analyst portfolio project: raw sales data cleaned in **Python**, analysed in **MySQL**, summarised in **Excel**, and presented in interactive **Power BI** and **Tableau** dashboards.

![Tableau dashboard](Retail%20Sales%20Dashboard%202024-2025.png)

## Business Questions
- How much did we sell and earn, and how did it change across 2024 and 2025?
- Which categories, regions and customers drive revenue?
- How healthy are margins, returns and delivery times?

## Tools
| Stage | Tool | What I did |
|---|---|---|
| Cleaning | Python (pandas, Jupyter) | Removed duplicates, fixed types, handled missing values, created Profit Margin %, Order Year/Month, Delivery Days |
| Analysis | MySQL | Aggregations, window functions (LAG, RANK, running total), views, normalization into 3 tables |
| Reporting | Excel | tblSales table, PivotTables and charts, SUMIFS/COUNTIFS/XLOOKUP, KPI summary sheet |
| Dashboard | Power BI | DAX measures, KPI cards, slicers, line/bar/donut charts, Top 10 table |
| Dashboard | Tableau | Same KPIs and story rebuilt: KPI tiles, monthly line chart, Top 10 customers, category pie, region bar, Year/Region/Category filters |

## Key Metrics
| KPI | Value |
|---|---|
| Total Sales | 1.40M (1,396,996.27) |
| Total Profit | 278.58K |
| Profit Margin | 19.94% |
| Unique Orders | 4,847 |
| Average Order Value | 288.22 |
| Return Rate | 12.11% |
| Average Delivery Time | 3.50 days |

## Key Findings
1. **Furniture is the largest category (49.04% of sales)**, followed by Clothing (20.15%), Electronics (15.86%), Sports (11.57%) and Groceries (3.38%). Revenue is heavily concentrated in one category.
2. **Profit margin is about 20%**, but a 12.11% return rate is a meaningful leak worth investigating by region and category.
3. **Top customers are spread out**: the top 10 customers contribute 67,728 in sales (about 4.8% of total), led by C1400 (8,271.71). There is no single-customer dependency.
4. **Monthly sales are volatile** across both years, so a rolling or running-total view is more reliable than single-month comparisons.
5. **Average delivery is 3.5 days**, a stable baseline for any service-level target.

## Dashboard
Single-page Power BI report with a title sidebar, 7 KPI cards, slicers (Order Year, Region, Category), monthly sales line chart (2024 vs 2025), Top 10 customers table, sales share by category (donut) and sales by region (bar).

- `retail_sales_dashboard.pbix` - Power BI file
- `dashboard.pdf` - exported report

## Tableau Dashboard
The same analysis rebuilt in Tableau Cloud to compare both tools. It contains three KPI tiles (Total Sales, Total Profit, Total Orders), a monthly sales line chart (2024 vs 2025), a Top 10 customers bar chart, a sales-by-category pie, a sales-by-region bar chart, and Year, Region and Category filters that apply to every chart. The numbers match Power BI, Excel and SQL.

- `Retail Sales Dashboard 2024-2025.pdf` - Tableau export
- `Retail Sales Dashboard 2024-2025.png` - Tableau screenshot

### DAX measures
```
Total Sales = SUM(retail_sales_clean_data[Sales])
Total Profit = SUM(retail_sales_clean_data[Profit])
Profit Margin % = DIVIDE([Total Profit], [Total Sales]) * 100
Total Orders = DISTINCTCOUNT(retail_sales_clean_data[Order ID])
Avg Order Value = DIVIDE([Total Sales], [Total Orders])
Return Rate % = DIVIDE(CALCULATE(DISTINCTCOUNT(retail_sales_clean_data[Order ID]),
                retail_sales_clean_data[Returned] = "Yes"), [Total Orders]) * 100
Avg Delivery Days = AVERAGE(retail_sales_clean_data[Delivery Days])
```

## Repository Structure
```
├── Retail_data.ipynb               # Python cleaning notebook
├── retail_sales_clean_data.csv     # cleaned dataset
├── sql_queries.sql                 # MySQL analysis queries
├── retail_sales_analysis.xlsx      # Excel pivots, formulas, KPI summary
├── retail_sales_dashboard.pbix     # Power BI report
├── dashboard.pdf                   # Power BI dashboard export
├── Retail Sales Dashboard 2024-2025.pdf   # Tableau dashboard export
└── Retail Sales Dashboard 2024-2025.png   # Tableau dashboard screenshot
```

## Data Notes
- An "order" is counted as a unique **Order ID**: 4,847 orders in total (not the number of rows).
- Customer C1287 has a blank Customer Name in the source data.
- Some customers have the Segment value "Unknown" because it was missing in the raw data.
- All totals were cross-checked and match across Python, MySQL, Excel, Power BI and Tableau.

## How to Reproduce
1. Run `Retail_data.ipynb` to clean the raw data and export the CSV.
2. Import the CSV into MySQL as table `sales` (database `retail_project`) and run `sql_queries.sql`.
3. Open `retail_sales_analysis.xlsx` for the Excel analysis.
4. Open `retail_sales_dashboard.pbix` in Power BI Desktop.
5. For Tableau, connect to `retail_sales_clean_data.csv` and rebuild the sheets described above, or view the exported PDF/PNG.

## Author
Muhammad Usama Bin Babar - [LinkedIn](https://www.linkedin.com/in/usama-babar-analyst/)
