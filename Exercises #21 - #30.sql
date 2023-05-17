/*
21
Find out the maximum PC price for each maker having models in the PC table. Result set: maker, maximum price.
*/
SELECT  maker,
        MAX(price)
FROM    pc 
JOIN    product USING(model)
GROUP BY maker
ORDER BY maker
;
/*
22
For each value of PC speed that exceeds 600 MHz, find out the average price of PCs with identical speeds.
Result set: speed, average price.
*/

SELECT  speed, 
        AVG(price) AS "avg price"
FROM    pc
WHERE   speed > 600
GROUP BY speed
;

/*
23
Get the makers producing both PCs having a speed of 750 MHz or higher and laptops with a speed of 750 MHz or higher. 
Result set: maker
*/
SELECT  maker
FROM    product
JOIN    pc USING(model)
WHERE   speed >= 750
INTERSECT
SELECT  maker 
FROM    product
JOIN    laptop USING(model)  
WHERE   speed >= 750 
;

/*
24
List the models of any type having the highest price of all products present in the database.
*/
WITH my_cte AS (
SELECT model, price FROM laptop WHERE price = (SELECT MAX(price) FROM laptop)
UNION 
SELECT model, price FROM pc WHERE price = (SELECT MAX(price) FROM pc)
UNION 
SELECT model, price FROM printer WHERE price = (SELECT MAX(price) FROM printer)
)
SELECT model
FROM my_cte
WHERE price = (SELECT MAX(price) FROM my_cte)
;

/*
25
Find the printer makers also producing PCs with the lowest RAM capacity and the highest processor speed of all PCs having the lowest RAM capacity. 
Result set: maker.
*/
SELECT  DISTINCT 
        maker
FROM    Product 
JOIN    PC  USING(model)
WHERE ram = (
	SELECT MIN(ram)
	FROM PC)
AND speed = (
	SELECT MAX(speed)
	FROM PC
	WHERE ram = (
		SELECT MIN(ram)
		FROM PC))
AND maker IN (
	SELECT maker
	FROM Product
	WHERE TYPE='Printer'
)
;

/*
26
Find out the average price of PCs and laptops produced by maker A.
Result set: one overall average price for all items.
*/
WITH cpe AS (
SELECT  maker, 
        price 
FROM    pc 
JOIN    product USING(model)
WHERE   maker = 'A'
UNION ALL
SELECT  maker, 
        price 
FROM    laptop
JOIN    product USING(model)
WHERE   maker = 'A'
)
SELECT  AVG(price)
FROM    cpe
;

/*
27
Find out the average hard disk drive capacity of PCs produced by makers who also manufacture printers.
Result set: maker, average HDD capacity.
*/
SELECT  maker,
        AVG(hd)
FROM    pc 
JOIN    product USING(model)
WHERE   maker IN (SELECT maker FROM product WHERE "type" = 'Printer')
GROUP BY maker
;

/*
28
Using Product table, find out the number of makers who produce only one model.
*/
SELECT COUNT(q.maker)
FROM 
(
SELECT  maker, 
        COUNT(DISTINCT model)
FROM    product
GROUP BY maker
HAVING  COUNT(DISTINCT model) = 1
) AS q
;

/*
29
Under the assumption that receipts of money (inc) and payouts (out) are registered not more than once a day for each collection point [i.e. the primary key consists of (point, date)], write a query displaying cash flow data (point, date, income, expense). 
Use Income_o and Outcome_o tables.
*/
WITH cpe AS (
SELECT  "i".point AS i_p,
        "o".point AS o_p,
        "i".date AS i_d,
        "o".date AS o_d,
        "inc",
        "out"
FROM    income_o AS i 
FULL JOIN   outcome_o AS o 
ON      (i.point = o.point AND i.date = o.date)
)
SELECT  CASE WHEN i_p IS NULL THEN o_p ELSE i_p END AS "point",
        CASE
            WHEN    i_d IS NULL THEN o_d 
            WHEN    o_d IS NULL THEN i_d
            ELSE    i_d
            END AS "date",
        "inc" AS "income",
        "out" AS "outcome"
FROM    cpe
ORDER BY "point"
;

/*
30
Under the assumption that receipts of money (inc) and payouts (out) can be registered any number of times a day for each collection point [i.e. the code column is the primary key], display a table with one corresponding row for each operating date of each collection point.
Result set: point, date, total payout per day (out), total money intake per day (inc). 
Missing values are considered to be NULL.*/

SELECT  "point",
        "date",
        SUM("out") AS "total payout per day (out)",
        SUM("inc") AS "total money intake per day (inc)"
FROM    (
SELECT      CASE
            WHEN income.point = outcome.point THEN income.point
            WHEN income.point IS NULL THEN outcome.point
            ELSE  income.point
            END AS "point",
            CASE
            WHEN income.date = outcome.date THEN income.date
            WHEN income.date IS NULL THEN outcome.date
            ELSE  income.date
            END AS "date",
            income.inc,
            outcome.out
FROM        income
FULL JOIN   outcome 
ON          (income.date = outcome.date AND income.point = outcome.point AND income.code = outcome.code)) AS q
GROUP BY    ("point", "date")
;


