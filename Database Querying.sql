SHOW DATABASES;
USE resume;
SHOW TABLES;
ALTER TABLE 06_skills RENAME skills;

SHOW TABLE STATUS;

SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = DATABASE();

SELECT CONCAT(
  'DELETE FROM ', table_name,
  ' WHERE id NOT IN (SELECT id FROM (SELECT id FROM ', table_name, ' LIMIT 3000) AS temp);'
) AS delete_command
FROM information_schema.tables
WHERE table_schema = DATABASE();

DELETE FROM abilities WHERE person_id NOT IN (SELECT person_id FROM (SELECT person_id FROM abilities LIMIT 3000) AS temp);

SELECT * FROM people;
DROP TABLE people;

SET SQL_SAFE_UPDATES = 0;

SELECT COUNT(*) FROM abilities;
SHOW TABLE STATUS;

DROP TABLE education;

CREATE TABLE updated_education AS
SELECT * FROM education
LIMIT 3000;

CREATE TABLE updated_person_skills AS
SELECT * FROM person_skills
LIMIT 3000;

DROP TABLE person_skills;

CREATE TABLE updated_skills AS
SELECT * FROM skills
LIMIT 3000;

DROP TABLE skills;

SHOW TABLE STATUS;

ALTER TABLE updated_education RENAME AS education;
ALTER TABLE updated_person_skills RENAME AS person_skills;
ALTER TABLE updated_skills RENAME AS skills;

-- Data Exploration
SHOW TABLE STATUS;
DESCRIBE TABLE abilities;
SHOW COLUMNS FROM abilities;
SELECT COUNT(*) FROM abilities;
SELECT COUNT(DISTINCT ability) FROM abilities;
SELECT COUNT(*) - COUNT(person_id) AS null_count FROM abilities;

-- Value Distribution :  
SELECT ability, count(ability) AS Frequency
FROM abilities
GROUP BY ability
ORDER BY Frequency DESC;

-- Summary Statitics and basic Data Ranges :
 SELECT * FROM experience;
 SELECT MIN(person_id) AS least_id FROM experience;
 SELECT MAX(person_id) AS highest_id FROM experience;
 SELECT * FROM skills;
 
 -- Duplicate Detection
SELECT name, COUNT(name) AS Duplicate_Count
FROM people
GROUP BY name
HAVING COUNT(name) > 1
ORDER BY Duplicate_Count DESC;

-- Time Series or Trend Check
SELECT * FROM experience;

DELETE FROM experience
WHERE start_date = "present";

DELETE FROM experience
WHERE end_date = "present";

SELECT COUNT(DISTINCT start_date) FROM experience;

SELECT * FROM experience
WHERE title REGEXP '^Database';
SELECT * FROM experience
WHERE title REGEXP 'Administrator$';
SELECT * FROM experience
WHERE title REGEXP '^[0-9]{3}';

SELECT * FROM experience;
SELECT start_date,
CASE 
WHEN start_date REGEXP '^[0-9]{4}$' THEN STR_TO_DATE(CONCAT('01/01/', start_date),'%d/%m/%Y')
WHEN start_date REGEXP '^[0-9]{2}/[0-9]{2}$' THEN STR_TO_DATE(CONCAT('01/',start_date),'%d/%m/%Y')
WHEN start_date REGEXP '^[0-9]{4}/$' THEN STR_TO_DATE(CONCAT('01/01/',start_date),'%d/%m/%Y')
WHEN start_date REGEXP '^[0-9]{1,2}/[0-9]{4}$' THEN STR_TO_DATE(CONCAT('01/',start_date),'%d/%m/%Y')
ELSE '00/00/0000'
END AS parsed_date
FROM experience;

UPDATE experience
SET start_date ='01/01/2014'
WHERE start_date = '00/2014';

UPDATE experience
SET start_date ='01/01/2012'
WHERE start_date = '00/2012';

-- Adding parsed date as a column in experience table with above changes :
SELECT * FROM experience;
ALTER TABLE experience DROP COLUMN parsed_date;
ALTER TABLE experience ADD COLUMN parsed_start_date DATE;

UPDATE experience
SET parsed_start_date = CASE 
  WHEN start_date REGEXP '^[0-9]{4}$' THEN STR_TO_DATE(CONCAT('01/01/', start_date), '%d/%m/%Y')
  WHEN start_date REGEXP '^[0-9]{2}/[0-9]{2}$' THEN STR_TO_DATE(CONCAT('01/', start_date), '%d/%m/%Y')
  WHEN start_date REGEXP '^[0-9]{4}/$' THEN STR_TO_DATE(CONCAT('01/01/', REPLACE(start_date, '/', '')), '%d/%m/%Y')
  WHEN start_date REGEXP '^[0-9]{1,2}/[0-9]{4}$' THEN STR_TO_DATE(CONCAT('01/', start_date), '%d/%m/%Y')
  ELSE NULL
END;

-- Monthly trend
SELECT 
  DATE_FORMAT(parsed_start_date, '%Y-%m') AS month,
  COUNT(*) AS count
FROM experience
GROUP BY month
ORDER BY count DESC;

-- Year Trend 
SELECT 
  YEAR(parsed_start_date) AS year,
  COUNT(*) AS count
FROM experience
GROUP BY year
ORDER BY year DESC;

-- Weeks Trends
SELECT DISTINCT YEAR(parsed_start_date) AS Year, WEEK(parsed_start_date) AS Week, COUNT(*) AS Count
FROM experience
GROUP BY Year,week
ORDER BY Year, Week DESC;
