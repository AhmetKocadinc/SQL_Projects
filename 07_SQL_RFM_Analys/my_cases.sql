-- tablomuzu oluşturuyoruz

create table ecommerce 
(
	InvoiceNo varchar,
	StockCode varchar,
	Description varchar,
	Quantity integer,
	InvoiceDate varchar,
	UnitPrice double precision,
	CustomerID integer,
	Country varchar
)

-- invoicedate tarihini bir türlü import edemediğimiz için ilk olarak ilgili kolonu varchar olarak aldık sonra aşağıdaki gibi kolonun veri tipini güncelledik

Update ecommerce
	SET invoicedate = TO_TIMESTAMP(invoicedate, 'MM.DD.YYYY HH24:MI')
	
ALTER TABLE ecommerce
ALTER COLUMN invoicedate TYPE timestamp USING invoicedate::timestamp;

select 
	customerid,
	quantity,
	invoicedate::date,
	unitprice,
	country,
	(quantity*unitprice)::numeric(10,0) as toplam_alisveris_tutari
from ecommerce
where customerid is not null
order by quantity desc
limit 100

-- Müşterilerin son alışveriş yaptığı tarihleri getirelim

select
customerid,
max(invoicedate)::date
from ecommerce
where customerid is not null
group by customerid


-- ilk olarak recency değerini hesaplayalım

with last_invoice as (
select 
customerid,
max(invoicedate)::date last_invoice_date
from ecommerce
where customerid is not null
group by customerid
)
select
customerid,
(select max(invoicedate) from ecommerce) - last_invoice_date as recency
from last_invoice


-- şimdi frequency değerini hesaplıyoruz

select
customerid,
count(invoiceno) frequency
from ecommerce
where customerid is not null
group by customerid


-- monetary değeri hesaplıyoruz

select
customerid,
sum(unitprice)::numeric(5,0) monetary
from ecommerce
where customerid is not null
group by customerid


-- RFM değerleri toplamı

with recency as 
(
with last_invoice as (
select 
customerid,
max(invoicedate)::date last_invoice_date
from ecommerce
where customerid is not null
group by customerid
)
select
customerid,
(select max(invoicedate)::date from ecommerce) - last_invoice_date as recency
from last_invoice
),

frequency as 
(
select
customerid,
count(invoiceno) frequency
from ecommerce
where customerid is not null
group by customerid
),

monetary as 
(
select
customerid,
sum(unitprice)::numeric(5,0) monetary
from ecommerce
where customerid is not null
group by customerid
),

total_rfm_score as (
SELECT
    r.customerid,
    r.recency,
    f.frequency,
    m.monetary,
    CASE
		WHEN r.recency <= 1 AND f.frequency >= 8 AND m.monetary >= 1500 THEN 8
		WHEN r.recency <= 10 AND f.frequency >= 7 AND m.monetary >= 1000 THEN 7
		WHEN r.recency <= 20 AND f.frequency >= 6 AND m.monetary >= 750 THEN 6
        WHEN r.recency <= 30 AND f.frequency >= 5 AND m.monetary >= 500 THEN 5
        WHEN r.recency <= 60 AND f.frequency >= 3 AND m.monetary >= 300 THEN 4
        WHEN r.recency <= 90 AND f.frequency >= 2 AND m.monetary >= 150 THEN 3
        WHEN r.recency <= 180 AND f.frequency >= 1 AND m.monetary >= 50 THEN 2
        ELSE 1
    END AS rfm_score
from recency r
join frequency f on r.customerid = f.customerid
join monetary m on r.customerid = m.customerid
),

rfm_scores as (
select 
    customerid,
    recency,
    frequency,
    monetary,
	rfm_score
	--ROW_NUMBER () over (partition by rfm_score order by customerid desc) as rn
from total_rfm_score as trfm
order by customerid
),


segments as (
SELECT
    customerid,
    recency,
    frequency,
    monetary,
	rfm_score,
    CASE
		WHEN recency >= 8 AND frequency >= 8 AND monetary >= 8 THEN 'Şampiyonlar'
		WHEN recency >= 7 AND frequency >= 7 AND monetary >= 7 THEN 'Sadık Müşteriler'
		WHEN recency >= 6 AND frequency >= 6 AND monetary >= 6 THEN 'Potansiyel Sadık Müşteriler'
		WHEN recency >= 5 AND frequency >= 5 AND monetary >= 5 THEN 'Risk Altındaki Müşteriler'
        WHEN recency >= 4 AND frequency >= 4 AND monetary >= 4 THEN 'Uykuda Olan Müşteriler'
        WHEN recency >= 3 AND frequency >= 3 AND monetary >= 3 THEN 'Yeni Müşteriler'
        ELSE 'Kaybedilen Müşteriler'
    END AS segment
FROM rfm_scores
)

select 
	segment,
	count(customerid) toplam_musteri_segmenti_kırılımları
from segments
group by 1
	
	
	


