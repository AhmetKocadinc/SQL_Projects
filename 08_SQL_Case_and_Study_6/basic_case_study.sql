select * from countries
select * from departments
select * from dependents
select * from employees
select * from jobs
select * from locations
select * from regions



--- Bu sorguda employee_id ye göre toplam maaşları sıralayıp employee_id ye ait isim ve soy isimleri de tabloda gösterdik.

select 
sum (salary),
employee_id,
first_name,
last_name
from employees
group by 2,3,4
order by 1 desc


-- En çok hangi departmanlara maaş ödendiği araştırılsın diye bir talep geldiğinde aşağıdaki sorgu hangi departmana ne kadar maaş veriliyor bizlere çıktısını veriyor.
----- Sonuç olarak 58 bin dolarla en çok maaş ödenen birim yönetici birimi olurken onu 57bin 700 dolar ile satış bölümü izliyor.

select 
department_name,
sum(salary)
from departments d
join employees e on e.department_id = d.department_id
group by 1
order by 2 desc

-- En Çok hangi bölgeden çalışanımız vardır ?
--- Sorgudan aldığımız sonuca göre en çok çalışan wahsingtondan aramıza katılım sağlamaktadır.

select 
count(e.employee_id),
state_province
from employees e
join departments d on e.department_id = d.department_id
join locations l on d.location_id = l.location_id
group by 2
order by 1 desc


--- Bu sorguda hangi işi kaç çalışanımız yapıyor o sonuca ulaşıyoruz. Çalışanlarımızdan 5 kişi yazılun işi ile ilgileniyor bir 5 kişi de hesaplarla ilgileniyor.

select 
count (e.employee_id),
job_title
from employees e
join jobs j on e.job_id = j.job_id
group by 2
order by 1 desc

-- En çok hangi iş dalına maaş ödeniyor ve en az hangi iş dalına maaş ödeniyor.?
---- En yüksek maaş 39 bin 600 dolar ile hesap yöneticileri alırken en düşük maaşı ise 2 bin 700 dolar ile stok memurları almaktadır.

select 
sum (salary),
job_title
from jobs j
join employees e on j.job_id = e.job_id
group by 2
order by 1 












