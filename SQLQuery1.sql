--Data Exploration
SELECT *
FROM CH_python$;

--Calculate average price, mileage, and tax
SELECT AVG(price) AS avg_price, AVG(mileage) AS avg_mileage, AVG(tax) AS avg_tax
FROM CH_python$;

-- Distribution of fuel types
SELECT fuelType, COUNT(*) AS count
FROM CH_python$
GROUP BY fuelType;

-- Average price over the years
SELECT year, AVG(price) AS avg_price
FROM CH_python$
GROUP BY year
ORDER BY year;  

-- Top 5 most expensive cars
SELECT DISTINCT TOP 5 *
FROM CH_python$
ORDER BY price DESC;

--Average Tax for Each Transmission Type
SELECT year, SUM(tax) AS total_tax
FROM CH_python$
GROUP BY year
ORDER BY year;

--Low mileage cars with low price
SELECT TOP 6*
FROM CH_python$
WHERE mileage < 100000 AND price < 5000;