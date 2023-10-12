-- Veri Setinin Notları:
-- • Müşterileri contactID temsil ediyor.
-- • Sepet sayısı için bookingID, yolcu sayısı için passengerID baz alınmalıdır. (Bir sepette birden fazla
-- yolcu(passengerID) olabilirken sadece bir contactID olabilir.)
-- • Üye olmayan müşterilerin, üyelik tarihi boş bırakılmıştır.
-- • paymentstatusler için iadeler başarılı veya başarısız sayılmamalıdır.


-- 1. Ekteki excel dosyasını kullanarak DB yapısı ve diagramını oluşturunuz.
-- 2. 
-- a. Müşteri bazında toplam satış adetlerini, tutarları ve ortalama bilet fiyatlarını

select * from booking limit 100
select * from payment limit 100
select * from passenger limit 100

select
	contactid,
	pas.name,
	count(b.id) as booking_count,
	sum(amount) as toplam_amount,
	round(avg(amount),2) avg_amount
from
	booking b
inner join payment py on b.id = py.bookingid
join passenger pas on b.id = pas.booking_id
group by b.id, pas.name,b.contactid


--Paymenstatus:
-- "İade"
-- "ÇekimHatalı"
-- "ÇekimBaşarılı"

select
	contactid,
	count(case when p.paymentstatus ='ÇekimBaşarılı' then b.id end) as succ_booking,
	count(b.id) total_booking_count,
	sum (case when p.paymentstatus = 'ÇekimBaşarılı' then p.amount end) toplam_succ_booking,
	avg(case when p.paymentstatus = 'ÇekimBaşarılı' then p.amount end) avg_succ_booking
from
	booking b
join payment p on b.id = p.bookingid
group by 1;



-- b. 2020 yılında aylık olarak; environment kırılımlarında toplam yolcu ve sepet sayılarını

select * from booking limit 100
select * from payment limit 100
select * from passenger limit 100

select
	to_char(b.bookingdate,'YYYY-MM') as booking_month,
	b.environment,
	count(distinct p.id) as passenger_count,
	count(distinct b.id) as booking_count,
	cardtype
from
	booking as b
left join passenger as p on b.id = p.booking_id
left join payment as py on b.id = py.bookingid
WHERE date_trunc('year',bookingdate)='2020-01-01 00:00:00'
GROUP BY 1,2,5;


-- c. Banka başarı oranlarını hesaplayarak, grafikte gösteriniz.

SELECT cardtype,
       count(CASE WHEN paymentstatus = 'ÇekimBaşarılı' THEN id END) AS succ_payment_count,
       count(id) AS payment_count,
       (count(CASE WHEN paymentstatus = 'ÇekimBaşarılı' THEN id END))*1.0 / (count(id))*1.0 as succ_rate
 FROM payment
 WHERE paymentstatus != 'İade'
 GROUP BY 1
 
 
 
with succ_pay as
(
SELECT cardtype,
       count(id) AS payment_count
  FROM payment
 WHERE paymentstatus = 'ÇekimBaşarılı'
 GROUP BY 1
),
all_pay as
(
SELECT cardtype,
       count(id) AS payment_count
  FROM payment
 WHERE paymentstatus != 'İade'
 GROUP BY 1
)
select s.cardtype,
       a.payment_count as all_payments,
       s.payment_count as succ_payments,
       round( (s.payment_count*1.0/a.payment_count*1.0) , 2 ) as succ_rate
from succ_pay as s
LEFT JOIN all_pay as a ON s.cardtype=a.cardtype
;

 

















