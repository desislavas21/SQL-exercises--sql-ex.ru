/*
41
For each maker who has models at least in one of the tables PC, Laptop, or Printer, determine the maximum price for his products. 
Output: maker; if there are NULL values among the prices for the products of a given maker, display NULL for this maker, otherwise, the maximum price.
*/
WITH trabl_1 AS (SELECT  DISTINCT maker 
FROM    product
WHERE   model IN (SELECT model FROM pc UNION SELECT model FROM Laptop UNION SELECT model FROM printer))

SELECT  maker, 
          CASE 
            WHEN sum(CASE 
                        WHEN price IS NULL THEN 1 
                        ELSE 0 
                     END) > 0 THEN NULL
            ELSE max(price) 
          END AS price
FROM (
SELECT  maker, model, price
FROM    Laptop
JOIN    product USING(model)
UNION
SELECT  maker, model, price
FROM    pc
JOIN    product USING(model)
UNION
SELECT  maker, model, price
FROM    Printer
JOIN    product USING(model)) AS q
WHERE   maker IN (SELECT maker FROM trabl_1)
GROUP BY maker
;

/*
42
Find the names of ships sunk at battles, along with the names of the corresponding battles.
*/
SELECT  ship,
        battle 
FROM    outcomes
WHERE   result = 'sunk'
;

/*
43
Get the battles that occurred in years when no ships were launched into water.
*/
SELECT  battles.name
FROM    battles
WHERE   date_part('year', battles.date::date) NOT IN (
SELECT  launched
FROM    ships
WHERE   launched IS NOT NULL)
;

/*
44
Find all ship names beginning with the letter R.
*/
SELECT  "name"
FROM    (SELECT "name" FROM ships UNION SELECT "ship" AS "name" FROM outcomes) AS q
WHERE   "name" LIKE 'R%'
;

/*
45
Find all ship names consisting of three or more words (e.g., King George V).
Consider the words in ship names to be separated by single spaces, and the ship names to have no leading or trailing spaces.
*/
SELECT  "name"
FROM    (SELECT "name" FROM ships UNION SELECT "ship" AS "name" FROM outcomes) AS q
WHERE   "name" LIKE '% % %'
;

/*
46
For each ship that participated in the Battle of Guadalcanal, get its name, displacement, and the number of guns.
*/
SELECT  DISTINCT 
        ship, 
        displacement, 
        numGuns
FROM    classes AS c
LEFT JOIN ships AS s
  ON    c.class = s.class
RIGHT JOIN outcomes o 
  ON    c.class = o.ship
  OR    s.name = o.ship
WHERE   battle = 'Guadalcanal'

/*
47
Find the countries that have lost all their ships in battles.
*/

WITH all_ships AS (
 SELECT ship, country 
 FROM   outcomes AS o
 JOIN   classes c 
 ON     c.class = o.ship
 UNION
 SELECT "name", 
        country 
 FROM   ships AS s
 JOIN   classes AS c 
 ON     c.class = s.class
),
ships_per_country AS (
 SELECT country, 
        COUNT(ship) AS count 
 FROM all_ships
 GROUP BY country
),
ships_sunk AS (
 SELECT ship, result 
 FROM outcomes
 WHERE result = 'sunk'
),
ships_sunked_per_country AS (
 SELECT aships.country, 
        COUNT(ssunk.result) AS count 
 FROM   all_ships AS aships
 JOIN   ships_sunk AS ssunk 
 ON     ssunk.ship = aships.ship
 GROUP BY aships.country
)
SELECT spc.country 
FROM ships_per_country AS spc
JOIN ships_sunked_per_country AS sspc 
ON  sspc.country = spc.country
WHERE spc.count = sspc.count
;

/*
48
Find the ship classes having at least one ship sunk in battles.*/
WITH all_ships AS (
SELECT  "class", "name", country
FROM    ships
RIGHT JOIN  classes USING("class")    
)
SELECT  "class"
FROM (
SELECT  COUNT(ship), "class"
FROM    outcomes
JOIN    all_ships 
ON      outcomes.ship = all_ships.name OR outcomes.ship = all_ships.class
WHERE   result = 'sunk'
GROUP BY "class"
HAVING COUNT(ship) >= 1) AS w
;

/*
49
Find the names of the ships having a gun caliber of 16 inches (including ships in the Outcomes table).*/

SELECT "name"
FROM 
    (SELECT  "name",
            bore
    FROM    ships
    JOIN    classes USING("class")
    UNION
    SELECT  "ship",
            bore
    FROM    outcomes AS o
    JOIN    classes AS c ON o.ship = c.class) AS q
WHERE bore = 16;

/*
50
Find the battles in which Kongo-class ships from the Ships table were engaged.
*/
SELECT  DISTINCT 
        battle
FROM    outcomes AS o
WHERE   ship IN (SELECT "name" FROM ships WHERE "class" = 'Kongo')

