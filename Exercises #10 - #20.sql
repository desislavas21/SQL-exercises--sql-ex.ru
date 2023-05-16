/*
11
Find out the average speed of PCs.*/

SELECT  AVG(speed)
FROM    pc
;

/*
12
Find out the average speed of the laptops priced over $1000.
*/
SELECT  AVG(speed)
FROM    laptop
WHERE   price > 1000
;

/*
13
Find out the average speed of the PCs produced by maker A.
*/
SELECT  "avg"
FROM (
SELECT  AVG(speed), maker
FROM    pc
JOIN    product USING(model)
GROUP BY maker) AS w
WHERE   maker = 'A'
;

/*
14
For the ships in the Ships table that have at least 10 guns, get the class, name, and country.
*/
SELECT  "class",
        "name",
        country
FROM    ships
JOIN    classes USING("class")
WHERE   numguns >= 10
;

/*
15
Get hard drive capacities that are identical for two or more PCs. 
Result set: hd.
*/
SELECT  hd 
FROM (
SELECT  hd, 
        COUNT(model)
FROM    pc 
GROUP BY hd) AS q 
WHERE   count >= 2
;

/*
16
Get pairs of PC models with identical speeds and the same RAM capacity. Each resulting pair should be displayed only once, i.e. (i, j) but not (j, i). 
Result set: model with the bigger number, model with the smaller number, speed, and RAM.
*/

SELECT  DISTINCT
        p_1.model, 
        p_2.model, 
        p_1.speed, 
        p_2.ram
FROM    pc AS p_1, 
        pc AS p_2
WHERE   p_1.speed = p_2.speed 
        AND p_1.ram = p_2.ram
        AND p_1.model > p_2.model
;

/*
17
Get the laptop models that have a speed smaller than the speed of any PC. 
Result set: type, model, speed.
*/

SELECT  DISTINCT
        'Laptop' AS "type",
        model,
        speed
FROM    laptop
WHERE   speed < (SELECT MIN(speed) FROM pc)
;

/*
18
Find the makers of the cheapest color printers.
Result set: maker, price.
*/

SELECT  DISTINCT
        product.maker,
        printer.price
FROM    product
JOIN    printer USING(model)
WHERE   printer.price = (SELECT MIN(price) FROM printer WHERE color = 'y') AND  printer.color = 'y'
;

/*
19
For each maker having models in the Laptop table, find out the average screen size of the laptops he produces. 
Result set: maker, average screen size.
*/

SELECT  DISTINCT
        maker,
        AVG(screen)
FROM    product 
JOIN    laptop  USING(model)
GROUP BY    maker
ORDER BY    maker
;

/*
20
Find the makers producing at least three distinct models of PCs.
Result set: maker, number of PC models.
*/

SELECT  maker,
        COUNT(DISTINCT model)
FROM    product
WHERE   "type" = 'PC'
GROUP BY maker
HAVING  COUNT(DISTINCT model) > 2
;

