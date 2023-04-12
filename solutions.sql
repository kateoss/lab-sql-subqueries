USE sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT f.film_id, f.title, count(i.inventory_id) FROM inventory as i
JOIN film f 
ON i.film_id = f.film_id
WHERE f.title LIKE "%Hunchback Impossible%"
GROUP by f.film_id;

-- 2. List all films whose length is longer than the average of all the films

SELECT title, length FROM film
WHERE length > (SELECT avg(length)
                FROM film)
ORDER BY length desc;

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name FROM actor 
WHERE actor_id IN (
SELECT actor_id FROM film_actor
WHERE film_id =
(SELECT film_id FROM film
WHERE title = "Alone Trip")
);

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

SELECT title FROM film 
WHERE film_id IN (
SELECT film_id FROM film_category
WHERE category_id =
(SELECT category_id FROM category
WHERE name = "Family")
);

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, 
-- you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant 
-- information.

-- using a subquery
SELECT first_name, last_name, email FROM customer
WHERE address_id IN (
SELECT address_id FROM address
WHERE city_id IN (
SELECT city_id FROM city
WHERE country_id IN (
SELECT country_id FROM country
WHERE country = "Canada")
));

-- using a join
SELECT cu.first_name, cu.last_name, cu.email FROM customer as cu
JOIN address as a
ON cu.address_id = a.address_id
JOIN city as ci
ON a.city_id = ci.city_id
JOIN country as co
ON ci.country_id = co.country_id
WHERE country = "Canada"
GROUP BY cu.first_name, cu.last_name, cu.email;

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the 
-- most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different 
-- films that he/she starred.

SELECT title from film
WHERE film_id IN (
SELECT film_id FROM film_actor
WHERE actor_id = (
SELECT actor_id FROM (
SELECT actor_id, count(film_id) FROM film_actor
GROUP BY actor_id
ORDER BY count(film_id) DESC
LIMIT 1) as sub
));

-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable 
-- customer ie the customer that has made the largest sum of payments

SELECT title FROM film
WHERE film_id IN (
SELECT film_id FROM inventory
WHERE inventory_id IN (
SELECT inventory_id FROM rental
WHERE customer_id = (
SELECT customer_id FROM (
SELECT customer_id, sum(amount) FROM payment
GROUP BY customer_id
ORDER BY sum(amount) DESC
LIMIT 1) as sub
)));


-- 8. Customers who spent more than the average payments.

SELECT customer_id, avg(amount) as Avg_per_Cust FROM payment
GROUP BY customer_id
HAVING Avg_per_Cust > (SELECT avg(amount) FROM payment)
ORDER BY avg(amount);