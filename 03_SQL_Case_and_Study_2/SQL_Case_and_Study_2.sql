-- 2021 Yılında kart tipi kredi kartı olan booking_id lerin sepet cinsiyet dağılımı nasıldır?

select
	gender,
	count (*) as kredi_karti_ile_alanların_Sayisi
from
	passenger
where
	booking_id in (
		select 
			booking_id 
		from 
			payment 
		where
			paymentdate = '2021-01-01' and paymentdate <= '2021-12-31' and cardtype = 'KrediKartı'
		)
group by
	gender



select * from passenger 


--kadın erkek sayısını bulmak için kadın erkeği gruplama ve sayısını bulma

select
	gender,
	count (*) as kredi_karti_ile_alanların_Sayisi
from
	passenger
group by
	gender



--temp tablo kullanımı

--soru = ortalama bıraktığı miktar 300 liradan fazla olan bookingID ler hangi platformdan geliyorlar ??

select count(DISTINCT(bookingid)) from payment

select * from payment

with ort_amount_bid as (
select 
	bookingid , round(avg(amount),0) as avg_amount
from
	payment
group by
	bookingid
having
	avg(amount) > 300
)
select 
	environment,
	count(*)
from
	booking as b
inner join
	ort_amount_bid as o on b.id = o.bookingid

group by
	environment

-- Sonuç = App ve Web ten gelen siparişler neredeyse eşit seviyede ilerliyor. 








