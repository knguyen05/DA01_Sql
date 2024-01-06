--- 1) Doanh thu theo từng ProductLine, Year  và DealSize?
select PRODUCTLINE, YEAR_ID, DEALSIZE, 
SUM(sales) as revenue
from sales_dataset_rfm_prj_clean
where status = 'Shipped'
group by PRODUCTLINE, YEAR_ID, DEALSIZE
order by PRODUCTLINE, YEAR_ID, DEALSIZE

---2) Đâu là tháng có bán tốt nhất mỗi năm?
with t1 as(
select MONTH_ID, year_id,
sum (sales) as revenue, count(ordernumber) as ORDER_NUMBER ,
ROW_NUMBER() over(partition by year_id order by sum (sales) desc ) as rk
from sales_dataset_rfm_prj_clean
  where status = 'Shipped'
group by MONTH_ID, year_id
)
select MONTH_ID, year_id, revenue, ORDER_NUMBER
from t1
where rk=1

---3) Product line nào được bán nhiều ở tháng 11?
with t1 as(
select year_id, productline,
sum (sales) as revenue, count(ordernumber) as ORDER_NUMBER,
ROW_NUMBER() over(partition by year_id order by sum (sales) desc ) as rk
from sales_dataset_rfm_prj_clean
	where month_id=11 and status = 'Shipped'
group by year_id, productline
)
select year_id, productline, revenue, ORDER_NUMBER
from t1
where rk=1

--Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
select year_id, PRODUCTLINE,
sum(sales) as revenue,
ROW_NUMBER() over(partition by year_id order by sum (sales) desc ) as rank
from sales_dataset_rfm_prj_clean
where country='UK' and  status = 'Shipped'
Group by year_id, PRODUCTLINE

--5) Ai là khách hàng tốt nhất, phân tích dựa vào RFM 

with rfm as (
SELECT 
CONTACTFIRSTNAME, CONTACTLASTNAME,
current_date - MAX(orderdate) as R,
count( CONTACTfullname) as F,
sum(sales) as M
from sales_dataset_rfm_prj_clean
group by CONTACTFIRSTNAME, CONTACTLASTNAME
),
rfm_score as(
select 
CONTACTFIRSTNAME, CONTACTLASTNAME,
ntile(5) over(order by R desc) as R_score,
ntile(5) over(order by F )as F_score,
ntile(5) over(order by M )as M_score
from rfm),
rfm_final as(
select CONTACTFIRSTNAME, CONTACTLASTNAME,
cast(R_score as VARCHAR)||cast(F_score as VARCHAR)||cast(M_score as VARCHAR) as rfm_score
from rfm_score)
select rfm_final.CONTACTFIRSTNAME, rfm_final.CONTACTLASTNAME,
segment_score.segment
from rfm_final
JOIN segment_score ON segment_score.score= rfm_final.rfm_score
where segment = 'Champions'


