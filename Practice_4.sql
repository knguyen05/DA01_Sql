--EX1
SELECT 
SUM(CASE
 WHEN device_type = 'laptop' THEN 1 ELSE 0
 END) AS laptop_views,
SUM(CASE
 WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0
 END) AS mobile_views
FROM viewership;

--EX2
SELECT x, y, z,
CASE
 WHEN x+y>z and x+z>y and y+z>x THEN 'Yes' ELSE 'No' END AS triangle
FROM Triangle;

--EX3 - bai k co du lieu k check duoc
SELECT 
ROUND(SUM(CASE 
 WHEN call_category IS NULL OR call_category ='n/a' THEN 1 ELSE 0 END) / COUNT(case_id)*100, 1)  AS call_percentage
FROM callers;

--EX4
select name
from Customer
where referee_id <> 2 or referee_id is null;
--EX4(option2)
select name
from Customer
where COALESCE(referee_id,0) <>2;

--EX5
select survived,
SUM(CASE
WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,
SUM(CASE
WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class,
SUM(CASE
WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_classs
from titanic 
group by survived;
