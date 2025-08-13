-- SUBQUERIES: simple queries
select * from (
    select salary_year_avg, job_title_short, job_posted_date
    from job_postings_fact
    where salary_year_avg > 50000 and EXTRACT (MONTH from job_posted_date)=2
) as salary_in_february;

-- CTE: complex queries [can repeat to use]
with salary_in_april as (
     select salary_year_avg, job_title_short, job_posted_date
    from job_postings_fact
    where salary_year_avg > 50000 and EXTRACT (MONTH from job_posted_date)=4
)
select * from salary_in_april;

select job_posted_date, job_title_short
from salary_in_april
where salary_year_avg > 50000;

------------------------------------------ PRACTICE ---------------------------------------
-- PRACTICE 01: want to now companies who doesnt need degree on their qualification
select table_name
FROM information_schema.tables 
WHERE table_schema = 'public';

select*from job_postings_fact limit (5);

select name as company_name from company_dim
where company_id in (
    select company_id
    from job_postings_fact
    where job_no_degree_mention = TRUE
)


-- PRACTICE 02: just recall with ETC
/* Display the ID and names of companies from company_dim that 
have vacancies without a degree requirement and provide health insurance
based on data in the job_postings_fact table */
select * from company_dim;
select company_id, company_dim.name as companies_name 
from company_dim 
where company_id in (
    select company_id 
    from job_postings_fact 
    where job_no_degree_mention = TRUE and job_health_insurance = TRUE
    order by company_id
)


-- FINAL PRACTICE --
-- 01
/* Find the companies that have the most job openings:
1. get the total number of job postings per company id (job_postings_fact)
2. return the total number of jobs with the company name (company_dim)
*/ 
with number_of_job_counts as (
    select count(job_id) as number_of_job_postings, company_id 
    from job_postings_fact
    GROUP BY company_id 
)
select company_dim.name, number_of_job_postings
from company_dim
left join number_of_job_counts on company_dim.company_id = number_of_job_counts.company_id
order by number_of_job_postings desc limit (50);


-- 02
/* Identify the top 5 skills that are most frequently mentioned in job postings. 
use a subquery to find the skill IDs with the highest counts in the skills_job_dim table and 
then join this result with the skills_dim table to get the skill names. */ 
select * from skills_dim;
select * from skills_job_dim limit (50);

select skills_dim.skill_id, skills_dim.skills as skills_name, top_skills.skills as sum_of_skills
from (
    select skill_id, count(skills_job_dim.skill_id) as skills
    from skills_job_dim 
    GROUP BY skill_id order by skills desc limit(5)
) as top_skills
join skills_dim on top_skills.skill_id = skills_dim.skill_id;


-- 03
/* Determine the size category ('Small', 'Medium', or 'Large') for each company by:
1. firt identifying the number of job postings they have. 
2. Use a subquery to calculate the total job postings per company. 
   - A company is considered the 'Small' if it has less than 10 jobs postings, 
   - the 'Medium' if the number of job postings is between 10 and 50 and 
   - the 'Large' if it */ 
select * from job_postings_fact limit (5);
select * from company_dim limit (5);
select * from skills_job_dim limit (5);

select company_dim.name, 
    case 
        when total_job < 10 then 'Small'
        when total_job between 10 and 50 then 'Medium'
        else 'Large'
    end as size_category, total_job
from (
    select count(skills_job_dim.job_id) as total_job, job_postings_fact.company_id
    from job_postings_fact
    left join skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    GROUP BY job_postings_fact.company_id 
) as category_size_percompany
left join company_dim on category_size_percompany.company_id = company_dim.company_id
limit (10);

-- 04
/* find the count of the number of remote job postings per skill
   - display the top 5 skills by their demand in remote jobs
   - include skill ID, name, and count of postings requiring the skill */

select * from skills_dim limit (5); --skill_id&skills
select * from skills_job_dim limit (5); --job_id&skill_id
select * from job_postings_fact limit (5);
--
with remote_job_postings as (
    select count(skills_job_dim.skill_id) as skills_count, skills_job_dim.skill_id
    from skills_job_dim
    join job_postings_fact on skills_job_dim.job_id = job_postings_fact.job_id
    where  job_postings_fact.job_work_from_home = TRUE 
    GROUP BY job_postings_fact.job_work_from_home, skills_job_dim.skill_id
) 
select skills_dim.skill_id,
        skills_dim.skills,
        remote_job_postings.skills_count
from skills_dim
join remote_job_postings on skills_dim.skill_id = remote_job_postings.skill_id
ORDER BY remote_job_postings.skills_count desc limit (5);








