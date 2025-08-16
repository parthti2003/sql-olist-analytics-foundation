# SQL Olist Analytics Foundation
Advanced real-world SQL analytics project using the Olist Brazilian E-Commerce Dataset for comprehensive business intelligence and data analysis.

## 🎯 Project Overview and Goals
This project demonstrates advanced SQL analytics capabilities through comprehensive analysis of the Olist Brazilian E-Commerce dataset. The primary objectives are:
- **Business Intelligence**: Extract actionable insights from real e-commerce data
- **Data Modeling Excellence**: Implement efficient database structures and relationships
- **Performance Optimization**: Develop optimized queries for large-scale data analysis
- **Analytics Mastery**: Cover diverse analytical scenarios from basic reporting to advanced pattern detection
- **Professional Development**: Showcase industry-standard SQL practices and methodologies

## 📊 Dataset Information
This project utilizes the **Olist Brazilian E-Commerce Public Dataset** - a comprehensive collection of real commercial data generously made available by Olist.

**Dataset Reference**: [Olist E-Commerce Dataset on Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

*Note: The Kaggle link is provided for reference only. This repository contains SQL analysis queries and documentation, not the actual dataset files.*

### Dataset Highlights:
- 100,000+ orders from 2016 to 2018
- Multiple data tables covering orders, products, customers, sellers, and reviews
- Real-world Brazilian e-commerce marketplace data
- Rich relationship structures perfect for advanced SQL analytics

## 🛠️ Key Skills and Technologies
- **SQL**: Advanced querying, joins, subqueries, window functions, CTEs
- **Data Modeling**: Entity relationship design, normalization, indexing strategies
- **Performance Optimization**: Query optimization, execution plan analysis
- **Analytics**: Statistical analysis, trend identification, anomaly detection
- **Business Intelligence**: KPI development, reporting, dashboard preparation
- **Database Management**: Schema design, data integrity, constraint implementation

## 📋 Table of Contents - Analytical Questions
The following comprehensive analysis is covered in `Queries.sql`:

### Product Analytics
1. Top 10 best-selling products by total quantity sold
2. Products with lowest average customer review ratings
3. Total sales and order counts per product category
4. Sales variation by customer city/state for top categories

### Order & Payment Analysis
5. Distribution of order statuses
6. Payment types generating most revenue and order counts
7. Top 5 product categories in canceled orders
8. Products with unusually high return/cancellation rates

### Customer Intelligence
9. Top 10 customers by lifetime value (total spending)
10. Average number of orders per customer
11. Repeat customers & percentage of total customers
12. Customers who ordered from multiple sellers
13. Customers with highest average order values

### Seller & Logistics Performance
14. Sellers with fastest average delivery times
15. Average delivery time differences between states
16. Sellers with highest order volume in different regions

### Temporal & Trend Analysis
17. Monthly trend of total sales over the years
18. Trends in review scores over time for top-selling products
19. Average payment value by payment type and customer segment
20. Average time between order purchase and delivery per seller

### Advanced Analytics
21. Correlation between review scores and product sales volume
22. Detect potential fraudulent orders based on payment/order anomalies
23. Regional performance of product categories (state/city)

## 📁 Repository Structure
```
sql-olist-analytics-foundation/
│
├── README.md              # Project documentation (this file)
├── Queries.sql           # Main SQL analysis file with all queries
├── Schema/               # Database schema and structure files
│   ├── ER diagram.png    # Entity Relationship Diagram
│   └── setup script.sql # Table creation and constraints
├── Documentation/        # Additional project documentation
│   ├── Analysis_Report.md   # Detailed findings and insights
│   └── Performance_Notes.md # Query optimization notes
└── Resources/           # Reference materials and links
    └── Dataset_Info.md  # Detailed dataset documentation
```

## 🚀 How to Use/Run the SQL Queries

### Prerequisites
- SQL database system (PostgreSQL recommended, MySQL compatible)
- Olist dataset imported into your database
- Basic familiarity with SQL execution environments

### Execution Steps
1. **Setup Database**: Import the Olist dataset into your SQL environment
2. **Review Schema**: Examine the table structures in `Schema/setup script.sql`
3. **Execute Queries**: Run individual queries from `Queries.sql`
4. **Analyze Results**: Each query includes comments explaining the business context

*Note: The ER diagram is available as `Schema/ER diagram.png` for reference when understanding table relationships.*

### Query Organization
- Each analytical question is clearly numbered and commented
- Queries are optimized for performance and readability
- Results include business interpretations where applicable
- Complex queries include step-by-step explanations

## 🔮 What's Next - Future Roadmap

### Phase 2: Machine Learning Integration
- **Predictive Analytics**: Customer lifetime value prediction
- **Recommendation Systems**: Product recommendation algorithms
- **Classification Models**: Customer segmentation and churn prediction
- **Time Series Forecasting**: Sales and demand forecasting

### Phase 3: Visualization & Dashboards
- **Interactive Dashboards**: Tableau/Power BI implementations
- **Real-time Analytics**: Streaming data processing
- **Automated Reporting**: Scheduled insight generation
- **Executive Summaries**: High-level KPI tracking

### Phase 4: Advanced Applications
- **API Development**: RESTful services for analytics
- **Cloud Migration**: AWS/Azure deployment strategies
- **Data Pipeline Automation**: ETL process optimization
- **Advanced Statistics**: Econometric modeling and analysis

## 🙏 Credits and Acknowledgments
- **Olist**: Grateful acknowledgment to Olist for making this comprehensive Brazilian e-commerce dataset publicly available
- **Kaggle**: Thanks to the Kaggle platform for hosting and maintaining the dataset
- **Brazilian E-commerce Community**: Appreciation for the real-world data that makes this analysis meaningful and relevant

### Dataset Citation
```
Olist Brazilian E-Commerce Public Dataset
Source: Kaggle (https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
Original Provider: Olist
License: CC BY-NC-SA 4.0
```

---
**Project Maintained by**: [parthti2003](https://github.com/parthti2003)
**Last Updated**: August 2025

*This project is part of a comprehensive data analytics portfolio demonstrating real-world SQL applications in business intelligence and e-commerce analytics.*
