Project 03: Bike Buyers Customer Analysis

An exploratory data analysis project examining customer demographic factors—including income levels, age groups, commute distances, and geographic regions—to identify key purchasing patterns and optimize marketing strategies for bike sales.


Project Overview

Understanding customer demographics is essential for targeted advertising, inventory planning, and revenue optimization. This project analyzes a dataset of 1,000+ customer records to identify the primary drivers behind bicycle purchases. 

The workflow involved cleaning raw customer records, engineering age bracket categories, aggregating data using PivotTables, and constructing an interactive Excel dashboard equipped with dynamic slicers.

Tools Used

- Excel: Data cleaning, nested logic formulas, duplicate removal, and data formatting.
- PivotTables & PivotCharts: Data aggregation and summary metrics.
- Interactive Charts: Dynamic filtering by Region, Education Level, and Marital Status.


Data Cleaning & Transformation

1. Deduplication: Identified and removed duplicate customer entries to maintain data integrity.
2. Value Standardization: Cleaned categorical variables across columns. Converting M / S to Married / Single, and F / M to Female / Male
3. Formulated another column for age brackets using NESTED IFS.
   - Adolescent: Under 31 years old
   - Middle Age: 31 to 54 years old
   - Old: 55 years old and above
4. Formatting: Standardized income variables into standard currency formatting $ and adjusted commute distance order for clear visualization.


Key Findings & Insights

- Income Correlation: Higher income levels positively correlate with bike purchases across all genders. Customers who purchased a bike had an average income of $57,475, compared to $55,028 for non-buyers.
- Primary Age Demographic: The Middle Age cohort (31–54 years old) represents the vast majority of buyers (393 purchases out of 495 total buyers). Conversion rates drop sharply among Adolescents and Older age groups.
- Commute Distance Impact: Customers living within 0–1 miles of work demonstrated the highest purchase rate (207 buyers vs. 171 non-buyers). Purchase likelihood declines significantly as commute distance exceeds 5 miles.
- Regional Variation: The Pacific region achieved the highest overall conversion rate (~58.9%), whereas North America had the largest overall volume of non-buyers (288 non-buyers vs. 220 buyers).
- Marital Status: Single individuals demonstrated a higher purchasing inclination (259 buyers out of 477) compared to married individuals (236 buyers out of 549).
