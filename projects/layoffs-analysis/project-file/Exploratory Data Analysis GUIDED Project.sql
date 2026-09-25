-- Exploratory Data Analysis

SELECT *
FROM layoffs_duplicate;

-- max laid off and max percentage laid off
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_duplicate;

-- filter percentage laid off is equal to 100%
SELECT *
FROM layoffs_duplicate
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- total laid off per company
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoffs_duplicate
GROUP BY company
ORDER BY 2 DESC;

-- start and end off laid offs
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_duplicate;

-- total laid off per country
SELECT country, SUM(total_laid_off) AS total_laid_off
FROM layoffs_duplicate
GROUP BY country
ORDER BY 2 DESC;

-- total laid off per year
SELECT YEAR(`date`), SUM(total_laid_off) AS total_laid_off
FROM layoffs_duplicate
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- total laid offs by company
SELECT stage, SUM(total_laid_off) AS total_laid_off
FROM layoffs_duplicate
GROUP BY stage
ORDER BY 2 DESC;

-- total laid off per month
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_laid_off
FROM layoffs_duplicate
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1;

-- rolling total of laid offs per month
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_duplicate
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER (ORDER BY `MONTH`) as rolling_total
FROM Rolling_Total;

-- total laid off per company per year
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_duplicate
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

-- Top 5 company by total laid off by year 
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_duplicate
GROUP BY company, YEAR(`date`)
), 
Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT * 
FROM Company_Year_Rank
WHERE Ranking <=5;








