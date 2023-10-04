@@ -0,0 +1,81 @@
select * from booking limit 10
select * from passenger limit 10
select * from payment limit 10


-- company e göre üye ve üye olmayan contactid sayımız nedir ?

-- burada çok fazla değer olduğu için üye olan ve olmayanları bulmak zor olacağı için bu sütunu eliyoruz
select
	distinct userid
from
	booking

-- membersales sütununa baktığımızda üyelikli ve üyeliksiz olarak 2 çıktı verdiğini görüyoruz. Case cevabına ulaşabilmek adına bu sütunu kullanabiliriz.
select
	distinct membersales
from
	booking
	
-- Şimdi ise case deki talebe istinaden company e göre üyelerin, üyelikli ve üyeliksiz olanları gruplayacağız.

-- 1. yol yapılacak en sade örnektir. 2. yolda daha karmaşık ve teknik olarak "case/when kullanarak" yapacağız.

-- 1. yol

select
	company,
	membersales,
	count(distinct userid)
from
	booking
group by
	Company,
	membersales
	
-- 2. yol

-- bu yolda case when ile üyelikli ve üyeliksiz müşterilerin toplamına bakarken bir farklılık olduğu tespit edildi ve bu farklılıktan müşterilerin hem üyelikli olarak hemde üyeliksiz olarak sipariş verebildiği bir durum tespit edildi.

select distinct membersales from booking

select
	count ( distinct case when membersales = 'Üyeliksiz' then contactid end) as üyeliksizmusteri,
	count ( distinct case when membersales = 'üyelikli' then contactid end) as üyeliksizmusteri,
	count (distinct contactid) as toplammusteri
from
	booking
group by
	company
	

-- çıkan sonucu rapor edebilmek adına yeni bir case yazıyoruz.

-- hem üye hem üye olmadan işlem yapan contactid ler nelerdir?

select
	contactid
from
	booking
group by
	contactid
having
	count (distinct membersales) > 1

-- bu durumda bunu bizden teyit etmek istenecektir, teyit amaçlı aşağıdaki sorguyu 3 farklı müşteri üzerinden kontrol sağlıyoruz ve uygunluğunu teyit ediyoruz.

-- ilk müşteriyi 17836 nolu id den kontrol ediyoruz. Çıkan sonuçta görüldüğü gibi ilk kontrol ettiğimiz müşteri 2 kez üyeliksiz ve 1 kez de üye olarak işlem yapmış.

-- ikinci müşteriyi 125524 nolu id den kontrol ediyoruz. Çıkan sonuçta görüldüğü gibi 2. kontrol ettiğimiz müşteri ise 6 kez işlem yapmış ve 2 kez üyelikli, 4 kez üyelikli işlem yaptığı görülüyor. üye olduktan sonra da bir kez üyeliksiz işlemi mevcut

-- ikinci müşteriyi 378292 nolu id den kontrol ediyoruz. Çıkan sonuçta görüldüğü gibi 3. kontrol ettiğimiz müşteri de 6 kez işlem yapmış ve 1 kez üyelikli, 5 kez üyelikli işlem yaptığı görülüyor. çıkan sonuca göre ilk işlemini üyeliksiz yaptıktan sonra üye olmuş sonraki işlemlerini üye olarak uygulamıştır.

select
	*
from
	booking
where contactid = 17836

select
	*
from
	booking
where contactid = 125524

select
	*
from
	booking
where contactid = 378292


