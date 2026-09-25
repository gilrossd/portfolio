-- DATA CLEANING

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null values or Blanks
-- 4. Remove unneccessary Columns


-- 1. Remove Duplicates
-- CREATE staging table
CREATE TABLE layoffs_dup
LIKE layoffs;

INSERT INTO layoffs_dup
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_duplicate;

-- add row_num column to put unique id in each row
CREATE TABLE layoffs_duplicate AS
SELECT *,
       ROW_NUMBER() OVER (
           PARTITION BY company,
                        location,
                        industry,
                        total_laid_off,
                        percentage_laid_off,
                        `date`,
                        stage,
                        country,
                        funds_raised_millions
       ) AS row_num
FROM layoffs_dup;

-- identify duplicates
SELECT *
FROM layoffs_duplicate
WHERE row_num > 1;

-- delete duplicate
DELETE
FROM layoffs_duplicate
WHERE row_num > 1;

-- 2. Standadize Data
SELECT DISTINCT company
FROM layoffs_duplicate;

SELECT company, TRIM(company)
FROM layoffs_duplicate;

UPDATE layoffs_duplicate
SET company = TRIM(company);

SELECT DISTINCT industry
from layoffs_duplicate;

SELECT DISTINCT industry
FROM layoffs_duplicate
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_duplicate
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT location
FROM layoffs_duplicate
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_duplicate
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_duplicate
ORDER BY 1;

UPDATE layoffs_duplicate
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- change date format to YYYY-MM-DD
SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_duplicate;

UPDATE layoffs_duplicate
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

SELECT `date`
FROM layoffs_duplicate;

-- change data type to date
ALTER TABLE layoffs_duplicate
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_duplicate;

-- 3. fill null values and blanks (if possible)
SELECT *
FROM layoffs_duplicate
WHERE industry IS NULL 
OR industry = '';

SELECT *
FROM layoffs_duplicate
WHERE company = 'Airbnb';

-- USE SELF JOIN to fills in missing industry values by finding another row for the same company where industry is already known.
SELECT t1.industry, t2.industry
FROM layoffs_duplicate t1
JOIN layoffs_duplicate t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- SET ' ' to NULL
UPDATE layoffs_duplicate
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_duplicate t1
JOIN layoffs_duplicate t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_duplicate;

SELECT *
FROM layoffs_duplicate
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- 4. DELETE Column
-- delete unneccessary columns
DELETE
FROM layoffs_duplicate
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_duplicate
DROP COLUMN row_num;

SELECT *
FROM layoffs_duplicate;