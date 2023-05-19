/*
31
For ship classes with a gun caliber of 16 in. or more, display the class and the country.
*/
SELECT  "class",
        country
FROM    classes
WHERE   bore >= 16
;

/*
32
One of the characteristics of a ship is one-half the cube of the calibre of its main guns (mw). 
Determine the average ship mw with an accuracy of two decimal places for each country having ships in the database.
*/
SELECT  country, 
        CAST(AVG(POWER(bore,3.0)/2.0) AS NUMERIC(6,2))
FROM    (SELECT  country, 
                 bore, 
                 "name"
        FROM classes c
        JOIN ships s
        ON s.class = c.class
        UNION
        SELECT country, 
                 bore, 
                 ship
        FROM classes c
        JOIN outcomes o
        ON o.ship = c.class) AS a
GROUP BY country
;

/*
33
Get the ships sunk in the North Atlantic battle. 
Result set: ship.
*/
SELECT  ship 
FROM    outcomes
WHERE   battle = 'North Atlantic' AND result = 'sunk'
;

/*
34
In accordance with the Washington Naval Treaty concluded in the beginning of 1922, it was prohibited to build battle ships with a displacement of more than 35 thousand tons. 
Get the ships violating this treaty (only consider ships for which the year of launch is known). 
*/
SELECT  DISTINCT "name"
FROM    ships
FULL JOIN   classes
ON      (ships.class = classes.class OR ships.name = classes.class)
WHERE   "type" = 'bb' AND displacement > 35000 AND launched IS NOT NULL AND launched >= 1922
;

/*
35
Find models in the Product table consisting either of digits only or Latin letters (A-Z, case insensitive) only.
Result set: model, type.
*/
SELECT 	model, 
		"type"
FROM 	product
WHERE 	LOWER(model) NOT LIKE '%[^a-z]%'
  OR 	model NOT LIKE '%[^0-9]%'
;

/*
36
List the names of lead ships in the database (including the Outcomes table).
Lead ships -> name = class
*/
SELECT DISTINCT *
FROM (
SELECT  "name"
FROM    ships
UNION   
SELECT  "ship" AS "name"
FROM    outcomes) AS w
WHERE   "name" IN (SELECT "class" FROM classes)
;

/*
37
Find classes for which only one ship exists in the database (including the Outcomes table).
*/

WITH tabl_1 AS (
SELECT  "name" AS ship,
        "class"
FROM    ships
LEFT JOIN classes USING("class")
),

tabl_2 AS 
(
SELECT  tabl_1.ship, 
        tabl_1.class
FROM    outcomes
LEFT JOIN    tabl_1
ON      (outcomes.ship = tabl_1.ship OR outcomes.ship = tabl_1.class)
WHERE   tabl_1.ship IS NOT NULL AND
        tabl_1.class IS NOT NULL
),
tabl_3 AS 
(SELECT * 
FROM    tabl_2
UNION ALL
SELECT * 
FROM    tabl_1)

SELECT  tabl_3."class",
        COUNT(ship)
FROM    tabl_3
LEFT JOIN   classes 
ON      (tabl_3.ship = classes.class OR tabl_3.class = classes.class)
GROUP BY tabl_3."class"
;

/*
38
Find countries that ever had classes of both battleships (‘bb’) and cruisers (‘bc’).
*/
SELECT  country
FROM    classes
WHERE   "type" = 'bb'
INTERSECT
SELECT  country 
FROM    classes
WHERE   "type" ='bc'

/*
39
Find the ships that `survived for future battles`; that is, after being damaged in a battle, they participated in another one, which occurred later.
*/
SELECT DISTINCT q.ship 
FROM 
(
SELECT  ship, 
        result, 
        date 
FROM    outcomes
JOIN    battles
ON      outcomes.battle=battles.name
WHERE   result = 'damaged'
) AS q
JOIN
(
SELECT  ship, 
        result, 
        date
FROM outcomes
JOIN battles
ON outcomes.battle=battles.name) AS w
ON q.ship = w.ship
AND w.date > q.date
;

/*
40
Get the makers who produce only one product type and more than one model. Output: maker, type.
*/
SELECT  DISTINCT 
        p.maker, 
        p.type
FROM Product AS p 
JOIN (
	SELECT maker 
	FROM Product
	GROUP BY maker
	HAVING COUNT(DISTINCT "type") = 1 AND COUNT(DISTINCT model) > 1
) AS q 
ON p.maker = q.maker
;
