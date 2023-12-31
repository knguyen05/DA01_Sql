----Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng ( Từ 1/2019-4/2022)_trong BigQuery thay cho group by kieu nhu nay luon cung ra kq
select 
CONCAT(extract(year from created_at),'-',
CASE WHEN (extract(month from created_at)) <10 then CONCAT('0',extract(month from created_at)) ELSE CAST(extract(month from created_at) AS string) END)
as month_year,
count( distinct user_id) as total_user,
COUNTIF(status = 'Complete') as total_order
from bigquery-public-data.thelook_ecommerce.order_items
where created_at BETWEEN TIMESTAMP('2019-01-01') AND TIMESTAMP('2022-04-30')
group by month_year
order by month_year;

--Thống kê giá trị đơn hàng trung bình và tổng số người dùng khác nhau mỗi tháng 
select 
CONCAT(extract(year from created_at),'-',
CASE WHEN (extract(month from created_at)) <10 then CONCAT('0',extract(month from created_at)) ELSE CAST(extract(month from created_at) AS string) END)
as month_year,
count(distinct user_id) as distinct_users,
sum(sale_price)/count(distinct order_id) as average_order_value
from bigquery-public-data.thelook_ecommerce.order_items
where created_at BETWEEN TIMESTAMP('2019-01-01') AND TIMESTAMP('2022-04-30')
group by month_year
order by month_year;

----3. Tìm các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính ( Từ 1/2019-4/2022)
with t1 as (
select first_name,last_name, gender,age,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY age ASC) AS youngest_rank,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY age DESC) AS oldest_rank
from bigquery-public-data.thelook_ecommerce.users
where created_at BETWEEN TIMESTAMP('2019-01-01') AND TIMESTAMP('2022-04-30'))
select first_name,last_name, gender,age,
CASE WHEN youngest_rank = 1 THEN 'youngest'ELSE 'oldest' END AS tag
from t1
where youngest_rank = 1 OR oldest_rank = 1
order by gender, tag;

--4. Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm). 
with result as(
with t1 as (
select *,
CONCAT(extract(year from sold_at),'-',
CASE WHEN (extract(month from sold_at)) <10 then CONCAT('0',extract(month from sold_at)) ELSE CAST(extract(month from sold_at) AS string) END)
as month_year
from bigquery-public-data.thelook_ecommerce.inventory_items
where sold_at is not null)
select month_year,
product_id, product_name, sum(product_retail_price) as sales, sum(cost) as cost, sum(product_retail_price - cost) as profit, 
DENSE_RANK() OVER (PARTITION BY month_year ORDER BY sum(product_retail_price - cost) DESC) as rank_per_month
from t1
group by month_year,
product_id, product_name)
select *
from result
where rank_per_month <=5
order by month_yea

--5. Thống kê tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng qua ( giả sử ngày hiện tại là 15/4/2022)
select DATE(sold_at)  as dates , product_category, sum(product_retail_price) as revenue
from bigquery-public-data.thelook_ecommerce.inventory_items
where sold_at is not null and sold_at between '2022-01-15' and'2022-04-15'
group by dates, product_category
order by dates, product_category;


