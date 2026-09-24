-- company ranking in term of revenue contribution in the total revenue
WITH company_contribution AS
(
SELECT company, ROUND(SUM(revenue),2) AS total_revenue, 
ROUND (SUM(revenue) / (SELECT SUM(revenue) FROM financial_data) * 100,2) AS revenue_percentage
FROM financial_data
GROUP BY company
ORDER BY revenue_percentage DESC
)
SELECT *, DENSE_RANK () OVER (ORDER BY revenue_percentage DESC) AS Ranking
FROM company_contribution;

-- Which companies generate more than the average revenue of companies in the record?
WITH company_total_revenue AS
(
SELECT company, ROUND(SUM(revenue),2) AS total_revenue
FROM financial_data
GROUP BY company
ORDER BY total_revenue DESC
), average_revenue AS
(
SELECT ROUND(AVG(total_revenue),2) AS company_average_revenue
FROM company_total_revenue
)
SELECT *
FROM company_total_revenue ctr
CROSS JOIN average_revenue ar
WHERE ctr.total_revenue > ar.company_average_revenue;

-- Which companies have higher revenue and debt-to-assets than the average revenue and debt-to-assets
WITH company_stats AS
(
SELECT company, ROUND(SUM(revenue),2) AS total_revenue, Round(SUM(debt_to_assets),2) as total_debt_to_assets
FROM financial_data
GROUP BY company
), average_stats AS
(
SELECT ROUND(AVG(total_revenue),2) AS average_revenue, ROUND(AVG(total_debt_to_assets),2) AS average_debt_to_assets
FROM company_stats
)
SELECT *
FROM company_stats cs
CROSS JOIN average_stats ast
WHERE cs.total_revenue > ast.average_revenue AND cs.total_debt_to_assets > ast.average_debt_to_assets;

-- Which company generated the most revenue in each year?
WITH company_yearly_revenue AS
(
SELECT company, `year`, ROUND(SUM(revenue),2) total_revenue
FROM financial_data
GROUP BY company, `year`
ORDER BY year, total_revenue
)
SELECT company, `year`, total_revenue, DENSE_RANK () OVER (PARTITION BY `year` ORDER BY total_revenue DESC) AS Ranking
FROM company_yearly_revenue;

-- Rank every company based on total revenue.
WITH company_revenue AS
(
SELECT company, ROUND(SUM(revenue),2) AS total_revenue
FROM financial_data
GROUP BY company
)
SELECT *, RANK() OVER(ORDER BY total_revenue DESC) AS Ranking
FROM company_revenue;

-- Which companies has high revenue and high debt to assests than average
WITH company_stats AS
(
SELECT company, ROUND(SUM(revenue),2) AS total_revenue, ROUND(SUM(debt_to_assets),2) AS total_DtA
FROM financial_data
GROUP BY company
), average_stats AS
(
SELECT ROUND(AVG(total_revenue),2) AS average_revenue, ROUND(AVG(total_DtA),2) AS average_debt_to_assets
FROM company_stats
)
SELECT *
FROM company_stats cs
CROSS JOIN average_stats ast
WHERE cs.total_revenue > ast.average_revenue AND cs.total_DtA > ast.average_debt_to_assets;

-- what is the year-over-year revenue changes.
WITH yearly_revenue AS
(
SELECT `year`, ROUND(SUM(revenue),2) AS total_revenue
FROM financial_data
GROUP BY `year`
)
SELECT year, total_revenue,
LAG(total_revenue) OVER (ORDER BY year) AS previous_year_revenue,
ROUND(total_revenue - LAG(total_revenue) OVER (ORDER BY year),2) AS revenue_change,
ROUND((total_revenue - LAG(total_revenue) OVER (ORDER BY year)) / LAG(total_revenue) OVER (ORDER BY year) * 100,2) AS YoY_percentage
FROM yearly_revenue
GROUP BY `year`;

-- Which companies experienced significant changes in any particular year?
WITH yearly_revenue AS 
(
SELECT company, `year`, SUM(revenue) AS revenue
FROM financial_data
GROUP BY company, `year`
),
revenue_change AS (
SELECT company, year, revenue,
LAG(revenue) OVER (PARTITION BY company ORDER BY year
) AS previous_year_revenue
FROM yearly_revenue
)
SELECT company, year, revenue, previous_year_revenue,
ROUND((revenue - previous_year_revenue) / (previous_year_revenue) * 100,2) AS yoy_change_pct
FROM revenue_change
WHERE previous_year_revenue IS NOT NULL
ORDER BY ABS(yoy_change_pct) DESC;

