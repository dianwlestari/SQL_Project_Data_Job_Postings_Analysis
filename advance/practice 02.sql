/* Create tables from other tables
Create three tables: Jan, Feb, and March 2023 Jobs */

-- January
CREATE TABLE January_Jobs as
    select * 
    from job_postings_fact
    where extract (month from job_posted_date)=1;

-- February
CREATE TABLE February_Jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE extract (month from job_posted_date) = 2;

-- March
CREATE TABLE March_Jobs AS
    SELECT *
    FROM job_postings_fact
    WHERE extract (month from job_posted_date) = 3;

-- Running one of them
select job_posted_date from March_Jobs limit (10);

/* CASE Expression: to apply conditional logic within your SQL queries 

CASE: first expression
WHEN: specifies the conditions to look at
THEN: what to do when the condition is TRUE
ELSE [optional]: provides output if none of the WHEN are met
END: concludes the CASE expression
*/

-- e.g
select job_title_short, job_location,
    CASE
        when job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location = 'New York, NY' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
from job_postings_fact limit (15);

-- want to know how many jobs base on location_category that I can apply 
select count(job_id) AS number_of_jobs
    case 
        when job_location = 'Anywhere' then 'Remote'
        when job_location = 'New York, NY' then 'Local'
        else 'Onsite'
    end as location_category
from job_postings_fact
GROUP BY location_category;

-- Data analyst
select count(job_id) AS number_of_Data_Analyst,
    case 
        when job_location = 'Anywhere' then 'Remote'
        when job_location = 'New York, NY' then 'Local'
        else 'Onsite'
    end as location_category
from job_postings_fact
where job_title_short = 'Data Analyst'
GROUP BY location_category;

-- PRACTICE PROBLEM
/* categories the salaries from each job posting to see if it fits in my desired
salary range.
 1. Put salary into different buckets
 2. Define what's a high, standard, or low salary with our own conditions
 3. Why? it is easy to determine which job postings are worth looking at
    based on salary. Bucketing is a common practice in data analysis when 
    viewing categories. */

-- answer
select max(salary_hour_avg) as max, min(salary_hour_avg) as min, avg(salary_hour_avg) as averag
from job_postings_fact;

select job_title_short,
    case 
        when salary_hour_avg > 75 then 'High'
        when salary_hour_avg between 45 and 75 then 'Standard'
        when salary_hour_avg < 45 then 'Low'
    end as salary_category
from job_postings_fact;

-- summary of number of high, standard, and low salary per hours
select count(job_title_short),
    case 
        when salary_hour_avg > 75 then 'High'
        when salary_hour_avg between 45 and 75 then 'Standard'
        when salary_hour_avg < 45 then 'Low'
    end as salary_category
from job_postings_fact
GROUP BY salary_category;



