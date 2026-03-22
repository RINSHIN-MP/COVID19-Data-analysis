CREATE TABLE coronadata ( 
    province VARCHAR(100),
    country VARCHAR(100),
    latitude FLOAT,
    longitude FLOAT,
    report_date DATE,
    confirmed_cases INT,
    deaths INT,
    recoveries INT
);




COPY coronadata(province, country, latitude, longitude, report_date, confirmed_cases, deaths, recoveries)
FROM 'F:\EIZZIE\ASS 2\Corona Virus Dataset.csv'
DELIMITER ','  
CSV HEADER;





SELECT 
    COUNT(*) FILTER (WHERE province IS NULL) AS Null_province,
    COUNT(*) FILTER (WHERE country IS NULL) AS Null_country,
    COUNT(*) FILTER (WHERE latitude IS NULL) AS Null_latitude,
    COUNT(*) FILTER (WHERE longitude IS NULL) AS Null_longitude,
    COUNT(*) FILTER (WHERE report_date IS NULL) AS Null_date,
    COUNT(*) FILTER (WHERE confirmed_cases IS NULL) AS Null_confirmed_cases,
    COUNT(*) FILTER (WHERE deaths IS NULL) AS Null_deaths,
    COUNT(*) FILTER (WHERE recoveries IS NULL) AS Null_recoveries
FROM coronadata;





--Q2. If NULL values are present, update them with zeros for all columns.

UPDATE coronadata
SET 
    "province" = COALESCE("province", 'Unknown'),
    "country" = COALESCE("country", 'Unknown'),
    "latitude" = COALESCE("latitude", 0),
    "longitude" = COALESCE("longitude", 0),
    "report_date" = COALESCE("report_date", '1970-01-01'),  
    "confirmed_cases" = COALESCE("confirmed_cases", 0),
    "deaths" = COALESCE("deaths", 0),
    "recoveries" = COALESCE("recoveries", 0);




-- Q3. check total number of rows


SELECT COUNT(*) AS total_rows FROM coronadata;




-- Q4. Check what is start_date and end_date

SELECT 
    MIN("report_date") AS start_date, 
    MAX("report_date") AS end_date
FROM coronadata;




-- Q5. Number of month present in dataset


SELECT COUNT(DISTINCT DATE_TRUNC('month', "report_date")) AS number_of_months
FROM coronadata;



-- Q6. Find monthly average for confirmed, deaths, recovered


SELECT 
    DATE_TRUNC('month', "report_date") AS month,
    AVG("confirmed_cases") AS avg_confirmed,
    AVG("deaths") AS avg_deaths,
    AVG("recoveries") AS avg_recovered
FROM coronadata
GROUP BY month
ORDER BY month;



-- Q7. Find most frequent value for confirmed, deaths, recovered each month

SELECT DISTINCT ON (DATE_TRUNC('month', "report_date")) 
    DATE_TRUNC('month', "report_date") AS month,
    "confirmed_cases", 
    "deaths", 
    "recoveries"
FROM coronadata
GROUP BY month, "confirmed_cases", "deaths", "recoveries"
ORDER BY month,COUNT(*)DESC;



-- Q8. Find minimum values for confirmed, deaths, recovered per year


SELECT 
    EXTRACT(YEAR FROM "report_date") AS year,
    MIN("confirmed_cases") AS min_confirmed,
    MIN("deaths") AS min_deaths,
    MIN("recoveries") AS min_recovered
FROM 
    coronadata
GROUP BY 
    EXTRACT(YEAR FROM "report_date")
ORDER BY 
    year;



-- Q9. Find maximum values of confirmed, deaths, recovered per year


SELECT 
    EXTRACT(YEAR FROM "report_date") AS year,
    MAX("confirmed_cases") AS max_confirmed,
    MAX("deaths") AS max_deaths,
    MAX("recoveries") AS max_recovered
FROM 
    coronadata
GROUP BY 
    EXTRACT(YEAR FROM "report_date")
ORDER BY 
    year;



-- Q10. The total number of case of confirmed, deaths, recovered each month


SELECT 
    EXTRACT(YEAR FROM "report_date") AS year,
    EXTRACT(MONTH FROM "report_date") AS month,
    SUM("confirmed_cases") AS total_confirmed,
    SUM("deaths") AS total_deaths,
    SUM("recoveries") AS total_recovered
FROM 
    coronadata
GROUP BY 
    EXTRACT(YEAR FROM "report_date"), EXTRACT(MONTH FROM "report_date")
ORDER BY 
    year, month;



-- Q11. Check how corona virus spread out with respect to confirmed case

SELECT 
    SUM(confirmed_cases) AS total_confirmed,
    AVG(confirmed_cases) AS average_confirmed,
    VARIANCE(confirmed_cases) AS variance_confirmed,
    STDDEV(confirmed_cases) AS stdev_confirmed
FROM 
    coronadata;
	
	
	

-- Q12. Check how corona virus spread out with respect to death case per month


SELECT 
    EXTRACT(YEAR FROM report_date) AS year,
    EXTRACT(MONTH FROM report_date) AS month,
    SUM(deaths) AS total_deaths,
    AVG(deaths) AS average_deaths,
    VARIANCE(deaths) AS variance_deaths,
    STDDEV(deaths) AS stdev_deaths
FROM 
    coronadata
GROUP BY 
    EXTRACT(YEAR FROM report_date), EXTRACT(MONTH FROM report_date)
ORDER BY 
    year, month;



-- Q13. Check how corona virus spread out with respect to recovered case


SELECT 
    EXTRACT(YEAR FROM report_date) AS year,
    EXTRACT(MONTH FROM report_date) AS month,
    SUM(recoveries) AS total_recovered,
    AVG(recoveries) AS average_recovered,
    VARIANCE(recoveries) AS variance_recovered,
    STDDEV(recoveries) AS stdev_recovered
FROM 
    coronadata
GROUP BY 
    EXTRACT(YEAR FROM report_date), EXTRACT(MONTH FROM report_date)
ORDER BY 
    year, month;




-- Q14. Find Country having highest number of the Confirmed case


SELECT 
    country,
    SUM(confirmed_cases) AS total_confirmed
FROM 
    coronadata
GROUP BY 
    country
ORDER BY 
    total_confirmed DESC
LIMIT 1;



-- Q15. Find Country having lowest number of the death case


SELECT 
    country,
    SUM(deaths) AS total_deaths
FROM 
    coronadata
GROUP BY 
    country
ORDER BY 
    total_deaths ASC
LIMIT 1;



-- Q16. Find top 5 countries having highest recovered case


SELECT 
    country,
    SUM(recoveries) AS total_recovered
FROM 
    coronadata
GROUP BY 
    country
ORDER BY 
    total_recovered DESC
LIMIT 5;




