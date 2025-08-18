-- ✨GOAL✨
/* 
1. You are an aspiring data nerd looking to analyze the top-paying roled and skills
2. You will create SQL queries to explore this large dataset specific to you
3. For those job searching or looking for a promotion: u can not only use this project
    to showcase experience but also to extract what roles/skills u should target */

-- What are the top-paying data analyst jobs?
select * from job_postings_fact LIMIT(5);
select  jp.job_id,
        jp.job_title,
        jp.job_via,
        jp.job_no_degree_mention,
        jp.salary_year_avg
from job_postings_fact as jp
where jp.salary_year_avg is not NULL
ORDER BY jp.salary_year_avg DESC LIMIT(10);




