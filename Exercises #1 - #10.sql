/*
1
Find the model number, speed and hard drive capacity for all the PCs with prices below $500.
Result set: model, speed, hd.
*/
SELECT  model,
        speed,
        hd
FROM    pc
WHERE   price < 500;

/*
2
List all printer makers. Result set: maker.
*/
SELECT DISTINCT maker
FROM product 
WHERE "type" = 'Printer';

/*
3
Find the model number, RAM and screen size of the laptops with prices over $1000.
*/
SELECT  model,
        ram, 
        screen
FROM    laptop
WHERE   price > 1000;

/*
4
Find all records from the Printer table containing data about color printers.
*/
SELECT  *
FROM    printer
WHERE   color = 'y';

/*
5
Find the model number, speed and hard drive capacity of PCs cheaper than $600 having a 12x or a 24x CD drive.
*/
SELECT  model, 
        speed,
        hd
FROM    pc
WHERE   price < 600
    AND cd IN ('12x', '24x');

/*
6
For each maker producing laptops with a hard drive capacity of 10 Gb or higher, find the speed of such laptops. Result set: maker, speed.
*/
SELECT DISTINCT p.maker,    
                l.speed
FROM    product AS p 
JOIN    laptop AS l USING(model)
WHERE   l.hd >= 10;


/*
7
Get the models and prices for all commercially available products (of any type) produced by maker B.
*/
SELECT  model, 
        price
FROM    laptop 
JOIN    product USING(model)
WHERE   maker = 'B'
UNION
SELECT  model, 
        price
FROM    pc
JOIN    product USING(model)
WHERE   maker = 'B'
UNION
SELECT  model, 
        price
FROM    printer 
JOIN    product USING(model)
WHERE   maker = 'B' 
;

/*
8
Find the makers producing PCs but not laptops.
*/
SELECT DISTINCT maker
FROM product
WHERE "type" = 'PC' 
        AND maker NOT IN (
        SELECT maker
        FROM product
        WHERE "type" = 'Laptop')
;

/*
9 
Find the makers of PCs with a processor speed of 450 MHz or more. Result set: maker.
*/
SELECT  DISTINCT maker
FROM    product 
JOIN    pc USING(model)
WHERE   pc.speed >= 450
;

/*
10
Find the printer models having the highest price. Result set: model, price.
*/
SELECT  model,
        price
FROM    printer
WHERE   price = (SELECT MAX(price) FROM printer)
;