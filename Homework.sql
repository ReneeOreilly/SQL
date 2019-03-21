use sakila;
#1a
select first_name, last_name from actor;

#1b
select concat(first_name, " ", last_name) as 'Actor Name' from actor;

#2a
select actor_id, first_name, last_name from actor
where first_name = "Joe";

#2b
select actor_id, first_name, last_name from actor
where last_name like "%GEN%";

#2c
select actor_id, first_name, last_name from actor
where last_name like "%LI%"
Order by last_name ASC, first_name ASC;

#2d
select country_id, country from country
where country IN("Afghanistan", "Bangladesh", "China");

#3a
Alter Table actor
Add column description blob after last_update; 

#3b
Alter Table actor
drop column description;

#4a
select last_name, Count(*) as count from actor
group by last_name;

#4b
select last_name,Count(*) as count from actor
group by last_name
Having count>=2;

#4c
SET SQL_SAFE_UPDATES = 0;
update actor
set first_name = "Harpo"
where first_name = "Groucho"  and last_name = "Williams";

#4d
update actor
set first_name = "Groucho"
where first_name = "Harpo";

#5
show create table address;

#6a
select staff.first_name, staff.last_name, address.address
FROM staff JOIN address using(address_id);

#6b
select staff.first_name, staff.last_name, Sum(payment.amount) as 'total payment'
from payment join staff where payment.payment_date between "2005-08-01" and "2005-8-31" 
and payment.staff_id = staff.staff_id
group by payment.staff_id;

#6c
select film.title, Count(actor_id) as '# of Actors'
from film inner join film_actor  using(film_id)
group by film.film_id; 

#6d
select film.title, Count(inventory_id) as 'inventory count'
from inventory join film using(film_id)
where film.title = "Hunchback Impossible";

#6e
select customer.first_name, customer.last_name, Sum(payment.amount) as total_payment
from payment join customer where customer.customer_id = payment.customer_id
group by payment.customer_id
Order by last_name ASC;

#7a
select * from film
where language_id IN
	(
		select language_id
		from language
		where name = "English"
		)
and title LIKE "K%" or title LIKE "Q%";

#7b
select first_name, last_name from actor
where actor_id IN
(   select actor_id from film_actor
	where film_id IN
	(
		select film_id
		from film
		where title = "Alone Trip"
    ));
    
#7c
select first_name, last_name, email from customer
Join address USING (address_id)
Join city USING (city_id)
Join country USING (country_id)
where country = "Canada";

#7d
select title from film
where film_id IN
	(select film_id from film_category
    where category_id IN
		(select category_id from category
        where name = "family"));
        
#7e
select title, Count(title) as count from film
Join inventory USING (film_id)
Join rental USING (inventory_id)
group by film_id
order by count DESC;

#7f
select store_id, concat('$', format(sum(payment.amount),2)) as revenue from store
Join customer USING (store_id)
Join payment USING (customer_id) 
group by store_id;

#7g
select store_id, city.city, country.country from store
join address USING (address_id)
join city  USING (city_id)
join country USING (country_id);

#7h
select name, concat('$', format(sum(payment.amount),2)) as revenue from category
join film_category USING (category_id)
join inventory USING(film_id)
join rental USING (inventory_id)
join payment USING (rental_id)
group by name
order by revenue DESC
LIMIT 5;

#8a
create view top5revenue as
select name, concat('$', format(sum(payment.amount),2)) as revenue from category
join film_category USING (category_id)
join inventory USING(film_id)
join rental USING (inventory_id)
join payment USING (rental_id)
group by name
order by revenue DESC
LIMIT 5;

#8b
select * from top5revenue;

#8c
drop view top5revenue;