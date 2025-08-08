select 
    job_title_short as title,
    job_location as location,
    job_posted_date at time zone 'UTC' at time zone 'EST' as date_time,
    EXTRACT (month from job_posted_date) as month,
    EXTRACT (year from job_posted_date) as year
FROM job_postings_fact
    limit 10;


select extract(month from job_posted_date) as bulan, count(job_id) from job_postings_fact
group by bulan limit (10);

--filter hanya data analyst
select extract(month from job_posted_date) as bulan, count(job_id) as pekerjaan
from job_postings_fact
where job_title_short = 'Data Analyst'
group by bulan limit (10);

/* write a query to find the average salary both yearly (salary_year_avg)
and hourly (salary_hour_avg) for job postings that were posted after june 1, 2023. 
group the result by job schedule type. */
select * from job_postings_fact limit (5);

select 
    avg (salary_year_avg) as gaji_tahunan,
    avg (salary_hour_avg) as gaji_per_jam,
from job_postings_fact
where date_time > 2023-06-01
group by job_schedule_type;

/* write a query to count the number of job postings for each month in 2023,
adjusting the job_posted_date to be in 'America/New_York' time zone before extracting
(hint) the month. Assume the job_posted_date is store in UTC. 
Group by and order by the month. */
select count(job_id) as jumlah_job,
    extract (month from job_posted_date at time zone 'UTC' at time zone 'America/New_York') as bulan_2023
from job_postings_fact
where extract (year from job_posted_date at time zone 'UTC' at time zone 'America/New_York') = 2023
GROUP BY  bulan_2023
ORDER BY bulan_2023 limit (100);

/* write a query to find companies (include company name) that have posted
jobs offering health insurance, where these were made in the second quarter of 2023.
use date extraction to filter by quarter */
--see the tables we have--
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;

select * from company_dim limit (5);
select * from job_postings_fact limit (5);

--answer--
select job_id, company_dim.name as companies_name, job_health_insurance as health_insurance
from job_postings_fact
    left join company_dim on company_dim.company_id = job_postings_fact.company_id
where job_health_insurance = TRUE AND 
    extract (quarter from job_posted_date) = 2 AND
    extract (year from job_posted_date) = 2023 
limit (100);

/* want to share number of companies that upload jobs on each month [quarter 2 in 2023] */
select 
    job_health_insurance as insurance,
    string_agg (company_dim.name, ',') as companies_name,
    count(distinct company_dim.company_id) as jumlah,
    extract (month from job_posted_date) as bulan
from job_postings_fact
    left join company_dim on company_dim.company_id = job_postings_fact.company_id
where job_health_insurance = TRUE AND 
    extract (quarter from job_posted_date) = 2 AND
    extract (year from job_posted_date) = 2023 
group by extract (month from job_posted_date),
job_health_insurance
order by bulan;






