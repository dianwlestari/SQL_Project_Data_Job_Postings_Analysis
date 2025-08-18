-- What skills are required for these top-paying jobs

SELECT * from skills_dim LIMIT(5);
select * from skills_job_dim LIMIT(5);
select distinct(job_schedule_type) from job_postings_fact;

with job_top_paying as (
    select  jp.job_id,
            jp.job_title,
            jp.job_via,
            jp.job_no_degree_mention,
            jp.salary_year_avg
    from job_postings_fact as jp
    where jp.salary_year_avg is not NULL AND
        jp.job_title_short = 'Data Analyst' 
    ORDER BY jp.salary_year_avg DESC LIMIT(10)
)
select  job_top_paying.*,
        skills_dim.skills
from job_top_paying 
INNER JOIN skills_job_dim on job_top_paying.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY job_top_paying.salary_year_avg DESC
LIMIT (10);