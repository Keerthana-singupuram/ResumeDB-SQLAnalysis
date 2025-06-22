-- List all people who have more than 5 years of experience.
SELECT * FROM experience;
SELECT COUNT(person_id) AS Exp_Yrs FROM experience
WHERE parsed_start_date - end_date > 5;

-- Show all rows from education where the degree is 'Masters'.
SELECT * FROM education
WHERE institution LIKE 'Master%';

-- Find all skills that start with 'Data'.
SELECT * FROM person_skills
WHERE skill LIKE 'Data %';

-- List people who don’t have any experience entries yet.
SELECT * FROM experience
WHERE parsed_start_date - end_date <= 0;

-- Retrieve all distinct education levels available in the database.
SELECT DISTINCT institution FROM education;

-- Get the institution and email of each person along with their top skill.
SELECT education.person_id, institution, email,skill FROM education
LEFT JOIN people
ON education.person_id = people.person_id
LEFT JOIN person_skills 
ON people.person_id = person_skills.person_id
WHERE skill IS NOT NULL
ORDER BY institution DESC;

-- List all people with their degrees(custom) and years of graduation(start_date).
SELECT people.name, education.custom, education.start_date
FROM people
LEFT JOIN education
ON people.person_id = education.person_id
WHERE custom IS NOT NULL;

-- Show all people along with the skills they have (join people, person_skills).
SELECT people.name, person_skills.skill
FROM people
LEFT JOIN person_skills
ON people.person_id = person_skills.person_id;

-- Which abilities are linked to which people? (join with abilities)
SELECT abilities.ability, people.name
FROM abilities
LEFT JOIN people
ON abilities.person_id = people.person_id;

-- List people with both education and experience entries.
SELECT people.name,education.institution, experience.title, experience.firm
FROM people
LEFT JOIN education
ON people.person_id = education.person_id
LEFT JOIN experience
ON education.person_id = experience.person_id
ORDER BY title DESC;

-- Count how many people have each skill.
SELECT skill, COUNT(person_id) AS Count_Emp
FROM person_skills
GROUP BY skill
ORDER BY Count_Emp DESC;

-- How many people have completed 'Bachelor’s' vs 'Master’s' vs 'PhD'?
SELECT Custom AS Graduation, COUNT(person_id) AS Count FROM education WHERE Custom IN ('Bachelors', 'Masters','PhD')
GROUP BY Custom;

-- Get the average experience duration per person.
SELECT * FROM experience;
SELECT person_id, ROUND(AVG(end_date - start_date),2) AS Avg
FROM experience
GROUP BY person_id
HAVING Avg > 0;

-- Count the number of people per graduation.
SELECT people.person_id, people.name, education.Custom
FROM people
LEFT JOIN
education ON people.person_id = education.person_id
WHERE Custom IS NOT NULL
ORDER BY person_id,Custom DESC;

-- Which skill is the most common across all people?
SELECT skill, COUNT(person_id) AS Frequency
FROM person_skills
GROUP BY skill
ORDER BY Frequency DESC;

-- Find people who have the maximum number of skills.
SELECT * FROM person_skills;
SELECT person_id, COUNT(skill) AS Skill_Count
FROM person_skills
GROUP BY person_id
ORDER BY Skill_Count DESC;

-- Get names of people whose experience is above the average.
SELECT p.person_id, p.name, ROUND(AVG(e.end_date - e.start_date),2) AS Avg_Duration
FROM people p
LEFT JOIN experience e
ON p.person_id = e.person_id
WHERE e.end_date - e.start_date > (
SELECT AVG(end_date - start_date) FROM experience 
)
GROUP BY p.person_id,p.name;

-- List all people who don’t have a matching entry in person_skills.
SELECT * FROM people;
SELECT * FROM person_skills;
SELECT p.person_id,p.name, ps.skill
FROM people p
LEFT JOIN person_skills ps
ON p.person_id = ps.person_id
WHERE p.name != ps.skill;

-- Retrieve names of people who have at least one ability and one education record.
SELECT DISTINCT p.name
FROM people p
JOIN abilities a 
ON p.person_id = a.person_id
JOIN education e
ON p.person_id = e.person_id;

-- Find all skills that are not linked to any person.
SELECT * FROM person_skills 
WHERE person_id IS NULL;

-- Show people who started work before 2015.
SELECT * FROM experience
WHERE parsed_start_date < 2015-01-01;

-- Find the earliest and latest start_date from experience.
SELECT * FROM experience
WHERE parsed_start_date = ( SELECT MIN(parsed_start_date) FROM experience )
OR parsed_start_Date = ( SELECT MAX(parsed_start_date) FROM experience );

-- Show how many people started their first job each year.
SELECT DISTINCT(YEAR(parsed_start_date)) AS Year, COUNT(person_id) AS COUNT
FROM experience
GROUP BY Year
ORDER BY Year;

-- List people whose experience overlaps with education time (if you have date ranges).
SELECT DISTINCT ex.person_id FROM experience ex
JOIN education ed
ON ex.person_id = ed.person_id
WHERE ed.start_date <= ex.parsed_start_date;

-- Rank people by total number of skills they have.
SELECT person_id, 
	COUNT( skill) AS Count,
	RANK() OVER(ORDER BY COUNT(skill)) AS skill_rank
FROM person_skills
GROUP BY person_id;

-- Show cumulative experience years using SUM OVER for each person.
SELECT * FROM experience;
SELECT person_id,
YEAR(MAX(parsed_Start_date)) AS max_year,
YEAR(MIN(parsed_start_date)) AS min_year,
YEAR(MAX(parsed_Start_date)) - YEAR(MIN(parsed_start_date)) AS cumulative_exp
FROM experience
GROUP BY person_id;
# not performing sum() over() as start_date and end_date are in consistent.

-- Display top 3 most experienced people per education level.
SELECT experience.person_id,
YEAR(MAX(parsed_Start_date)) - YEAR(MIN(parsed_start_date)) AS cumulative_exp,
education.Custom as education_level
FROM experience
LEFT JOIN education
ON experience.person_id = education.person_id
GROUP BY person_id, education_level
ORDER BY cumulative_exp DESC
LIMIT 3;

-- Get skill frequency using ROW_NUMBER to rank skill popularity.
SELECT skill, 
COUNT(skill) AS skill_count, 
ROW_NUMBER() OVER(ORDER BY COUNT(skill) DESC) AS skill_rank
FROM person_skills
GROUP BY skill;

-- CTE learning to compare RANK() and ROW_NUMBER()
WITH skill_counts AS (
  SELECT 
    skill, 
    COUNT(*) AS skill_count
  FROM person_skills
  GROUP BY skill
)
SELECT 
  skill,
  skill_count,
  RANK() OVER (ORDER BY skill_count DESC) AS rank_order,
  ROW_NUMBER() OVER (ORDER BY skill_count DESC) AS row_number_order
FROM skill_counts;

-- Create a view for complete person profiles (name, education, experience, skills).
CREATE VIEW profile_view AS
(
SELECT people.person_id,
people.name,
education.institution,
education.Custom,
experience.title,
experience.firm,
person_skills.skill FROM people
LEFT JOIN education
ON people.person_id = education.person_id
LEFT JOIN experience
ON people.person_id = experience.person_id
LEFT JOIN person_skills
ON people.person_id = person_skills.person_id
);
SELECT * FROM profile_view;