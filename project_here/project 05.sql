-- what are the most optimal skills to learn base on hign demand and high paying

WITH high_demand as (
-- high demand
    select  skills_dim.skill_id,
            skills_dim.skills,
            count(skills_job_dim.skill_id) as skills_count
    from job_postings_fact
    LEFT JOIN skills_job_dim on skills_job_dim.job_id = job_postings_fact.job_id
    LEFT JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    WHERE   job_title_short = 'Data Analyst' and 
            skills_dim.skills is not null AND
            job_postings_fact.salary_year_avg is not NULL
    GROUP BY skills_dim.skill_id
    ORDER BY skills_count DESC 
),
-- high paying
    high_paying as (
    select  skills_dim.skill_id,
            skills_dim.skills, 
            round(avg (salary_year_avg), 0) as salary_average
    from job_postings_fact 
    LEFT JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
    LEFT JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    where   job_title_short = 'Data Analyst' and 
            salary_year_avg is not NULL
    GROUP BY skills_dim.skill_id
    order by salary_average DESC 
)

select  high_demand.skill_id,
        high_demand.skills,
        high_demand.skills_count as demand,
        high_paying.salary_average as salary
from high_demand
LEFT JOIN high_paying on high_demand.skill_id = high_paying.skill_id
WHERE high_demand.skills_count > 5
ORDER BY salary DESC, demand desc LIMIT(10);

-- another ways
select  skills_dim.skill_id,
        skills_dim.skills,
        count(skills_job_dim.skill_id) as demand,
        round(avg(job_postings_fact.salary_year_avg),0) as salary
from skills_dim
LEFT JOIN skills_job_dim on skills_dim.skill_id = skills_job_dim.skill_id
LEFT JOIN job_postings_fact on skills_job_dim.job_id = job_postings_fact.job_id
where   salary_year_avg is not null and
        job_title_short = 'Data Analyst'
GROUP BY skills_dim.skill_id
having count(skills_job_dim.skill_id) > 5
ORDER BY salary DESC, demand DESC
LIMIT (10);



