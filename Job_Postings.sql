/* 
📝 This is just for showcasing some SQL knowledge!
💡 This analysis aims to demonstrate SQL skills.
⚠️ Please note that the results are not representative, as I used a less extensive version of the dataset available at datanerd.tech.
💼 What are the top-paying remote 🌐 and local 🏢 data analyst jobs?"
*/

SELECT 
	job_id,
	job_title,
	job_location,
	job_schedule_type,
	salary_year_avg, 
	job_posted_date,
	name AS company_name
FROM 
	job_postings_fact 
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
	job_title_short = 'Data Analyst' AND 
	job_location = 'Anywhere' AND 
	salary_year_avg IS NOT NULL 
ORDER BY  
	salary_year_avg DESC  
LIMIT 10;

/*
	Results for job_location = 'Anywhere' witch means its a remote job:
	|job_id   |job_title                                      |job_location|job_schedule_type|salary_year_avg|job_posted_date        |company_name                                   |
	|---------|-----------------------------------------------|------------|-----------------|---------------|-----------------------|---------------------------------------|
	|226,942  |Data Analyst                                   |Anywhere    |Full-time        |650,000        |2023-02-20 15:13:33.000|Mantys                                 |
	|547,382  |Director of Analytics                          |Anywhere    |Full-time        |336,500        |2023-08-23 12:04:42.000|Meta                                   |
	|552,322  |Associate Director- Data Insights              |Anywhere    |Full-time        |255,829.5      |2023-06-18 16:03:12.000|AT&T                                   |
	|99,305   |Data Analyst, Marketing                        |Anywhere    |Full-time        |232,423        |2023-12-05 20:00:40.000|Pinterest Job Advertisements           |
	|1,021,647|Data Analyst (Hybrid/Remote)                   |Anywhere    |Full-time        |217,000        |2023-01-17 00:17:23.000|Uclahealthcareers                      |
	|168,310  |Principal Data Analyst (Remote)                |Anywhere    |Full-time        |205,000        |2023-08-09 11:00:01.000|SmartAsset                             |
	|731,368  |Director, Data Analyst - HYBRID                |Anywhere    |Full-time        |189,309        |2023-12-07 15:00:13.000|Inclusively                            |
	|310,660  |Principal Data Analyst, AV Performance Analysis|Anywhere    |Full-time        |189,000        |2023-01-05 00:00:25.000|Motional                               |
	|1,749,593|Principal Data Analyst                         |Anywhere    |Full-time        |186,000        |2023-07-11 16:00:05.000|SmartAsset                             |
	|387,860  |ERM Data Analyst                               |Anywhere    |Full-time        |184,000        |2023-06-09 08:01:04.000|Get It Recruit - Information Technology|

	Results for job_country = 'Hungary', which means it's a local job:
	|job_id   |job_title                                                      |job_location     |job_schedule_type|salary_year_avg|job_posted_date        |company_name                      |
	|---------|---------------------------------------------------------------|-----------------|-----------------|---------------|-----------------------|--------------------------|
	|1,193,950|Data Architect                                                 |Hungary          |Full-time        |155,000        |2023-12-09 14:17:44.000|OTP Bank                  |
	|83,757   |Data Architect                                                 |Budapest, Hungary|Full-time        |154,000        |2023-12-16 10:15:31.000|Gedeon Richter Pharma GmbH|
	|655,078  |Data Analyst                                                   |Budapest, Hungary|Full-time        |111,202        |2023-01-06 06:30:42.000|Prezi                     |
	|997,242  |Data Analyst                                                   |Budapest, Hungary|Full-time        |111,175        |2023-04-21 07:44:59.000|Fivesky                   |
	|1,402,953|Sustainable Farming Data Manager                               |Budapest, Hungary|Full-time        |105,650        |2023-04-19 09:25:53.000|Syngenta Group            |
	|650,690  |Data Analyst                                                   |Budapest, Hungary|Full-time        |100,500        |2023-07-27 14:49:46.000|Veeva Systems             |
	|1,321,883|Data Analyst                                                   |Budapest, Hungary|Full-time        |98,500         |2023-02-17 07:50:45.000|Sleek                     |
	|736,407  |TEAM LEADER – DATA ANALYTICS, MICROELECTRONICS (MEMS) SENSOR...|Budapest, Hungary|Full-time        |89,100         |2023-04-22 22:17:57.000|Bosch Group               |
	|482,970  |Hardware Analysis Engineer (Airbag System)                     |Budapest, Hungary|Full-time        |80,850         |2023-05-20 08:02:57.000|Bosch Group               |
	|829,005  |Data Operations Manager - Link                                 |Budapest, Hungary|Full-time        |80,850         |2023-06-07 17:54:57.000|Veeva Systems             |
*/

/* Which skills are the most valuable globally and in Hungary?
Let's check that by building upon my last query, using it as a CTE, and joining the skills table through an intermediary table.*/

WITH top_paying_jobs AS (
SELECT 
	job_id,
	job_title,
	salary_year_avg, 
	name AS company_name
FROM 
	job_postings_fact 
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
	job_title_short = 'Data Analyst' AND 
	job_location = 'Anywhere' AND 
	salary_year_avg IS NOT NULL 
ORDER BY  
	salary_year_avg DESC  
LIMIT 10
)
SELECT 
	top_paying_jobs.*,
	skills_dim.skills
FROM top_paying_jobs 
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
	salary_year_avg DESC 

/* Results:
	|job_id   |job_title                                      |salary_year_avg|company_name                           |skills    |
|---------|-----------------------------------------------|---------------|---------------------------------------|----------|
|552,322  |Associate Director- Data Insights              |255,829.5      |AT&T                                   |sql       |
|552,322  |Associate Director- Data Insights              |255,829.5      |AT&T                                   |python    |
|552,322  |Associate Director- Data Insights              |255,829.5      |AT&T                                   |r         |
|552,322  |Associate Director- Data Insights              |255,829.5      |AT&T                                   |azure     |
|552,322  |Associate Director- Data Insights              |255,829.5      |AT&T                                   |databricks|
|552,322  |Associate Director- Data Insights              |255,829.5      |AT&T                                   |aws       |
|552,322  |Associate Director- Data Insights              |255,829.5      |AT&T                                   |pandas    |
|552,322  |Associate Director- Data Insights              |255,829.5      |AT&T                                   |pyspark   |
|552,322  |Associate Director- Data Insights              |255,829.5      |AT&T                                   |jupyter   |
|552,322  |Associate Director- Data Insights              |255,829.5      |AT&T                                   |excel     |
|552,322  |Associate Director- Data Insights              |255,829.5      |AT&T                                   |tableau   |
|552,322  |Associate Director- Data Insights              |255,829.5      |AT&T                                   |power bi  |
|552,322  |Associate Director- Data Insights              |255,829.5      |AT&T                                   |powerpoint|
|99,305   |Data Analyst, Marketing                        |232,423        |Pinterest Job Advertisements           |sql       |
|99,305   |Data Analyst, Marketing                        |232,423        |Pinterest Job Advertisements           |python    |
|99,305   |Data Analyst, Marketing                        |232,423        |Pinterest Job Advertisements           |r         |
|99,305   |Data Analyst, Marketing                        |232,423        |Pinterest Job Advertisements           |hadoop    |
|99,305   |Data Analyst, Marketing                        |232,423        |Pinterest Job Advertisements           |tableau   |
|1,021,647|Data Analyst (Hybrid/Remote)                   |217,000        |Uclahealthcareers                      |sql       |
|1,021,647|Data Analyst (Hybrid/Remote)                   |217,000        |Uclahealthcareers                      |crystal   |
|1,021,647|Data Analyst (Hybrid/Remote)                   |217,000        |Uclahealthcareers                      |oracle    |
|1,021,647|Data Analyst (Hybrid/Remote)                   |217,000        |Uclahealthcareers                      |tableau   |
|1,021,647|Data Analyst (Hybrid/Remote)                   |217,000        |Uclahealthcareers                      |flow      |
|168,310  |Principal Data Analyst (Remote)                |205,000        |SmartAsset                             |sql       |
|168,310  |Principal Data Analyst (Remote)                |205,000        |SmartAsset                             |python    |
|168,310  |Principal Data Analyst (Remote)                |205,000        |SmartAsset                             |go        |
|168,310  |Principal Data Analyst (Remote)                |205,000        |SmartAsset                             |snowflake |
|168,310  |Principal Data Analyst (Remote)                |205,000        |SmartAsset                             |pandas    |
|168,310  |Principal Data Analyst (Remote)                |205,000        |SmartAsset                             |numpy     |
|168,310  |Principal Data Analyst (Remote)                |205,000        |SmartAsset                             |excel     |
|168,310  |Principal Data Analyst (Remote)                |205,000        |SmartAsset                             |tableau   |
|168,310  |Principal Data Analyst (Remote)                |205,000        |SmartAsset                             |gitlab    |
|731,368  |Director, Data Analyst - HYBRID                |189,309        |Inclusively                            |sql       |
|731,368  |Director, Data Analyst - HYBRID                |189,309        |Inclusively                            |python    |
|731,368  |Director, Data Analyst - HYBRID                |189,309        |Inclusively                            |azure     |
|731,368  |Director, Data Analyst - HYBRID                |189,309        |Inclusively                            |aws       |
|731,368  |Director, Data Analyst - HYBRID                |189,309        |Inclusively                            |oracle    |
|731,368  |Director, Data Analyst - HYBRID                |189,309        |Inclusively                            |snowflake |
|731,368  |Director, Data Analyst - HYBRID                |189,309        |Inclusively                            |tableau   |
|731,368  |Director, Data Analyst - HYBRID                |189,309        |Inclusively                            |power bi  |
|731,368  |Director, Data Analyst - HYBRID                |189,309        |Inclusively                            |sap       |
|731,368  |Director, Data Analyst - HYBRID                |189,309        |Inclusively                            |jenkins   |
|731,368  |Director, Data Analyst - HYBRID                |189,309        |Inclusively                            |bitbucket |
|731,368  |Director, Data Analyst - HYBRID                |189,309        |Inclusively                            |atlassian |
|731,368  |Director, Data Analyst - HYBRID                |189,309        |Inclusively                            |jira      |
|731,368  |Director, Data Analyst - HYBRID                |189,309        |Inclusively                            |confluence|
|310,660  |Principal Data Analyst, AV Performance Analysis|189,000        |Motional                               |sql       |
|310,660  |Principal Data Analyst, AV Performance Analysis|189,000        |Motional                               |python    |
|310,660  |Principal Data Analyst, AV Performance Analysis|189,000        |Motional                               |r         |
|310,660  |Principal Data Analyst, AV Performance Analysis|189,000        |Motional                               |git       |
|310,660  |Principal Data Analyst, AV Performance Analysis|189,000        |Motional                               |bitbucket |
|310,660  |Principal Data Analyst, AV Performance Analysis|189,000        |Motional                               |atlassian |
|310,660  |Principal Data Analyst, AV Performance Analysis|189,000        |Motional                               |jira      |
|310,660  |Principal Data Analyst, AV Performance Analysis|189,000        |Motional                               |confluence|
|1,749,593|Principal Data Analyst                         |186,000        |SmartAsset                             |sql       |
|1,749,593|Principal Data Analyst                         |186,000        |SmartAsset                             |python    |
|1,749,593|Principal Data Analyst                         |186,000        |SmartAsset                             |go        |
|1,749,593|Principal Data Analyst                         |186,000        |SmartAsset                             |snowflake |
|1,749,593|Principal Data Analyst                         |186,000        |SmartAsset                             |pandas    |
|1,749,593|Principal Data Analyst                         |186,000        |SmartAsset                             |numpy     |
|1,749,593|Principal Data Analyst                         |186,000        |SmartAsset                             |excel     |
|1,749,593|Principal Data Analyst                         |186,000        |SmartAsset                             |tableau   |
|1,749,593|Principal Data Analyst                         |186,000        |SmartAsset                             |gitlab    |
|387,860  |ERM Data Analyst                               |184,000        |Get It Recruit - Information Technology|sql       |
|387,860  |ERM Data Analyst                               |184,000        |Get It Recruit - Information Technology|python    |
|387,860  |ERM Data Analyst                               |184,000        |Get It Recruit - Information Technology|r         |
*/

/* The results of the previous query are a bit hard to read, so let's fix that. (And yes, I intentionally display results in text instead of JSON format for easier readability.)*/

WITH top_paying_jobs AS (
    SELECT 
        job_id,
        job_title,
        salary_year_avg, 
        name AS company_name
    FROM 
        job_postings_fact 
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short = 'Data Analyst' AND 
        job_location = 'Anywhere' AND 
        salary_year_avg IS NOT NULL 
    ORDER BY  
        salary_year_avg DESC  
    LIMIT 10
)
SELECT 
    top_paying_jobs.job_id,
    top_paying_jobs.job_title,
    top_paying_jobs.company_name,
    top_paying_jobs.salary_year_avg,
    STRING_AGG(skills_dim.skills, ', ') AS required_skills
FROM top_paying_jobs 
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
GROUP BY top_paying_jobs.job_id, top_paying_jobs.job_title, top_paying_jobs.company_name, top_paying_jobs.salary_year_avg
ORDER BY salary_year_avg DESC;

/* The results clearly show that the most sought-after skills globally are Python and SQL.
	|job_id   |job_title                                      |company_name                           |salary_year_avg|required_skills                                                                                                    |
|---------|-----------------------------------------------|---------------------------------------|---------------|-------------------------------------------------------------------------------------------------------------------|
|552,322  |Associate Director- Data Insights              |AT&T                                   |255,829.5      |sql, python, r, azure, databricks, aws, pandas, pyspark, jupyter, excel, tableau, power bi, powerpoint             |
|99,305   |Data Analyst, Marketing                        |Pinterest Job Advertisements           |232,423        |sql, python, r, hadoop, tableau                                                                                    |
|1,021,647|Data Analyst (Hybrid/Remote)                   |Uclahealthcareers                      |217,000        |sql, crystal, oracle, tableau, flow                                                                                |
|168,310  |Principal Data Analyst (Remote)                |SmartAsset                             |205,000        |sql, python, go, snowflake, pandas, numpy, excel, tableau, gitlab                                                  |
|731,368  |Director, Data Analyst - HYBRID                |Inclusively                            |189,309        |sql, python, azure, aws, oracle, snowflake, tableau, power bi, sap, jenkins, bitbucket, atlassian, jira, confluence|
|310,660  |Principal Data Analyst, AV Performance Analysis|Motional                               |189,000        |sql, python, r, git, bitbucket, atlassian, jira, confluence                                                        |
|1,749,593|Principal Data Analyst                         |SmartAsset                             |186,000        |sql, python, go, snowflake, pandas, numpy, excel, tableau, gitlab                                                  |
|387,860  |ERM Data Analyst                               |Get It Recruit - Information Technology|184,000        |sql, python, r  

Now, the same for Hungary! Although this dataset contains few records of Hungarian job postings (highly non-representative alert!), we can say that SQL is also valuable in Hungary, but Python is not as much in demand.
|job_id   |job_title                                                      |company_name |salary_year_avg|required_skills                       |
|---------|---------------------------------------------------------------|-------------|---------------|--------------------------------------|
|1,193,950|Data Architect                                                 |OTP Bank     |155,000        |azure, databricks, aws, snowflake, gcp|
|655,078  |Data Analyst                                                   |Prezi        |111,202        |sql, python, redshift                 |
|997,242  |Data Analyst                                                   |Fivesky      |111,175        |sql, python, excel, tableau           |
|650,690  |Data Analyst                                                   |Veeva Systems|100,500        |sql, tableau, atlassian               |
|1,321,883|Data Analyst                                                   |Sleek        |98,500         |sql, python, r, excel, tableau, sheets|
|736,407  |TEAM LEADER – DATA ANALYTICS, MICROELECTRONICS (MEMS) SENSOR...|Bosch Group  |89,100         |python, hadoop, tableau, git, jira    |                                                                                         |
*/

/*🔍 Now, let's take a look at the most in-demand skills 📊 (excluding soft skills for now ❌🧠) for data analysts both globally 🌍 and in Hungary 🇭🇺.*/

SELECT 
	skills AS skill_name,
	COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact 
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
	job_title_short = 'Data Analyst'
GROUP BY 
	skills
ORDER BY 
	demand_count DESC 
LIMIT 10;
/* 🌍Globally:
|skill_name|demand_count|
|----------|------------|
|sql       |92,628      |
|excel     |67,031      |
|python    |57,326      |
|tableau   |46,554      |
|power bi  |39,468      |
|r         |30,075      |
|sas       |28,068      |
|powerpoint|13,848      |
|word      |13,591      |
|sap       |11,297      |
*/
SELECT 
	skills AS skill_name,
	COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact 
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
	job_title_short = 'Data Analyst' AND 
	job_country = 'Hungary'
GROUP BY 
	skills
ORDER BY 
	demand_count DESC 
LIMIT 10;	
/*Results for Hungary:
|skill_name|demand_count|
|----------|------------|
|sql       |310         |
|excel     |263         |
|python    |201         |
|tableau   |151         |
|power bi  |145         |
|sap       |99          |
|r         |86          |
|vba       |48          |
|azure     |46          |
|oracle    |45          |

The results show that both globally and in Hungary 🇭🇺, the most in-demand skills for data analysts are SQL 🗃️, Excel 📊, Python 🐍, and data visualization tools 📈.*/

/* 💡 Now that we see SQL 🗃️ and Excel 📊 are the most commonly sought-after skills, let's take a look at the average salary associated with each skill.
💭 My initial hypothesis is that Python 🐍 or other niche tools will be among the highest-paying skills 💰, since SQL and Excel are typically requirements for junior analyst roles 📈, 
while more specialized tools and Python are used later on in more advanced or specialized positions 🚀.*/

SELECT 
	skills,
	ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE  
	job_title_short = 'Data Analyst' AND 
	salary_year_avg IS NOT NULL
GROUP BY  
	skills 
ORDER BY 
	avg_salary DESC 
LIMIT 
	10;
/* Globally:
|skills   |avg_salary|
|---------|----------|
|svn      |400,000   |
|solidity |179,000   |
|couchbase|160,515   |
|datarobot|155,486   |
|golang   |155,000   |
|mxnet    |149,000   |
|dplyr    |147,633   |
|vmware   |147,500   |
|terraform|146,734   |
|twilio   |138,500   |
neither Excel 📊 nor SQL 🗃️ made it into the top 10 highest-paying skills! 😔*/

SELECT 
	skills,
	ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE  
	job_title_short = 'Data Analyst' AND 
	salary_year_avg IS NOT NULL AND 
	job_country = 'Hungary'
GROUP BY  
	skills 
ORDER BY 
	avg_salary DESC 
LIMIT 
	10;
/*Hungary:
|skills    |avg_salary|
|----------|----------|
|azure     |155,000   |
|snowflake |155,000   |
|gcp       |155,000   |
|aws       |113,950   |
|databricks|113,950   |
|redshift  |111,202   |
|atlassian |100,500   |
|tableau   |99,819    |
|r         |98,500    |
|python    |96,575    |
🐍 At least Python made it into the top 10! Overall, 
we can say that niche skills tend to be more valuable 💰 at the senior level 👔, 
while for juniors like me , SQL 🗃️ and Excel 📊 are the essentials we should focus on."*/

/*So, what are the most optimal skills for me to master? 🤔💡*/
WITH skills_demand AS (
	SELECT 
		skills_dim.skill_id,
		skills_dim.skills,
		COUNT(skills_job_dim.job_id) AS demand_count
	FROM job_postings_fact 
	INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
	INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
	WHERE 
		job_title_short = 'Data Analyst' AND 
		salary_year_avg IS NOT NULL 
	GROUP BY 
		skills_dim.skill_id
), average_salary AS (
	SELECT
		skills_job_dim.skill_id,
		ROUND(AVG(salary_year_avg), 0) AS avg_salary
	FROM job_postings_fact
	INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
	INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
	WHERE  
		job_title_short = 'Data Analyst' AND 
		salary_year_avg IS NOT NULL AND 
		job_country = 'Hungary'
	GROUP BY  
		skills_job_dim.skill_id
)
SELECT 
	skills_demand.skill_id,
	skills_demand.skills,
	demand_count,
	avg_salary
FROM 
	skills_demand 
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
ORDER BY 
	demand_count DESC,
	avg_salary DESC
LIMIT 
	25;
/* The most optimal skills for me to master as a junior data analyst are Python 🐍, SQL 🗃️, and Excel 📊. 
As a next step, learning Tableau 📈 and R 🧮 for data visualization and statistics, plus cloud tools like AWS ☁️, Azure 🌥️, or Snowflake ❄️.
|skill_id|skills    |demand_count|avg_salary|
|--------|----------|------------|----------|
|0       |sql       |3,083       |90,641    |
|181     |excel     |2,143       |83,035    |
|1       |python    |1,840       |96,575    |
|182     |tableau   |1,659       |99,819    |
|5       |r         |1,073       |98,500    |
|188     |word      |527         |72,900    |
|196     |powerpoint|524         |72,900    |
|61      |sql server|336         |49,567    |
|79      |oracle    |332         |56,700    |
|74      |azure     |319         |155,000   |
|76      |aws       |291         |113,950   |
|80      |snowflake |241         |155,000   |
|92      |spark     |187         |72,900    |
|189     |sap       |183         |70,150    |
|192     |sheets    |155         |75,757    |
|233     |jira      |145         |89,100    |
|97      |hadoop    |140         |89,100    |
|2       |nosql     |108         |72,900    |
|75      |databricks|102         |113,950   |
|141     |express   |96          |72,900    |
|78      |redshift  |90          |111,202   |
|93      |pandas    |90          |72,900    |
|81      |gcp       |78          |155,000   |
|210     |git       |74          |81,000    |
|3       |scala     |59          |72,900    |
*/
