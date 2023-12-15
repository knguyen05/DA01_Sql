--ex1
SELECT COUNTRY.Continent, FLOOR(AVG(CITY.Population))
FROM CITY
INNER JOIN COUNTRY
ON CITY.CountryCode = COUNTRY.Code
GROUP BY COUNTRY.Continent;

--EX2
SELECT 
ROUND(  
  CAST(SUM(CASE
    WHEN texts.signup_action='Confirmed' THEN 1 ELSE 0 END) AS DECIMAL)/COUNT(DISTINCT emails.email_id), 2)  
  AS confirm_rate
FROM emails
LEFT JOIN texts
ON emails.email_id=texts.email_id;

--EX3
SELECT age_breakdown.age_bucket,
ROUND(
SUM(CASE WHEN activity_type='send' THEN activities.time_spent ELSE 0 END)/SUM(CASE WHEN activity_type IN ('open','send') THEN activities.time_spent ELSE 0 END)*100.0,2) AS send_perc,
ROUND(
SUM(CASE WHEN activity_type='open' THEN activities.time_spent ELSE 0 END)/SUM(CASE WHEN activity_type IN ('open','send') THEN activities.time_spent ELSE 0 END)*100.0,2) AS open_perc
FROM activities
LEFT JOIN age_breakdown
ON activities.user_id= age_breakdown.user_id
GROUP BY age_breakdown.age_bucket;

--ex4
SELECT customer_contracts.customer_id
FROM customer_contracts
LEFT JOIN products 
ON customer_contracts.product_id =products.product_id
GROUP BY customer_contracts.customer_id
HAVING COUNT(DISTINCT products.product_category)=3;

  
--EX5
SELECT m.employee_id, m.name,
SUM(CASE
    WHEN m. employee_id is not null then 1 else 0 END) AS reports_count,
ROUND(AVG(e.age),0) AS average_age
FROM Employees AS e
LEFT JOIN Employees AS m
ON m.employee_id=e.reports_to
group by m.employee_id, m.name
having SUM(CASE
    WHEN e.reports_to is not null then 1 else 0 END) > 0;

--EX6
SELECT Products.product_name, 
SUM(Orders.unit) AS unit 
FROM Orders
LEFT JOIN Products
ON Products.product_id = Orders.product_id
WHERE EXTRACT(month FROM Orders.order_date) = 2 AND EXTRACT(year FROM Orders.order_date) = 2020
GROUP BY Products.product_name
HAVING SUM(Orders.unit) >=100;

--EX7
SELECT pages.page_id
FROM pages
LEFT JOIN page_likes
ON pages.page_id =page_likes.page_id
WHERE page_likes.liked_date IS NULL
ORDER BY pages.page_id

---------------------------MID COURSE TEST--------------------------------------------------
--ex1
SELECT DISTINCT min(replacement_cost) FROM film;
  
--ex2
select 
CASE
	WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
	WHEN replacement_cost BETWEEN 20 AND 24.99 THEN 'medium'
	ELSE 'high' END Category,
COUNT(*) AS numb
from film
group by Category;

--ex3
select film.title, film.length, category.name
from film
inner JOIN film_category
ON film.film_id=film_category.film_id 
inner JOIN category
ON category.category_id =film_category.category_id 
where category.name IN ('Drama', 'Sports')
order by film.length desc
limit 1;

--ex4
select category.name, count(film.title)
from film
inner JOIN film_category
ON film.film_id=film_category.film_id 
inner JOIN category
ON category.category_id =film_category.category_id 
Group by category.name
order by count(film.title) desc
limit 1;

--ex5
select actor.first_name||' '|| actor.last_name as name,
count(distinct film_id) as number
from actor
INNER JOIN film_actor
ON actor.actor_id= film_actor.actor_id
group by actor.first_name||' '|| actor.last_name
order by number desc
limit 1;

--ex6
select 
SUM(CASE
	WHEN customer.address_id is null THEN 1 ELSE 0 END) as number
from address
LEFT JOIN customer
ON address.address_id=customer.address_id;

--ex7
select city.city, sum(payment.amount) as revenue
from city
INNER JOIN  address
ON address.city_id=city.city_id
INNER JOIN customer
ON address.address_id=customer.address_id
INNER JOIN payment
ON payment.customer_id=customer.customer_id
group by city.city
order by sum(payment.amount) desc
limit 1;

--ex8- cau hoi doanh thu cao nhat ma dap an thap nhat nen e lam thap nhat nha
select city.city, country.country, sum(payment.amount) as revenue
from city
INNER JOIN country
ON country.country_id=city.country_id
INNER JOIN  address
ON address.city_id=city.city_id
INNER JOIN customer
ON address.address_id=customer.address_id
INNER JOIN payment
ON payment.customer_id=customer.customer_id
group by city.city, country.country
order by sum(payment.amount) 
limit 1;


