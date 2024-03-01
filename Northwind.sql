-- Northwind project

-- 1 Write a query to get a product name and quantity and unit 
use northwind;
select * from products;
select ProductName, QuantityPerUnit, UnitPrice from products;

-- 2 Write a query to get current Product list
select ProductID, Productname from products;

-- 3 Write a query to get discontinued product list
select ProductID, Productname from products
where discontinued=1;

-- 4 Write a query to get most expensive and least expensive product list
select productname , unitprice from products
where unitprice in (select max(unitprice) from products ) 
or unitprice in (select min(unitprice) from products ) ;

-- 5 Write a query to get a product list(id, name, unitprice) where current products cost less than $20
select productid, productname, unitprice from products
where unitprice<20;

-- 6 Write a query to get product list (id, name, unit price) where products cost between $15 and $25
select productid, productname, unitprice from products
where unitprice between 15 and 25;

-- 7 Write a query to get product list (name, unit price) of above average price 
select productname, unitprice from products
where unitprice>(select avg(unitprice) from products);

-- 8 Write a query to get a product list (name, price) of ten most expensive products
select productname, unitprice from products
order by unitprice desc limit 10;

-- 9 Write a query to count current and discontinued products
select count(case when discontinued=0 then productid end) as current, count(case when discontinued=1 then productid end) as discontinued
from products;
-- or
select discontinued, count(1) from products
group by discontinued;






