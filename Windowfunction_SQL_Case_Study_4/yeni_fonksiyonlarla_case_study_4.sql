select * from booking limit 100
select * from passenger limit 100
select * from payment limit 100


-- LAG fonksiyonu ile tarihleri bir önceki rezervasyon tarihine göre sıraladık.
-- CASE : Her müşterinin mevcut rezervasyon tarihi ile iki sonraki rezervasyon tarihini getiriniz.

select
booking.contactid,
bookingdate,
LAG(bookingdate) over (partition by booking.contactid order by bookingdate ) as prev_booking_date
from
	booking

-- LEAD fonksiyonu ile tarihleri bir önceki rezervasyon tarihine göre sıraladık.
-- CASE : Her müşterinin mevcut rezervasyon tarihi ile iki sonraki rezervasyon tarihini getiriniz.

select 
bookingdate,
next_booking_date,
AGE(bookingdate,next_booking_date)
FROM
(select
contactid,
bookingdate,
LEAD(bookingdate,3) over (partition by contactid order by bookingdate ) as next_booking_date
from
	booking) A
	
-- SONUÇ : Çıkan sonuca göre müşterilerden 1 ay da bir alışveri yapanda mevcut 7 ay alışveriş yapmayanda var, 1 yıl uğramayan var.



--- Gün kırılımında, ilgili tarihte en yüksek başarılı ödeme yapulan rezervasyon id si ile bu rezervasyonun tüm yolcu bilgilerini getirin.

with max_amount as (
select
bookingdate::date as booking_date,
b.id,
b.contactid,
pay.amount,
ROW_NUMBER() OVER (PARTITION BY bookingdate::date ORDER BY pay.amount DESC ) AS R_N
from
	booking as b
join payment pay on b.id = pay.bookingid
	where pay.paymentstatus = 'ÇekimBaşarılı'
)

select
booking_date,
amount,
gender,
name
from max_amount m
join passenger p on m.id = p.booking_id
where R_N = 1 


-- her müşterinin en fazla ödeme yaptığı company' i müşterinin companysi olarak belirleyiniz.

with contracts_with_company as (
select	
contactid,
b.company,
count(p.id) payment_count,
sum(amount) payment_amount
from
	booking b
join payment p on b.id = p.bookingid
where p.paymentstatus='ÇekimBaşarılı'
group by 1,2
),
ROW_NUMB as (
select 
contactid,
company,
payment_count,
payment_amount,
ROW_NUMBER () OVER (PARTITION BY contactid ORDER BY payment_count DESC,payment_amount DESC ) AS RN
from
	contracts_with_company
),

-- CASE de istendiği üzere sadece contactid ve contactid ye ait company bilgisini içeren sorgudur.
contact_company as (
SELECT 
contactid,
company
FROM ROW_NUMB WHERE RN = 1
),

-- Bu kısımda contactid lerin companylere göre yaşını bulmuş oluyoruz.

all_ages as (
select 
c.contactid,
c.company,
EXTRACT (YEAR FROM AGE (current_date,dateofbirth)) passenger_age
from contact_company c
join booking b on c.contactid = b.contactid
join passenger p on b.id = p.booking_id
	)
	
-- bu kısımda yaşları segmentlere ayırıyoruz ve hangi company de hangi yaş segmentinin daha yoğun olduğunu bulabiliriz. 
--ek olarak ekrana contactid ve müşterinin yaşını da yazarak daha efektif hale getirebiliriz.
-- veriyi companyisine göre yaş aralığı segmentlerine ayırıp hangi yaş aralığında hangi companyi de kaç kişi olduğunu hesapladık.
select 
all_ages.company,
	case when passenger_age >= 22 and passenger_age < 32 then '22-32'
		when passenger_age >= 32 and passenger_age < 43 then '32-34'
		when passenger_age >= 32 and passenger_age < 43 then '32-34'
		when passenger_age >= 43 and passenger_age < 53 then '43-53'
		when passenger_age >= 53 and passenger_age < 63 then '53-63'
		when passenger_age >= 63 and passenger_age < 73 then '63-73'
		when passenger_age >= 73 and passenger_age < 82 then '73-82'
		else '83+' end as age_segment,
		count(*) as toplam_kisi_sayisi
from all_ages	
group by all_ages.company, age_segment


-- CASE de istenen bilgileri daha açıklayıcı şekilde müşteri adı cinsiyeti ve doğum tarihi olarak listeledik, bu sayede daha açıklayıcı bir rapor sunabiliriz.

--SELECT 
--contactid,
--company,
--id,
--gender,
--name,
--dateofbirth
--FROM ROW_NUMB rw
--join passenger p on rw.contactid = p.id
--WHERE RN = 1

-- Her company nin yolcularının yaşı kırılımında yolcu sayısını getirin. Her müşterinin en fazla ödeme yaptığı company i o müşterinin companysi olarak belirleyin.

-- yaş hesaplamak için kullanılan sorgu
-- müşterilerin yaşı hem standart hemde extract ve age fonksiyonu kullanılarak hesaplanmıştır












