-- From the Maven Challenge where the task is to improve retention by identifying high value customers and churn risks.

-- View of the dataset
SELECT TOP 100 *
FROM MavenTelecom..telecom_customer_churn;

-- Quick way to know if the have duplicates Customer ID in the dataset
SELECT COUNT(*) AS total_ids, COUNT(DISTINCT [Customer ID]) AS unique_ids
FROM MavenTelecom..telecom_customer_churn;

-- Total Customers by status
SELECT [Customer Status], COUNT([Customer Status]) AS [Customer Status]
FROM MavenTelecom..telecom_customer_churn
GROUP BY [Customer Status];

-- Total Revenue By Status
SELECT [Customer Status], SUM(CONVERT(float,[Total Revenue])) AS [Total Revenue]
FROM MavenTelecom..telecom_customer_churn
GROUP BY [Customer Status];

-- Looking into the median, average for possible outliers
-- We have outlies as the average isn't near the median
SELECT CONVERT(float,[Total Revenue]) AS [Total Revenue]
FROM MavenTelecom..telecom_customer_churn
ORDER BY 1;

SELECT AVG(CONVERT(float,[Total Revenue])) AS avg_revenue
FROM MavenTelecom..telecom_customer_churn;

SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY CONVERT(float,[Total Revenue])) OVER () AS median
FROM MavenTelecom..telecom_customer_churn;

-- Distribution about the median
SELECT COUNT(*) AS customers_above_median
FROM MavenTelecom..telecom_customer_churn
WHERE CONVERT(float,[Total Revenue]) >= 2108.64;

SELECT COUNT(*) AS customers_below_median
FROM MavenTelecom..telecom_customer_churn
WHERE CONVERT(float,[Total Revenue]) < 2108.64;

-- Know the possible churn of customers that are above the median
SELECT [Churn Category], COUNT(*) AS customers_above_median
FROM MavenTelecom..telecom_customer_churn
WHERE CONVERT(float,[Total Revenue]) >= 2108.64
GROUP BY [Churn Category];

-- Know the possible churn of customers that are below the median
SELECT [Churn Category], COUNT(*) AS customers_below_median
FROM MavenTelecom..telecom_customer_churn
WHERE CONVERT(float,[Total Revenue]) < 2108.64
GROUP BY [Churn Category];

SELECT * 
FROM MavenTelecom..telecom_customer_churn
WHERE CONVERT(float,[Total Revenue]) >= 2108.64;

-- Looking into Churned
SELECT * 
FROM MavenTelecom..telecom_customer_churn
WHERE [Customer Status] IN ('Churned');

-- Principal Churn Categories By Contract
SELECT Contract, [Churn Category], COUNT([Churn Category]) AS total_customers_churned
FROM MavenTelecom..telecom_customer_churn
WHERE [Customer Status] IN ('Churned')
GROUP BY Contract, [Churn Category]
ORDER BY Contract;

-- Principal customers that churn by City
SELECT City, COUNT(City) AS total_customers_by_city
FROM MavenTelecom..telecom_customer_churn
WHERE [Customer Status] IN ('Churned')
GROUP BY City
ORDER BY 2 DESC;

-- Reasons of the churn
SELECT [Churn Reason], COUNT([Churn Reason]) AS reason_customers_churned
FROM MavenTelecom..telecom_customer_churn
WHERE [Customer Status] IN ('Churned')
GROUP BY [Churn Reason]
ORDER BY reason_customers_churned DESC;

-- We want to know what are the better offers of the competition
SELECT *
FROM MavenTelecom..telecom_customer_churn
WHERE [Churn Reason] NOT LIKE 'Competitor had%' AND [Customer Status] IN ('Churned') AND [Churn Category] IN ('Competitor')
ORDER BY [Churn Reason];

-- How much our churned customers used Internet services, thier benefits and the reason they left.
SELECT [Internet Service], [Avg Monthly GB Download], [Streaming Movies], [Streaming Music], [Streaming TV], [Unlimited Data], [Churn Reason], COUNT(*) OVER (PARTITION BY [Internet Service], [Churn Reason])
AS cnt_customers_reason
FROM MavenTelecom..telecom_customer_churn
WHERE [Customer Status] IN ('Churned') 
ORDER BY [Internet Service], [Churn Reason];

SELECT [Avg Monthly GB Download], [Unlimited Data], [Churn Reason], COUNT(*) OVER (PARTITION BY [Unlimited Data], [Churn Reason])
AS cnt_customers_reason
FROM MavenTelecom..telecom_customer_churn
WHERE [Customer Status] IN ('Churned') AND [Internet Service] IN ('Yes') 
ORDER BY [Unlimited Data], [Churn Reason];