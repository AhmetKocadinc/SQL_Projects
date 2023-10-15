select * from booking limit 100
select * from passenger limit 100
select * from payment limit 100

-- gün kırılımında, ilgili tarihte en çok başarılı ödeme yapılan rezervasyon id si ile bu rezervasyonun tüm yolcu bilgilerini getirin.
-- ilk olarak en yüksek başarılı ödeme yapan ID yi buluyoruz.
with max_amount as (
select 
bookingdate::date booking_date,
b.id,
b.contactid,
py.amount,
ROW_NUMBER () over (partition by bookingdate::date order by py.amount desc ) as rn
from
	booking as b
join payment as py on b.id = py.bookingid
	where paymentstatus = 'ÇekimBaşarılı'

)

-- sorguda çıkan sonucu direkt olarak ilgili birime iletmek kafa karışıklığı yaratacağı için sadece bize iletilen talepte yer alan kısımları tablodan çekerek çıktısını almamız gerekmektedir.


select
booking_date,
amount,
gender,
name,
dateofbirth
from 
	max_amount m
join passenger p on m.id = p.booking_id
where rn=1

	






