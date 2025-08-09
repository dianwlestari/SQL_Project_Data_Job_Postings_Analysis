# Introduction
🎨Exploring the Job Market Data. Focusing on data analyst roles, this project explores top-paying jobs, in-demand skills, and where high demand meets high salary in the field of data analytics.

# Background
This dataset from a data-focused YouTuber discussing the job market. This project was born out of desire to showcase which jobs offer higher salaries and which positions are most in demand.

The data comes from [Lukebarousse.com](https://www.lukebarousse.com/sql), whose explanations are easy for me to understand. Thanks to that✨, I was able to complete about half of this project🎀.

💡The questions I aimed to answer through these SQL queries were:
1. How many companies posted job openings in the second quarter of 2023?
2. How many jobs were posted each month in 2023 using the America/New_York time zone?
3. What is the average daily and annual salary based on the job schedule type?

Follow-up questions _still in progress to finish_ :
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

# The Analysis
Here's the answer to each question💡
1. Companies posted job openings in the second quarter of 2023
   
I did the identification to find out and that the companies at the different tables, so I used a join query and filtered based on the needs of the question.
<pre> select job_id, company_dim.name as companies_name, job_health_insurance as health_insurance
from job_postings_fact
    left join company_dim on company_dim.company_id = job_postings_fact.company_id
where job_health_insurance = TRUE AND 
    extract (quarter from job_posted_date) = 2 AND
    extract (year from job_posted_date) = 2023 
limit (100); </pre>   

2. Jobs were posted each month in 2023
 
To identify companies opening job vacancies in the second quarter of 2023, first I changed the time zone, calculated based on job ID, and focused on the second quarter of 2023. The following is a query to answer the question.
<pre> select count(job_id) as jumlah_job,
    extract (month from job_posted_date at time zone 'UTC' at time zone 'America/New_York') as bulan_2023
from job_postings_fact
where extract (year from job_posted_date at time zone 'UTC' at time zone 'America/New_York') = 2023
GROUP BY  bulan_2023
ORDER BY bulan_2023 limit (100); </pre>
<img width="750" height="450" alt="image" src="https://github.com/user-attachments/assets/7cde8fae-cca7-4178-9750-2fb75c0ee4b6" />




