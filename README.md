# Introduction
🎨Exploring the Job Market Data. Focusing on data analyst roles, this project explores top-paying jobs, in-demand skills, and where high demand meets high salary in the field of data analytics.

# Background
This project was born out of desire to showcase which jobs offer higher salaries and which positions are most in demand.

The data comes from [Lukebarousse.com](https://www.youtube.com/@LukeBarousse), whose explanations are easy for me to understand. Thanks to that✨, I was able to complete about this project🎀.

💡The questions I aimed to answer through these SQL queries were:
1. What are the top-paying data analyst jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
For practice this into the data analyst job market, I utilize of several tools:
* Visual Studio Code: for executing SQL queries.
* PostgreSQL: for database management system
* Git & GitHub: for control and sharing my SQL script and analysis.
* Visualization: Microsoft Excel.

# The Analysis
Here's the answer to each question💡

**1. Top-paying data analyst jobs**
```sql
select  jp.job_id,
            jp.job_title,
            jp.job_via,
            jp.job_no_degree_mention,
            jp.salary_year_avg
    from job_postings_fact as jp
    where   jp.salary_year_avg is not NULL and
            job_title_short = 'Data Analyst'
    ORDER BY jp.salary_year_avg DESC LIMIT(10);
```
<img width="1130" height="540" alt="image" src="https://github.com/user-attachments/assets/eb9f1ca1-abc9-40e5-a6ef-822a91c23253" />

What we got from the analyst:
- The salary range is very high, the highest salary is $650.000 and the lowest is around $185.000: Shows that the top salary for Data Analyst roles varies greatly.
- The more senior or managerial the job title, the higher the salary, for example:
"Sr Data Analyst", "Head of Infrastructure Management & Data Analystics", and "Director of Safety Data Analysis".
- Job Data Analyst often appears on the job seeker portal "Ladders" for positions with high salaries.
- Insight: certain job portals may focus more on high paying or senior roles.

**2. Skills are required for these top-paying jobs**
```sql
with job_top_paying as (
    select  jp.job_id,
            jp.job_title,
            jp.job_via,
            jp.job_no_degree_mention,
            jp.salary_year_avg
    from job_postings_fact as jp
    where jp.salary_year_avg is not NULL AND
        jp.job_title_short = 'Data Analyst' and
        job_location = 'Anywhere'
    ORDER BY jp.salary_year_avg DESC LIMIT(10)
)
select  job_top_paying.*,
        skills_dim.skills
from job_top_paying 
INNER JOIN skills_job_dim on job_top_paying.job_id = skills_job_dim.job_id
INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY job_top_paying.salary_year_avg DESC;
```
<div align="center">
<img width="259" height="309" alt="image" src="https://github.com/user-attachments/assets/ff513c13-7989-4b1e-967e-2fd286a77378" />
</div>
What we get from the analyst:
It can be seen that there are new/niche skills, basic skills remain a mandatory foundation such as SQL, Python, R which are the top 3 skills needed based on the highest paying. 
<br> </br>

**3. Skills are most in demand for data analyst**
```sql
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
--there is alternatif command for this case, see it at SQL script for more detail
```
<img width="1107" height="624" alt="image" src="https://github.com/user-attachments/assets/d68b5dc7-7ac4-4d39-af3a-8d944d9eebb0" />

What we get from the analyst:
- The analysis of the most needed skills for Data Analyst roles shows that SQL tops the list (92.628 mentions), followed by Excel (67.031), Python (57.326), Tableau (46.554), and Power BI (39.468).
- This means that SQL and Excel remain the primary foundational skills required for a Data Analyst.
- The top 10 skills are directly related to data management and visualization.
- While Python supports automation, Tableau and Power BI support visualization needs, requiring companies to utilize reporting and dashboarding capabilities in addition to coding.
- There is a significant gap between SQL (92k) and Power BI (39k), indicating that core database and coding skills are far more essential than additional tools.

**4. Skills are associated with higher salaries**
<div align="center">
<img width="376" height="309" alt="image" src="https://github.com/user-attachments/assets/b414ea89-14df-4b87-a77d-5e72704149a1" />
</div>

The command are:

```sql
select skills, round(avg (salary_year_avg), 0) as salary_average
from job_postings_fact 
LEFT JOIN skills_job_dim on job_postings_fact.job_id = skills_job_dim.job_id
LEFT JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
where job_title_short = 'Data Analyst' and salary_year_avg is not NULL
GROUP BY skills
order by salary_average DESC limit(10);
```
What we got:
- The highest-paying skill is SVN, with the highest average salary ($400.000), followed by Solidity ($179.000), and Golang ($155.000).
- This shows that the more specialized the skill, the higher the salary potential compared to more general skills.
- There is a significant salary gap, from $400.000 (SVN) to around $138.000 (Perl), which means that the skills mastered can significantly impact salary potential.

**5. The most optimal skills to learn**
```sql
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
having count(skills_job_dim.skill_id) > 10
ORDER BY salary DESC, demand DESC
LIMIT (10);
```
Output:
<div align="center">
<img width="352" height="309" alt="image" src="https://github.com/user-attachments/assets/fef3804e-e928-4fe1-b276-a6b122fa0cb4" />
</div>

- Here, I'll explore 10 must-learn skills based on demand and salary:
  * Kafka → demand 40, salary=$129.000 (the highest salary on this list).
  * PyTorch → demand 20, salary=$125.000.
  * TensorFlow → demand 24, salary=$120.000.
  * This shows that AI/ML frameworks (PyTorch, TensorFlow) and big data streaming (Kafka) are very important to learn.
- Among these 10 skills, there are still niche skills with high salaries: Perl = demand 20 with a salary of $124.000.
- Cassandra → demand 11, salary $118.000. Still important for roles related to distributed systems and large-scale databases.
- Insight: Not all high-paying skills are in high demand. If you're looking for a learning strategy, it's best to choose skills that balance demand and salary (e.g., PyTorch and TensorFlow).

# Conclusions
Throughout this experience, I’ve boosted my SQL skills with some serious advancements:
- 📚 Used to and increasingly understand **Data Aggregation** which requires the use of the Group By () command after there is COUNT() and AVG() in the select section, they are partners during the analysis.
- 🔓 Mastered advanced SQL tricks, joining tables effortlessly and using **WITH from CTE** for sleek temporary table hacks.

# Closing Thoughts and What I Learned
The analysis of the 2023 job postings data has been completed✨. I had forgotten my SQL skills and because of somethings, so I started to withdraw myself back to learning this and I found more life and having a pleasant feeling in the process of learning this skill. The author found it very informative/insightful, revealing many previously unknown tools. Hopefully, this analysis will help others learn about analysis and SQL🌷.





