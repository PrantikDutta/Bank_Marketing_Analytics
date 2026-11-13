CREATE DATABASE bank_marketing_db;
USE bank_marketing_db;
CREATE TABLE bank_marketing (
    age INT,
    job VARCHAR(30),
    marital VARCHAR(15),
    education VARCHAR(20),
    credit_default VARCHAR(5),
    balance INT,
    housing VARCHAR(5),
    loan VARCHAR(5),
    contact VARCHAR(15),
    day INT,
    month VARCHAR(5),
    duration INT,
    campaign INT,
    pdays INT,
    previous INT,
    poutcome VARCHAR(15),
    subscribed VARCHAR(5),
    subscribed_binary TINYINT,
    age_group VARCHAR(10),
    contact_group VARCHAR(20),
    previously_contacted TINYINT,
    has_previous_success TINYINT
);
SELECT COUNT(*) AS total_records
FROM bank_marketing;

SELECT *
FROM bank_marketing
LIMIT 10;

SELECT
    subscribed,
    COUNT(*) AS total,
    ROUND(AVG(subscribed_binary) * 100, 2) AS percentage
FROM bank_marketing
GROUP BY subscribed;

-- Calculating the actual overall conversion rate --
SELECT
    COUNT(*) AS total_records,
    SUM(subscribed_binary) AS total_subscriptions,
    ROUND(AVG(subscribed_binary) * 100, 2) AS conversion_rate
FROM bank_marketing;

-- Which contact channel performs best? --
SELECT
    contact,
    COUNT(*) AS total_contacts,
    SUM(subscribed_binary) AS subscriptions,
    ROUND(AVG(subscribed_binary) * 100, 2) AS conversion_rate
FROM bank_marketing
GROUP BY contact
ORDER BY conversion_rate DESC;
-- Which occupations have the highest subscription rates? --
SELECT
    job,
    COUNT(*) AS total_customers,
    SUM(subscribed_binary) AS subscriptions,
    ROUND(AVG(subscribed_binary) * 100, 2) AS conversion_rate
FROM bank_marketing
GROUP BY job
HAVING COUNT(*) >= 100
ORDER BY conversion_rate DESC;
 -- Does previous campaign success influence current subscriptions? --
 SELECT
    poutcome,
    COUNT(*) AS total_records,
    SUM(subscribed_binary) AS subscriptions,
    ROUND(AVG(subscribed_binary) * 100, 2) AS conversion_rate
FROM bank_marketing
GROUP BY poutcome
ORDER BY conversion_rate DESC;
-- Does contacting customers repeatedly improve conversion? --
SELECT
    contact_group,
    COUNT(*) AS total_records,
    SUM(subscribed_binary) AS subscriptions,
    ROUND(AVG(subscribed_binary) * 100, 2) AS conversion_rate
FROM bank_marketing
GROUP BY contact_group
ORDER BY
    CASE contact_group
        WHEN '1 contact' THEN 1
        WHEN '2-3 contacts' THEN 2
        WHEN '4-5 contacts' THEN 3
        WHEN '6+ contacts' THEN 4
    END;
    -- Which age groups are most likely to subscribe? --
    SELECT
    age_group,
    COUNT(*) AS total_records,
    SUM(subscribed_binary) AS subscriptions,
    ROUND(AVG(subscribed_binary) * 100, 2) AS conversion_rate
FROM bank_marketing
GROUP BY age_group
ORDER BY
    CASE age_group
        WHEN '18-25' THEN 1
        WHEN '26-35' THEN 2
        WHEN '36-45' THEN 3
        WHEN '46-55' THEN 4
        WHEN '55+' THEN 5
    END;
    -- Which occupations rank highest in campaign conversion performance? --
    WITH job_performance AS (
    SELECT
        job,
        COUNT(*) AS total_records,
        SUM(subscribed_binary) AS subscriptions,
        ROUND(
            AVG(subscribed_binary) * 100, 2
        ) AS conversion_rate
    FROM bank_marketing
    GROUP BY job
    HAVING COUNT(*) >= 100
)

SELECT
    job,
    total_records,
    subscriptions,
    conversion_rate,
    DENSE_RANK() OVER (
        ORDER BY conversion_rate DESC
    ) AS conversion_rank
FROM job_performance
ORDER BY conversion_rank;
-- Which months have the highest subscription conversion rates? --
SELECT
    month,
    COUNT(*) AS total_records,
    SUM(subscribed_binary) AS subscriptions,
    ROUND(AVG(subscribed_binary) * 100, 2) AS conversion_rate,
    DENSE_RANK() OVER (
        ORDER BY AVG(subscribed_binary) DESC
    ) AS month_rank
FROM bank_marketing
GROUP BY month
ORDER BY month_rank;