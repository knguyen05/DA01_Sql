--Ex1
select NAME from CITY
Where COUNTRYCODE = 'USA' and POPULATION >120000;

--ex2
select * from CITY
WHERE COUNTRYCODE = 'JPN';

--ex3
SELECT CITY, STATE FROM STATION;

--EX4
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE'A%' OR CITY LIKE 'E%' OR CITY LIKE 'I%' OR CITY LIKE 'O%'OR CITY LIKE 'U%';

--EX5
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE'%A' OR CITY LIKE '%E' OR CITY LIKE '%I' OR CITY LIKE '%O'OR CITY LIKE '%U';

--EX6
SELECT DISTINCT CITY FROM STATION
WHERE NOT (CITY LIKE'A%' OR CITY LIKE 'E%' OR CITY LIKE 'I%' OR CITY LIKE 'O%'OR CITY LIKE 'U%');

--ex7
Select name from Employee
order by name asc;

--ex8
select name from Employee
where salary > 2000 and months <10
order by employee_id asc;

--ex9
select product_id from Products
where low_fats ='Y' and recyclable = 'Y';

--ex10
select name from Customer
where referee_id <> 2 or referee_id is null;

-ex11
select name, population, area from World
where area >=3000000 or population >=25000000;

--ex12
select distinct author_id as id from Views
where author_id = viewer_id
order by id asc;

--ex13
SELECT part, assembly_step FROM parts_assembly
where finish_date is null;

--ex14
select * from lyft_drivers
where yearly_salary <= 30000 or yearly_salary >70000;

--ex15
select advertising_channel from uber_advertising
where  money_spent >100000 and year = 2019;

