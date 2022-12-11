--questions I’m interested in and they are below.

--1. How many job titles are we looking at? What are they?
--2. Top 10 highest paid salaries vs the average pay of the job
--3. Top 5 most popular jobs and their average pay
--4. What is the average pay for each country?
--5. Do countries pay a lot more than their country average? which ones?
--6. What is the average pay of entry-level jobs?
--7. Which countries pay their entry-level above the general average pay?
--8. Is there a change in average entry-level pay yearly?
--9. How many fully remote jobs do we have?
--10. Do countries pay fully remote entry-level jobs well?


--1. How many job titles are we looking at? What are they?
SELECT *
FROM [Data Science Salary Project].dbo.salaries$

SELECT COUNT(DISTINCT(job_title))
FROM [Data Science Salary Project].dbo.salaries$

SELECT DISTINCT(job_title), COUNT(job_title) OVER(PARTITION BY job_title) AS Counts
FROM [Data Science Salary Project].dbo.salaries$
ORDER BY 2 DESC

--2. Top 10 highest paid salaries vs the average pay of the job

SELECT TOP (10) job_title, salary_in_usd AS Highest_Salary, 
AVG(salary_in_usd) OVER (PARTITION BY job_title) AS Average_Salary
FROM [Data Science Salary Project].dbo.salaries$
ORDER BY salary_in_usd DESC

--3. Top 5 most popular jobs and their average pay
SELECT TOP (5) job_title, ROUND(AVG(salary_in_usd),2) AS Average_salary, COUNT(job_title) AS Counts
FROM [Data Science Salary Project].dbo.salaries$
GROUP BY job_title
ORDER BY Counts DESC


--4. What is the average pay for each country?

SELECT CC.Country,ROUND(AVG(SA.salary_in_usd),2) AS country_avg
FROM [Data Science Salary Project].dbo.salaries$ AS SA
LEFT JOIN [Data Science Salary Project].dbo.Codes$ AS CC
ON SA.company_location = CC.Country_code
GROUP BY CC.Country
ORDER BY country_avg DESC


--5. Do countries pay a lot more than their country average? which ones?


--6. What is the average pay of entry-level jobs?

SELECT experience_level, ROUND(AVG(salary_in_usd),2)
FROM [Data Science Salary Project].dbo.salaries$
GROUP BY experience_level

--7. Which countries pay their entry-level above the general average pay?

SELECT CC.Country, AVG(salary_in_usd) AS Average_Sal
FROM [Data Science Salary Project].dbo.salaries$ AS SAL
LEFT JOIN [Data Science Salary Project].dbo.Codes$ AS CC
ON SAL.company_location = CC.Country_code
WHERE SAL.experience_level LIKE 'Entry%'
GROUP BY CC.[Country ]
HAVING AVG(salary_in_usd) > 62646.5
ORDER BY Average_Sal DESC

--8. Is there a change in average entry-level pay yearly?

SELECT work_year, ROUND(AVG(salary_in_usd),2) AS Avg_Salary
FROM [Data Science Salary Project].dbo.salaries$
WHERE experience_level = 'Entry-Level'
GROUP BY work_year
ORDER BY work_year

--9. How many fully remote jobs do we have?

SELECT COUNT(Mobility)
FROM [Data Science Salary Project].dbo.salaries$
WHERE Mobility = 'Fully Remote'

--OR

SELECT Mobility, COUNT(Mobility)
FROM [Data Science Salary Project].dbo.salaries$
GROUP BY Mobility

--10. Do countries pay fully remote entry-level jobs well?

SELECT CC.[Country ], ROUND(AVG(salary_in_usd),1) AS remote_avg
FROM [Data Science Salary Project].dbo.salaries$ AS SAL
LEFT JOIN [Data Science Salary Project].dbo.Codes$ AS CC
ON SAL.company_location = CC.Country_code
WHERE SAL.experience_level LIKE 'Entry%' AND SAL.Mobility LIKE 'Fully Remote'
GROUP BY CC.[Country ]
ORDER BY remote_avg DESC