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
lower(to_char(s.sale_date, 'DAY')) as day_of_week ,
round(sum(quantity * price),0) as income
from sales s
left join employees e
on s.sales_person_id = e.employee_id
left join products p 
on p.product_id = s.product_id
group by concat(e.first_name,' ', e.last_name), to_char(s.sale_date, 'DAY'), to_char(s.sale_date,'id')
order by to_char(s.sale_date,'id'), seller
(Третий отчет содержит информацию о выручке по дням недели. Каждая запись содержит имя и фамилию продавца,
 день недели и суммарную выручку)
 
 select case
	when age between 16 and 25 then '16-25'
	when age between 26 and 40 then '26-40'
	else '40+'
end as age_category,
count (*) as age_count
from customers c
where age is not null
group by age_category
order by min(age)
(количество покупателей в разных возрастных группах: 16-25, 26-40 и 40+)

select to_char(sale_date, 'YYYY-MM') AS selling_month,
count(distinct(s.customer_id)) as total_customers,
round(sum(quantity * price),0) as income 
from sales s
left join employees e
on s.sales_person_id = e.employee_id
left join products p 
on p.product_id = s.product_id
group by to_char(sale_date, 'YYYY-MM')
order by selling_month ASC
( данные по количеству уникальных покупателей и выручке, которую они принесли)

WITH FirstPurchases AS (
    SELECT
        concat(c.first_name,' ', c.last_name) as customer,
        MIN(sale_date) AS first_purchase_date
        from sales s
left join employees e
on s.sales_person_id = e.employee_id
left join products p 
on p.product_id = s.product_id
left join customers c 
on c.customer_id = s.customer_id
    GROUP BY
        concat(c.first_name,' ', c.last_name)
),
FirstPurchaseDetails AS (
    SELECT
        concat(c.first_name,' ', c.last_name) as customer,
        s.sale_date,
        concat(e.first_name,' ', e.last_name) as seller
       from sales s
left join employees e
on s.sales_person_id = e.employee_id
left join products p 
on p.product_id = s.product_id
left join customers c 
on c.customer_id = s.customer_id  
    JOIN
        FirstPurchases fp
    ON
        concat(c.first_name,' ', c.last_name) = fp.customer
        AND s.sale_date = fp.first_purchase_date
    WHERE
        p.price = 0
)
SELECT
    customer,
    sale_date,
    seller
FROM
    FirstPurchaseDetails
ORDER BY
    customer;
(покупатели, первая покупка которых была в ходе проведения акций (акционные товары отпускали со стоимостью равной 0))
