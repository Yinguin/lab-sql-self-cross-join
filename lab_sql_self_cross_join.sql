USE sakila;

# 1. Get all pairs of actors that worked together.
SELECT * FROM film_actor LIMIT 5;

SELECT DISTINCT a1.actor_id, a2.actor_id
FROM film_actor a1
JOIN film_actor a2 
ON a1.film_id = a2.film_id AND a1.actor_id <> a2.actor_id
ORDER BY a1.actor_id, a2.actor_id;

# 2. Get all pairs of customers that have rented the same film more than 3 times.
SELECT * FROM rental LIMIT 5;
SELECT * FROM inventory LIMIT 5;

WITH rental_inventory AS (
  SELECT r.rental_id, r.customer_id, i.film_id
  FROM rental r
  JOIN inventory i ON r.inventory_id = i.inventory_id
)
SELECT ri1.customer_id AS customer1_id, ri2.customer_id AS customer2_id, ri1.film_id, count(distinct ri1.rental_id) as total_count
FROM rental_inventory ri1
JOIN rental_inventory ri2
ON ri1.film_id = ri2.film_id AND ri1.rental_id <> ri2.rental_id
GROUP BY ri1.customer_id, ri2.customer_id, ri1.film_id
HAVING COUNT(DISTINCT ri1.rental_id) > 2 AND ri1.customer_id < ri2.customer_id
ORDER BY ri1.customer_id, ri2.customer_id;

SELECT r1.customer_id AS customer1_id, r2.customer_id AS customer2_id
FROM rental r1
JOIN inventory i1 ON r1.inventory_id = i1.inventory_id
JOIN rental r2
JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
ON i1.film_id = i2.film_id AND r1.rental_id <> r2.rental_id
WHERE r1.customer_id < r2.customer_id
GROUP BY r1.customer_id, r2.customer_id, i1.film_id
HAVING COUNT(DISTINCT r1.rental_id) > 3
ORDER BY r1.customer_id, r2.customer_id;

# 3. Get all possible pairs of actors and films.
SELECT title, first_name, last_name
FROM film_actor
JOIN actor USING (actor_id)
JOIN film USING (film_id)
ORDER BY title, first_name, last_name;