select * from category_name limit 10
select * from customers limit 10
select * from order_items limit 10
select * from order_payments limit 10
select * from order_reviews limit 10
select * from orders limit 10
select * from products limit 10
select * from seller limit 10



-- CASE 1 : Sipariş Analizi
-- Question 1 
-- Aylık olarak order dağılımını inceleyiniz. Tarih verisi için order_approved_at kullanılmalıdır.

select 
to_char(order_approved_at, 'MM') as tarih,
count (order_id) as toplam_siparis
from orders 
group by 1
order by 2 desc

-- Question 2
-- Aylık olarak order status kırılımında order sayılarını inceleyiniz. Sorgu sonucunda çıkan outputu excel ile görselleştiriniz. 
-- Dramatik bir düşüşün ya da yükselişin olduğu aylar var mı? Veriyi inceleyerek yorumlayınız.

select 
order_status as satis_durumlari,
to_char(order_approved_at, 'YYYY') as yıl,
to_char(order_approved_at, 'MM') as ay,
count (order_id) as toplam_satis_adedi
from orders
group by 1,2,3
order by 3

-- 1- Şirket 2016 yılında kurulmuş olabilir, ilk satış verisi 2016 nın eylül ayında görülüyor. 
-- 2016 Ekim ayında 320 adetlik bir sipariş geldikten sonra kasımda hiç sipariş gelmemiş ve aralıkta da 1 adet sipariş gelmiştir.
-- 2- 2017 verilerine bakıldığında kasım ayında ciddi bir artış olduğu görülmektedir. Bunun nedeni black friday olabilir. Sonrasında en yüksek sipariş olan
-- ay aralık olarak göze çarpıyor bunun nedeni de yılbaşı ve christmas bayramı olabilir.	
-- Mart ayında ciddi bir sipariş iptali alınmış, bunun sebepleri araştırılmalı. Oranlama yapılınca en çok iptalin 2017 mart ayında olduğu görülüyor.
-- 3- 2018 verisine bakıldığında ise 2017 yılına göre daha fazla sipariş alındığı görülüyor, 
-- fakat ilk 8 ayın verisi olduğu için kasım ayında artış olup olmadığı gözlemlenememektedir.
-- 2018 yılında da en çok sipariş iptali şubat ayında geldiği görülüyor, tamamlanan siparişlerde ise mart ayının öne çıktığı görülüyor.





-- Question 3
-- Ürün kategorisi kırılımında sipariş sayılarını inceleyiniz. Özel günlerde öne çıkan kategoriler nelerdir? 
-- Burada yılbaşı, sevgililer günü, christmas bayramı ve cadılar bayramını inceledim.

-- İlk olarak kategori kırılımında müşteriye teslim edilen sipariş adetlerini inceliyoruz. 
-- Görüldüğü gibi cama_mesa_banho kategorisi 10953 adetlik siparişle en çok sipariş gelen kategori olarak ilk sırada.

select 
product_category_name as category_adi,
count (o.order_id) as siparis_sayilari
from order_items oi
join products p on oi.product_id = p.product_id
join orders o on oi.order_id = o.order_id
where order_status = 'delivered'
group by 1
order by 2 desc

-- Veriyi incelediğimizde çıkan sonuca göre kategori bazında en çok sipariş 2018 in şubat ayında bilgisayar aksesuarları kategorisinde geldiğini görüyoruz.
-- En çok sipariş gelen ay ise 2017 nin kasım ayında cama_mesa_banho ve moveis_decoracao kategorilerinden olduğunu görüyoruz.

with cat_order as (
select 
to_char(order_approved_at, 'YYYY-MM') as tarih,
product_category_name as category_adi,
count (o.order_id) as siparis_sayilari
from order_items oi
join products p on oi.product_id = p.product_id
join orders o on oi.order_id = o.order_id
group by 1,2
order by 3 desc
)

-- Yılbaşı ve Christmas bayramının olduğu aralık ayı verilerini incelediğimizde ise en yüksek sipariş yine cama_mesa_banho kategorisinde olarak görünüyor

select * from cat_order where tarih = '2017-12'

-- Sevgililer gününde ki satışları inceleyecek olursak en çok siparişi 253 adet ile moveis_decoracao kategorisinden geldiği görülmektedir.

select * from cat_order where tarih = '2017-02'



-- Question 4 : 
--- Haftanın günleri(pazartesi, perşembe, ….) ve ay günleri (ayın 1’i,2’si gibi) bazında order sayılarını inceleyiniz. 
--- Yazdığınız sorgunun outputu ile excel’de bir görsel oluşturup yorumlayınız.

-- Siparişleri 3 yıllık verilerin günlerine göre incelediğimizde en yoğun siparişlerin salı günü geldiğini görüyoruz. En az sipariş ise pazartesi günleri gelmiş.

select 
to_char(order_approved_at, 'Day') as gun_ad,
count(order_id) as order_sayisi
from orders
where to_char(order_approved_at, 'Day') is not null
group by 1
order by 2 desc


-- Siparişleri 3 yıllık verilerin ayların günlerine göre incelediğimizde ise en yüksek siparişlerin ayın 31 inde geldiğini
-- en düşük sipariş adedinin ise ayın 24. ünde geldiğini görüyoruz.

select 
extract (day from order_approved_at) as gunler,
count (order_id) as siparis_sayisi
from orders
group by 1
order by 2

-- CASE 2 : Müşteri Analizi 
-- Question 1 : 
-- Hangi şehirlerdeki müşteriler daha çok alışveriş yapıyor? 
-- Sao Paulo şehri 15.540 sipariş ile en çok sipariş alınan şehir, Bunu Rio de Jenerio 6882 adet ile takip etmektedir.
-- Metropol olan şehirler en çok sipariş gelen şehirler olarak görülüyor.
-- Müşterinin şehrini en çok sipariş verdiği şehir olarak belirleyip analizi ona göre yapınız. 

select 
customer_city as musteri_sehri,
count(o.order_id) as siparis_adedi
from customers c
join orders o on c.customer_id = o.customer_id
group by 1
order by 2 desc

select 
customer_unique_id as musteri_id,
customer_city as musteri_sehri,
count(o.order_id) as siparis_adedi
from customers c
join orders o on c.customer_id = o.customer_id
group by 1,2
order by 3 desc






-- CASE 3: Satıcı Analizi
-- Question 1 : 
--- Siparişleri en hızlı şekilde müşterilere ulaştıran satıcılar kimlerdir? Top 5 getiriniz. 
--- Bu satıcıların order sayıları ile ürünlerindeki yorumlar ve puanlamaları inceleyiniz ve yorumlayınız.

select * from seller limit 10
select * from orders limit 10
select * from order_items limit 10
select * from order_reviews limit 10


--- Satıcıların kaçar adet sipariş aldığını sorguluyoruz. En çok satış yapan satıcı 2033 adet sipariş almıştır.

select
s.seller_id,
count(order_id) siparis_adedi
from order_items oi
join seller s on oi.seller_id = s.seller_id
group by 1
order by 2 desc

--- Satıcı bazlı satışlara ulaşabilmek için aşağıdaki gibi 3 tabloda joinleme işlemi yapıyoruz ve sadece müşterilere teslim edilen orderları listeliyoruz.
--- Şimdi hangi satıcının hangi siparişi kaç günde ilettiğini bulabiliriz.

--- En hızlı ve en çok satış yapan ilk 5 satıcıyı aşağıdaki gibi yazdırıyoruz.
--- En iyi 5 satıcılarımız yüksek sipariş sayılarına ve gelen siparişleri aynı gün içinde kargoya teslim etme sürelerine sahiptir.

select 
s.seller_id,
round (avg (order_delivered_carrier_date::date - order_approved_at::date),0) ortalama_kargoya_verme
from order_items oi
join seller s on oi.seller_id = s.seller_id
join orders o on oi.order_id = o.order_id
where order_delivered_carrier_date::date - order_approved_at::date > 0
group by 1
order by 2 
limit 5

--- Bu sorguda en iyi 5 satıcımızın siparişlerine aldığı ortalama puanları listeleyeceğiz.
--- En hızlı ve en çok sipariş alan satıcılarımızın müşterilerden aldıkları ortalama puanlar da aşağıdaki sorguda yazdırılmıştır.

--- Çıkan sonuca göre en çok satış yapan ve en kısa sürede kargoya teslim eden satıcı 
--- kargo veriliş ve satış konusunda iyi olsa da müşterileri tam anlamıyla memnun edememiş görünüyor. Müşteri puanı 3.9

with top_5_sellers as (
select 
s.seller_id,
count (o.order_id) siparis_adedi,
avg (order_delivered_carrier_date::date - order_approved_at::date) as teslim_suresi
from order_items oi
join seller s on oi.seller_id = s.seller_id
join orders o on oi.order_id = o.order_id
group by 1
order by 2 desc
limit 5
)

select 
top.seller_id,
siparis_adedi,
concat (round (teslim_suresi, 0 ),' ','saat') as ortalama_kargoya_verilis,
round (avg (review_score),1) as ortalama_musteri_puanı
from order_items oi
join top_5_sellers top on oi.seller_id = top.seller_id
join order_reviews o_r on oi.order_id = o_r.order_id
where review_score is not null
group by 1,2,3
order by 2 desc,4 desc


-- Question 2 : 
--- Hangi satıcılar daha fazla kategoriye ait ürün satışı yapmaktadır? 
--- Fazla kategoriye sahip satıcıların order sayıları da fazla mı? 

--- En fazla 27 adet kategoriye ürün satışı yapan satıcımız bulunmakta, kategori sayısı arttıkça order sayılarının da bir artık olmadığı görülüyor.
--- Aşağıdaki sorgunun sonucunda çıkana bakarsak 27 kategoride ürün satan satışçımız 363 adet sipariş alıyorken 23 kategoride ürün satan satıcımız 1499 adetlik sipariş alıyor.
--- Aşağıdaki sorguda ilk 10 satıcının kaç kategoride kaç adet ürün sattığını görüntülemekteyiz.

select * from order_items limit 10
select * from products limit 10
select * from seller limit 10

select 
s.seller_id,
count(distinct p.product_category_name) as satis_yapilan_kategori_sayisi,
count (oi.order_id) as toplam_siparis_adedi
from order_items oi
join products p on oi.product_id = p.product_id
join seller s on s.seller_id = oi.seller_id
group by 1
order by 2 desc
limit 10


-- CASE 4 : Payment Analizi
-- Question 1 : 
--- Ödeme yaparken taksit sayısı fazla olan kullanıcılar en çok hangi bölgede yaşamaktadır? Bu çıktıyı yorumlayınız.

---- Sonuca bakıldığında müşterilerin büyük çoğunluğu tek çekim ile alışveriş yapmaktadır. 
---- En yüksek taksit tutarı olan 24 ay sipariş sayısı oldukça düşüktür.

select * from order_payments limit 10
select * from customers limit 10
select * from orders limit 10

select 
customer_city as musteri_bolgesi,
payment_installments as taksit_tutari,
count (o.order_id) as siparis_adedi
from orders o 
left join customers c on o.customer_id = c.customer_id
left join order_payments op on o.order_id = op.order_id
group by 1,2
order by 2 desc


-- Question 2 : 
--- Ödeme tipine göre başarılı order sayısı ve toplam başarılı ödeme tutarını hesaplayınız. 
--- En çok kullanılan ödeme tipinden en az olana göre sıralayınız.


select 
payment_type as odeme_tipi,
count (o.order_id) as order_sayisi,
sum (payment_value::integer) as siparis_tutari
from order_payments o_p
join orders o on o_p.order_id = o.order_id
where o.order_status = 'delivered'
group by 1
order by 2 desc


-- Question 3 : 
--- Tek çekimde ve taksitle ödenen siparişlerin kategori bazlı analizini yapınız. En çok hangi kategorilerde taksitle ödeme kullanılmaktadır.

--- Bu soruyu analiz ettiğimizde müşterilerimizin genelde tek çekim ile alışveriş yaptığını tespit ettik. En yüksek taksit tutarı olan 24 ay taksitle
--- sadece 34 adet sipariş gelmiş ve bu siparişlerin 10 adedi pahalı bir kategori olabilecek sınıfta olan oturma odası mobilyaları kategorisindedir.
-- Tek çekim ile en çok sipariş edilen kategori ise esporte_lazer kategorisi olduğunu görüyoruz.

select * from order_items limit 10
select * from order_payments limit 10
select * from products limit 10

with taksit_kategori_siparis as (
select 
payment_installments as taksit_sayisi,
product_category_name as kategori_adi,
payment_type,
count (oi.order_id) as siparis_adedi
from order_items oi
join order_payments op on oi.order_id = op.order_id
join products p on oi.product_id = p.product_id
where payment_type = 'credit_card'
group by 1,2,3
order by 1,4 desc

)

select * from taksit_kategori_siparis where taksit_sayisi = 24

















