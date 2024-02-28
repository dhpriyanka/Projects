1)My partner and I want to come by each of stores in person and meet the manages. Please send manger’s names at each store with the full address of each property street address, district, city and country please

select s.first_name as manager_first_name,s.last_name as manager_last_name,
a.address,a.district,c.city,co.country
from store st left join staff s on st.manager_staff_id=s.staff_id
left join address a on st.address_id=a.address_id
left join city c on a.city_id=c.city_id
left join country co on c.country_id=co.country_id;


2)To get a better understanding of all the inventory that would come along with the business.
Please pull together a list of each inventory item you have stocked, including  the store_id number,
The inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost.

select i.store_id, i.inventory_id,f.title,f.rating,f.rental_rate, f.replacement_cost 
from inventory i left join film f
on i.film_id=f.film_id;
 

 

3)From the same list of films you just pulled, please roll that data up and provide a summary level overview of your inventory. We would like to know how many inventory items you have with each rating at each store

 select i.store_id,f.rating,count(inventory_id) as inventory_items
from inventory i left join film f on i.film_id=f.film_id
group by i.store_id,f.rating;

 

4)Similarly, we want to understand how diversified the inventory is in terms of replacement cost.
We want to see how big of a hit it would be if a certain category of film became unpopular at a certain store. We would like to see the number of films as well as the average replacement cost  and total replacement cost sliced by store and film category

 select store_id,c.name as category, count(i.inventory_id) as films,
avg(f.replacement_cost) as avg_replacement_cost,
sum(f.replacement_cost) as total_replacement_cost
from inventory i left join film f
on i.film_id=f.film_id
left join film_category fc on
f.film_id=fc.film_id left join category c on c.category_id=fc.category_id
group by store_id,c.name;

5)We want to make sure you folks have a good handle on who your customers are. Please provide a list of all customer names which store they go to, whether or not they are currently active, and their full addresses, street address,city and country

select cu.first_name,cu.last_name,cu.store_id,cu.active,a.address,c.city, co.country
from customer cu
left join address a on cu.address_id=a.address_id
left join city c on a.city_id=c.city_id
left join country co on c.country_id=co.country_id; 

 

6)We would like to understand how much your customers are spending with you, and also to know who your most valuable customers are. Please pull together a list of customer names, their total lifetime rentals, and the sum of all payments you have collected from them. It would be great to see this ordered on total lifetime value, with the most valuable customers at the top of the list .

 select cu.first_name,cu.last_name,count(r.rental_id) as total_rentals, sum(p.amount) as total_payemnt_amount
from customer cu left join rental r on cu.customer_id=r.customer_id
left join payment p on r.rental_id=p.rental_id
group by cu.first_name,cu.last_name;


 

7)My partner I would like to get to know your board of advisors and any current investors. Could you please provide a list of advisor and investor name in one table?
Could you please note whether they are an investor or an advisor , and for the investors , it would be good to include which company they work with

 Select 'investor' as type, first_name, last_name, company_name from investor
union
select 'advisor' as type, first_name, last_name, null from advisor

 

8)We are interested in how well you have covered the most awarded actors. Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions,. Finally how about actors with just one ward

