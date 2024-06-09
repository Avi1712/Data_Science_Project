-- drop database if exists pizzhut;

-- create database pizzhut;
use pizzhut;
select * 
from pizzas;

select * 
from pizza_types;

select * 
from orders;

select * 
from order_details;

desc orders;

-- change  date and time column  datatype from text to date and time type
alter table orders
modify column date date;

alter table orders
modify column time time;

desc orders;



-- 1 Retrieve the total number of orders placed.
select count(order_id) as total_orders 
from orders;


-- 2 the total revenue generated from pizza sales.

select round(sum(p.price * o.quantity),2) as revenue
from pizzas as p
join order_details as o
on p.pizza_id = o.pizza_id;


-- 3 Identify the highest-priced pizza.

select pt.name as pizza_name , p.price as highest_price
from pizzas as p
join pizza_types as pt
on p.pizza_type_id=pt.pizza_type_id
order by  highest_price desc limit 1;

-- 4 Identify the most common pizza size ordered. 

select p.size   as size, count(o.order_details_id) as order_count
from pizzas as p
join order_details as o
on p.pizza_id=o.pizza_id
group by size order by order_count desc limit 1;


-- 5 List the top 5 most ordered pizza types along with their quantities.

select  pt.name as pizza_name , sum( o.quantity ) as total_quantity
from pizza_types as pt
join pizzas as p
on pt.pizza_type_id=p.pizza_type_id
join  order_details as o
on p.pizza_id=o.pizza_id
group by pizza_name 
order by total_quantity desc limit 5;

-- 6 Join the necessary tables to find the total quantity of each pizza category ordered.

select  pt.category as pizza_category , sum( o.quantity ) as total_quantity
from pizza_types as pt
join pizzas as p
on pt.pizza_type_id=p.pizza_type_id
join  order_details as o
on p.pizza_id=o.pizza_id 
group by pizza_category
order by total_quantity desc;

-- 7 Determine the distribution of orders by hour of the day.

select hour(time) as hour, count(order_id) as order_count 
from orders
group by hour 
order by order_count desc;

-- 8 Join relevant tables to find the category-wise distribution of pizzas.

select p.category as category , count(pizza_type_id) as pizza_type_count 
from  pizza_types  as p 
group by category
order by pizza_type_count desc; 

-- 9 Group the orders by date and calculate the average number of pizzas ordered per day.

select round(avg(quantity) ) as avg_no_pizzas_ordered from
(select  o.date as date , sum(ot.quantity) as quantity
from orders as o 
join order_details as ot
on o.order_id=ot.order_id
group by date) as order_quantity;


-- 10 Determine the top 3 most ordered pizza types based on revenue.

select  pt.name as pizza_name , sum(p.price*o.quantity) as revenue 
from pizzas as p
join order_details as o
on p.pizza_id = o.pizza_id
join pizza_types as pt
on pt.pizza_type_id = p.pizza_type_id 
group by pizza_name 
order by revenue desc limit 3;


-- 11 Calculate the percentage contribution of each pizza type to total revenue.

select pt.category as category, Round(sum(p.price*o.quantity ) / (select Round(sum( p.price*o.quantity ) ,2)as total_sales
from pizzas as p
join order_details as o
on p.pizza_id = o.pizza_id) * 100,2)
as revenue
from pizza_types as pt
join pizzas as p 
on 
p.pizza_type_id=pt.pizza_type_id
join order_details as o
on
p.pizza_id = o.pizza_id
group by category;

-- 12 Analyze the cumulative revenue generated over time.


select date , sum(revenue) over (order by date) as cum_revenue
from
(select  o.date as date ,sum(p.price*od.quantity) as revenue 
from pizzas as p
join order_details as od
on p.pizza_id=od.pizza_id
join orders as o
on o.order_id=od.order_id
group by date) as total_sales;

-- 13 rank of pizza type as per revenue 

select category, pizza_name , revenue , rank() over (partition by category  order by  revenue desc) as rn
from
(select pt.category as category , pt.name as pizza_name , sum(p.price*o.quantity) as revenue 
from pizzas as p
join order_details as o
on p.pizza_id = o.pizza_id
join pizza_types as pt
on pt.pizza_type_id = p.pizza_type_id 
group by pizza_name ,category
order by revenue desc) as pizza_sales;









