CREATE DATABASE project101;

USE project101;
SELECT * FROM hr;

-- changing the id name to emp_id--
ALTER TABLE hr
CHANGE COLUMN ï»¿id emp_id VARCHAR(20) NULL;

-- Getting Description of the datatypes of the columns
DESCRIBE hr;

-- Allowing to update our database
SET sql_safe_updates = 0;
SET GLOBAL sql_mode = '';

SELECT birthdate from hr;

-- Upadating the datatypes in all date related columns
-- birthdate
UPDATE hr
SET birthdate = CASE
	WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;
    
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;
    
-- hire_date
UPDATE hr
SET hire_date = CASE
	WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;

-- Updating the column datatype from text ot date
ALTER TABLE hr
MODIFY COLUMN hire_date DATE;

SELECT hire_date from hr;

-- Updating the termdate to date and removing the time section
UPDATE hr
SET termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate != '';

ALTER TABLE hr
MODIFY COLUMN termdate DATE;

SELECT NULLIF(termdate,'') from hr;
set session sql_mode=replace(@@sql_mode,'hr','');

SELECT termdate FROM hr;

SELECT * FROM hr
INTO OUTFILE 'hr.csv';

-- Adding an age column to make it easier to look for outlier in the birthdate column
ALTER TABLE hr ADD COLUMN age INT;

UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());

-- Checking for the ranges of the ages
SELECT
	min(age) AS youngest,
    max(age) AS oldest
FROM hr;

-- conditional statement to see who are below 0 age which is wrong
SELECT count(*) FROM hr WHERE age < 18;

-- checking if we did add the new column
SELECT age FROM hr;

    