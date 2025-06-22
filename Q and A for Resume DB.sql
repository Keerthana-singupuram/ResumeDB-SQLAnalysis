#SQL Practice Questions for resume Database :

-- 🔹 1. Basic SELECTs & Filters
-- List all people who have more than 5 years of experience.
-- Show all rows from education where the degree is 'Masters'.
-- Find all skills that start with 'Data'.
-- List people who don’t have any experience entries yet.
-- Retrieve all distinct education levels available in the database.

-- 🔹 2. JOINs (Real-World Profile Building)
-- Get the full name and email of each person along with their top skill.
-- List all people with their degrees and years of graduation.
-- Show all people along with the skills they have (join people, person_skills, and skills).
-- Which abilities are linked to which people? (join with abilities)
-- List people with both education and experience entries.

-- 🔹 3. Aggregation & Grouping
-- Count how many people have each skill.
-- How many people have completed 'Bachelor’s' vs 'Master’s' vs 'PhD'?
-- Get the average experience duration per person.
-- Count the number of people per graduation year.
-- Which skill is the most common across all people?

-- 🔹 4. Subqueries
-- Find people who have the maximum number of skills.
-- Get names of people whose experience is above the average.
-- List all people who don’t have a matching entry in person_skills.
-- Retrieve names of people who have at least one ability and one education record.
-- Find all skills that are not linked to any person.

-- 🔹 5. Time-Based (if experience has dates)
-- Show people who started work before 2015.
-- Find the earliest and latest start_date from experience.
-- Show how many people started their first job each year.
-- List people whose experience overlaps with education time (if you have date ranges).

-- 🔹 6. Advanced (Window/CTEs if your DB supports them)
-- Rank people by total number of skills they have.
-- Show cumulative experience years using SUM OVER for each person.
-- Display top 3 most experienced people per education level.
-- Get skill frequency using ROW_NUMBER to rank skill popularity.
-- Create a view for complete person profiles (name, education, experience, skills).