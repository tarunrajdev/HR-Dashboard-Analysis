
-- Query 1
SELECT * FROM hr LIMIT 5;

-- Query 2
ALTER TABLE hr
CHANGE COLUMN id emp_id VARCHAR(20) NULL;

-- Query 3
DESCRIBE hr;

-- Query 4
UPDATE hr
SET birthdate = CASE
  WHEN birthdate LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
  WHEN birthdate LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(birthdate, '%m-%d-%y'), '%Y-%m-%d')
  ELSE NULL
END;

-- Query 5
SELECT * FROM hr LIMIT 5;

-- Query 6
DESCRIBE hr;

-- Query 7
UPDATE hr
SET hire_date = CASE
  WHEN hire_date LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
  WHEN hire_date LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m-%d-%y'), '%Y-%m-%d')
  ELSE NULL
END;

-- Query 8
ALTER TABLE hr MODIFY COLUMN hire_date DATE;

-- Query 9
UPDATE hr
SET termdate = date(STR_TO_DATE(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate != ' ';

-- Query 10
SELECT termdate FROM hr LIMIT 10;

-- Query 11
ALTER TABLE hr MODIFY COLUMN termdate DATE;

-- Query 12
ALTER TABLE hr ADD COLUMN age INT;
UPDATE hr SET age = TIMESTAMPDIFF(YEAR, birthdate, CURDATE());

-- Query 13
SELECT 
  MIN(age) AS youngest,
  MAX(age) AS oldest
FROM hr;

-- Query 14
SELECT COUNT(*) FROM hr WHERE age <18;

-- Query 15
SELECT COUNT(*)
FROM hr
WHERE termdate > CURDATE();

-- Query 16
SELECT COUNT(*)
FROM hr
WHERE termdate = '0000-00-00';

-- Query 17
SHOW COLUMNS FROM hr;

-- Query 18
SELECT gender, COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY gender;

-- Query 19
SELECT race, COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY race
ORDER BY count DESC;

-- Query 20
SELECT 
  MIN(age) AS youngest,
  MAX(age) AS oldest
FROM hr
WHERE age >= 18;

-- Query 21
SELECT FLOOR(age/10)*10 AS age_group, COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY FLOOR(age/10)*10;

-- Query 22
SELECT 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END AS age_group, 
  COUNT(*) AS count
FROM 
  hr
WHERE 
  age >= 18
GROUP BY age_group
ORDER BY age_group;

-- Query 23
SELECT 
  CASE 
    WHEN age >= 18 AND age <= 24 THEN '18-24'
    WHEN age >= 25 AND age <= 34 THEN '25-34'
    WHEN age >= 35 AND age <= 44 THEN '35-44'
    WHEN age >= 45 AND age <= 54 THEN '45-54'
    WHEN age >= 55 AND age <= 64 THEN '55-64'
    ELSE '65+' 
  END AS age_group, gender,
  COUNT(*) AS count
FROM 
  hr
WHERE 
  age >= 18
GROUP BY age_group, gender
ORDER BY age_group, gender;

-- Query 24
SELECT location, COUNT(*) as count
FROM hr
WHERE age >= 18
GROUP BY location;

-- Query 25
SELECT ROUND(AVG(DATEDIFF(termdate, hire_date))/365,0) AS avg_length_of_employment
FROM hr
WHERE termdate <> '0000-00-00' AND termdate <= CURDATE() AND age >= 18;

-- Query 26
SELECT ROUND(AVG(DATEDIFF(termdate, hire_date)),0)/365 AS avg_length_of_employment
FROM hr
WHERE termdate <= CURDATE() AND age >= 18;

-- Query 27
SELECT department, gender, COUNT(*) as count
FROM hr
WHERE age >= 18
GROUP BY department, gender
ORDER BY department;

-- Query 28
SELECT jobtitle, COUNT(*) as count
FROM hr
WHERE age >= 18
GROUP BY jobtitle
ORDER BY jobtitle DESC;

-- Query 29
SELECT department, COUNT(*) as total_count, 
    SUM(CASE WHEN termdate <= CURDATE() AND termdate <> '0000-00-00' THEN 1 ELSE 0 END) as terminated_count, 
    SUM(CASE WHEN termdate = '0000-00-00' THEN 1 ELSE 0 END) as active_count,
    (SUM(CASE WHEN termdate <= CURDATE() THEN 1 ELSE 0 END) / COUNT(*)) as termination_rate
FROM hr
WHERE age >= 18
GROUP BY department
ORDER BY termination_rate DESC;

-- Query 30
SELECT location_state, COUNT(*) as count
FROM hr
WHERE age >= 18
GROUP BY location_state
ORDER BY count DESC;

-- Query 31
SELECT 
    YEAR(hire_date) AS year, 
    COUNT(*) AS hires, 
    SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations, 
    COUNT(*) - SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS net_change,
    ROUND(((COUNT(*) - SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END)) / COUNT(*) * 100),2) AS net_change_percent
FROM 
    hr
WHERE age >= 18
GROUP BY 
    YEAR(hire_date)
ORDER BY 
    YEAR(hire_date) ASC;

-- Query 32
SELECT 
    year, 
    hires, 
    terminations, 
    (hires - terminations) AS net_change,
    ROUND(((hires - terminations) / hires * 100), 2) AS net_change_percent
FROM (
    SELECT 
        YEAR(hire_date) AS year, 
        COUNT(*) AS hires, 
        SUM(CASE WHEN termdate <> '0000-00-00' AND termdate <= CURDATE() THEN 1 ELSE 0 END) AS terminations
    FROM 
        hr
    WHERE age >= 18
    GROUP BY 
        YEAR(hire_date)
) subquery
ORDER BY 
    year ASC;

-- Query 33
SELECT department, ROUND(AVG(DATEDIFF(CURDATE(), termdate)/365),0) as avg_tenure
FROM hr
WHERE termdate <= CURDATE() AND termdate <> '0000-00-00' AND age >= 18
GROUP BY department;
