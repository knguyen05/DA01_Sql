--1 Chuyển đổi kiểu dữ liệu phù hợp cho các trường ( sử dụng câu lệnh ALTER) 
ALTER TABLE sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE INTEGER USING ordernumber::INTEGER,
ALTER COLUMN quantityordered TYPE INTEGER USING quantityordered::INTEGER,
ALTER COLUMN priceeach TYPE DECIMAL(10,2) USING priceeach::DECIMAL(10,2),
ALTER COLUMN orderlinenumber TYPE INTEGER USING orderlinenumber::INTEGER,
ALTER COLUMN sales TYPE DECIMAL(10,2) USING sales::DECIMAL(10,2),
ALTER COLUMN orderdate TYPE DATE USING orderdate::DATE

--2 Check NULL/BLANK (‘’)  ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE.

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