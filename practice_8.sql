--ex1
with t1 as
(Select *,
Case
when order_date=customer_pref_delivery_date then 'immediate' else 'scheduled' end as col_1,
row_number() over(partition by customer_id order by order_date)  as first_order
from Delivery)
select 
round(cast(sum(case when col_1='immediate' and first_order=1 then 1 else 0 end)as decimal)/
sum(case when first_order =1 then 1 else 0 end)*100,2) as immediate_percentage
from t1;

--ex2
