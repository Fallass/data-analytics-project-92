select count(customer_id) as customers_count 
from customers c 
(считает общее количество покупателей из таблицы customers)


select concat(e.first_name,' ', e.last_name) as seller,
count(s.sales_id) as operations,
round(sum(quantity * price),0) as income
from sales s
left join employees e
on s.sales_person_id = e.employee_id
left join products p 
on p.product_id = s.product_id 
group by concat(e.first_name,' ', e.last_name)
order by  income desc
limit 10
(Таблица состоит из трех колонок - данных о продавце,
 суммарной выручке с проданных товаров и количестве проведенных сделок,
  и отсортирована по убыванию выручки)


with tab as (
select concat(e.first_name,' ', e.last_name) as seller, round(avg(quantity * price),0) as avg_income
from sales s
left join employees e
on s.sales_person_id = e.employee_id
left join products p 
on p.product_id = s.product_id
group by concat(e.first_name,' ', e.last_name)
)
select seller, avg_income as average_income 
from tab
where avg_income < (select round(avg(quantity * price),0)
from sales s
left join employees e
on s.sales_person_id = e.employee_id
left join products p 
on p.product_id = s.product_id)
order by average_income
(продавцы, чья средняя выручка за сделку меньше средней выручки за сделку по всем продавцам)

select concat(e.first_name,' ', e.last_name) as seller,
to_char(s.sale_date, 'DAY') as day_of_week ,
round(sum(quantity * price),0) as income
from sales s
left join employees e
on s.sales_person_id = e.employee_id
left join products p 
on p.product_id = s.product_id
group by concat(e.first_name,' ', e.last_name), to_char(s.sale_date, 'DAY')
order by to_char(s.sale_date, 'DAY'), seller
(Третий отчет содержит информацию о выручке по дням недели. Каждая запись содержит имя и фамилию продавца,
 день недели и суммарную выручку)   