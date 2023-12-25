--1 Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER) 
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE INTEGER USING ordernumber::INTEGER,
ALTER COLUMN quantityordered TYPE INTEGER USING quantityordered::INTEGER,
ALTER COLUMN priceeach TYPE DECIMAL(10,2) USING priceeach::DECIMAL(10,2),
ALTER COLUMN orderlinenumber TYPE INTEGER USING orderlinenumber::INTEGER,
ALTER COLUMN sales TYPE DECIMAL(10,2) USING sales::DECIMAL(10,2),
ALTER COLUMN orderdate TYPE DATE USING orderdate::DATE

--2 Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.
select * from sales_dataset_rfm_prj
WHERE 
    ORDERNUMBER IS NULL OR
    QUANTITYORDERED IS NULL OR
    PRICEEACH IS NULL OR
    ORDERLINENUMBER IS NULL  OR
    SALES IS NULL

--3 Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME 
ALTER TABLE sales_dataset_rfm_prj
ADD column contactlastname VARCHAR(50);
UPDATE sales_dataset_rfm_prj
SET contactlastname = INITCAP(SUBSTRING(contactfullname FROM POSITION('-' IN contactfullname) + 1);

--4 Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 
ALTER TABLE sales_dataset_rfm_prj
ADD column QTR_ID INTEGER,
ADD column MONTH_ID INTEGER,
ADD column YEAR_ID INTEGER;

UPDATE sales_dataset_rfm_prj
SET MONTH_ID = EXTRACT(MONTH FROM orderdate),
	YEAR_ID = EXTRACT(YEAR FROM orderdate);
UPDATE sales_dataset_rfm_prj
SET QTR_ID = CASE WHEN 1<=MONTH_ID and MONTH_ID<=3 THEN 1 
					WHEN 4<=MONTH_ID and MONTH_ID<=6 THEN 2 
					WHEN 7<=MONTH_ID and MONTH_ID<=9 THEN 3 ELSE 4 END;

--5 Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó (2 cách) ( Không chạy câu lệnh trước khi bài được review)
--cach 1_box_plot
with outlier as
(select Q1-1.5*IQR as min_value, Q3+1.5*IQR as max_value
from(
select
percentile_cont(0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED ) as Q1,
percentile_cont(0.75) WITHIN GROUP (ORDER BY QUANTITYORDERED ) as Q3,
percentile_cont(0.75) WITHIN GROUP (ORDER BY QUANTITYORDERED )-percentile_cont(0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED ) as IQR
from sales_dataset_rfm_prj) as a ) 
Select * from sales_dataset_rfm_prj
where QUANTITYORDERED< (select min_value from outlier)
or QUANTITYORDERED>(select max_value from outlier)

--cach2_Z-score
with outlier as
(select QUANTITYORDERED,
(select avg(QUANTITYORDERED) from sales_dataset_rfm_prj) as avg,
(select stddev(QUANTITYORDERED) from sales_dataset_rfm_prj) as stddev 
 from sales_dataset_rfm_prj)
 select QUANTITYORDERED, (QUANTITYORDERED-avg)/stddev as z_score
 from outlier
 where abs((QUANTITYORDERED-avg)/stddev)>3;

--6 CREATE TABLE SALES_DATASET_RFM_PRJ_CLEAN as
CREATE TABLE SALES_DATASET_RFM_PRJ_CLEAN as
(SELECT * from sales_dataset_rfm_prj)
