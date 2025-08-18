-- what are the most in-demand skills for my role
with job_data_analyst as (
    select job_title_short, job_id 
    from job_postings_fact
    where job_title_short = 'Data Analyst' 
)

select  skills_dim.skills,
        count(skills_job_dim.skill_id) as skills_count
from job_data_analyst
left JOIN skills_job_dim on job_data_analyst.job_id = skills_job_dim.job_id
left JOIN skills_dim on skills_dim.skill_id = skills_job_dim.skill_id
group by skills_dim.skills 
order by skills_count desc limit(10);

-- alternatif answer here below
select  skills_dim.skills,
        count(skills_job_dim.skill_id) as skills_count
from job_postings_fact
LEFT JOIN skills_job_dim on skills_job_dim.job_id = job_postings_fact.job_id
LEFT JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
GROUP BY skills_dim.skills
ORDER BY skills_count DESC 
LIMIT (10);

