-- Data Cleaning

SELECT *
FROM layoffs;

-- 1. Remove Duplicates




CREATE TABLE layoffs_staging
LIKE layoffs;


SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
select *
from layoffs;


select *,
ROW_NUMBER() OVER(
	PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
from layoffs_staging;


WITH duplicate_cte AS
(
select *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
from layoffs_staging
)
select * 
FROM duplicate_cte
WHERE row_num > 1;


select * 
from layoffs_staging
WHERE company = 'Casper';



WITH duplicate_cte AS
(
select *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
from layoffs_staging
)
DELETE 
FROM duplicate_cte
WHERE row_num > 1;





CREATE TABLE `layoffs_staging2` (
  `company` text,			
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


select * 
from layoffs_staging2
WHERE row_num > 1;

INSERT INTO layoffs_staging2
select *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, 
total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) AS row_num
from layoffs_staging;


DELETE
FROM layoffs_staging2
WHERE row_num > 1;

select * 
from layoffs_staging2;


-- 2. Standardizing data

SELECT company,(TRIM(company))
FROM layoffs_staging2;


UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
;



SELECT *
FROM layoffs_staging2
WHERE industry like 'Crypto%';

UPDATE layoffs_staging2
set industry = 'Crypto'
WHERE industry LIKE 'Crypto%';



SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
order by 1;



UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');


ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


SELECT *
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off IS NULL
;


-- 3. Null Values or blank values



SELECT *
FROM layoffs_staging2;


update layoffs_staging2
set `total_laid_off` = NULL
where `total_laid_off` = 'NULL'
;


update layoffs_staging2
set `percentage_laid_off` = NULL
where `percentage_laid_off` = 'NULL';

update layoffs_staging2
set `funds_raised_millions` = NULL
where `funds_raised_millions` = 'NULL';


SELECT *
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off IS NULL
;



SELECT *
FROM layoffs_staging2;




SELECT *
FROM layoffs_staging2
where industry is null
or industry = '';


update layoffs_staging2
set `industry` = NULL
where `industry` = 'NULL';



SELECT *
FROM layoffs_staging2
where company = 'Airbnb';

update layoffs_staging2
set industry = NULL
where industry = '';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;


UPDATE layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
SET t1.industry = t2.industry
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;





SELECT *
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off IS NULL
;

delete 
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off IS NULL;


SELECT *
FROM layoffs_staging2;


-- 4. Remove Any Columns

ALTER TABLE layoffs_staging2
drop column row_num;