-- Exploratory Data Analysis

-- No. of transanctions 
SELECT COUNT(*)
FROM financial_data;

-- DISTINCT companies
SELECT DISTINCT company
FROM financial_data
ORDER BY 1;

-- DISTINCT industry
SELECT DISTINCT industry
FROM financial_data
ORDER BY 1;

-- DISTINCT region
SELECT DISTINCT region
FROM financial_data
ORDER BY 1;

-- What is the total revenue
SELECT ROUND(SUM(Revenue),2) AS Total_Revenue
FROM financial_data;

-- What is the total revenue per company
SELECT Company, ROUND(SUM(Revenue),2) AS Total_Revenue
FROM financial_data
GROUP BY Company
ORDER BY Total_Revenue DESC;

-- Average revenue
SELECT ROUND(AVG(Revenue),2) AS Average_Revenue
FROM financial_data;

-- Highest recorded revenue
SELECT ROUND(MAX(Revenue),2) AS Max_Revenue
FROM financial_data;

-- Lowest recorded revenue
SELECT ROUND(MIN(Revenue),2) AS Min_Revenue
FROM financial_data;

-- Which companies generate the highest operating income?
SELECT Company, SUM(Operating_Income) AS Total_Operating_Income
FROM financial_data
GROUP BY Company
ORDER BY Total_Operating_Income DESC;

-- Which companies have the highest average profit margin?
SELECT Company, AVG(Profit_Margin) AS Avg_Profit_Margin
FROM financial_data
GROUP BY Company
ORDER BY Avg_Profit_Margin DESC;

-- Which companies have the highest average debt-to-assets ratio?
SELECT Company, SUM(Debt_to_Assets) Total_Debt_to_Assets
FROM financial_data
GROUP BY Company
ORDER BY Total_Debt_to_Assets DESC;

-- Which companies have average profit margin greater than 20%

SELECT Company, AVG(Profit_Margin)*100 AS Avg_Profit_Margin
FROM financial_data
GROUP BY Company
HAVING Avg_Profit_Margin > 20
ORDER BY Avg_Profit_Margin DESC;

-- company average debt-to-assets > 40%
SELECT company, AVG(debt_to_assets * 100) AS debt_to_assests_percentage
FROM financial_data
GROUP BY company
HAVING debt_to_assests_percentage > 40
ORDER BY debt_to_assests_percentage DESC;

-- What percentage of total revenue does each company contribute?
SELECT company, ROUND(SUM(revenue),2) AS total_revenue, 
ROUND (SUM(revenue) / (SELECT SUM(revenue) FROM financial_data) * 100,2) AS revenue_percentage
FROM financial_data
GROUP BY company
ORDER BY revenue_percentage DESC;