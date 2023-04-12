-- Inner Join on the Actor and Film_Actor Table
SELECT actor.actor_id, first_name,last_name,film_id
FROM film_actor
INNER JOIN actor
ON actor.actor_id = film_actor.actor_id;

-- Left Join on the Actor and Film_Actor Table
SELECT actor.actor_id, first_name,last_name,film_id
FROM film_actor
LEFT JOIN actor
ON actor.actor_id = film_actor.actor_id
WHERE first_name IS NULL AND last_name IS NULL;

-- Join that will produce info about a customer
-- From the country of Angola
SELECT customer.first_name,customer.last_name,customer.email,country
FROM customer
FULL JOIN address
ON customer.address_id = address.address_id
FULL JOIN city
ON address.city_id = city.city_id
FULL JOIN country
ON city.country_id = country.country_id
WHERE country = 'Angola';



-- SubQuery Examples

-- Two queries split apart (which will become a subquery later)

-- Find a customer_id that has a amount greater
-- Than 175 in total payments
SELECT customer_id
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 175
ORDER BY SUM(amount) DESC;

-- Find ALL customer info
SELECT *
FROM customer;

-- Subquery to find the 6 customers that have
-- A total amount of payments greater than 175

SELECT store_id,first_name,last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) > 175
	ORDER BY SUM(amount) DESC
)
GROUP BY store_id,first_name,last_name;

SELECT store_id,first_name,last_name,address
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id
WHERE country = 'Angola' AND customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) > 175
	ORDER BY SUM(amount) DESC
);

-- Basic Subquery
SELECT *
FROM customer
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) > 175
	ORDER BY SUM(amount) DESC
);

-- Basic Subquery 
-- Find all films with a language of 'English'

SELECT *
FROM film
WHERE language_id IN (
	SELECT language_id
	FROM language
	WHERE name = 'English'
);



--Inner JOIN on the actor and film_Actor table
SELECT actor.actor_id, first_name, last_name, film_id
FROM film_actor
INNER JOIN actor
ON actor.actor_id = film_actor.actor_id;

-- INNER JOIN on the actor, film_actor, and film table to see which actors are in what film
SELECT first_name, last_name, title --selecting columns from tables
FROM actor --table A
INNER JOIN film_actor --table B
ON actor.actor_id = film_actor.actor_id
INNER JOIN film --table c?
ON film_actor.film_id = film.film_id;

-- Join that will produce info about a customer
-- From the country of Angola
-- First Name, Last Name, Email, Country
SELECT first_name, last_name, email, country
FROM customer
INNER JOIN country
ON customer.customer_id = country.country_id
WHERE country = 'Angola';


SELECT first_name, last_name, email, country, city, address
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id
WHERE country = 'Angola';

SELECT *
FROM city;

SELECT *
FROM address;

--Find a customer_id that has a payment amount greater than 175
SELECT customer_id, sUM(amount)
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 175
ORDER BY SUM(amount) DESC;

SELECT store_id, first_name, last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) > 175
	ORDER BY SUM(amount) DESC
);

SELECT store_id, first_name, last_name, address
FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id
WHERE city = 'United States' AND customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) > 175
	ORDER BY SUM(amount) DESC
);

-- Subquery to find all films in english
--using the film table and language table
SELECT *
FROM film
WHERE language_id IN (
	SELECT language_id
	FROM "language"
	WHERE "name" = 'English'
);

SELECT *
FROM "language";


-- Customers who live in dallas
SELECT first_name, last_name, address_id
FROM customer 
WHERE address_id IN (
	SELECT address_id
	FROM address
	WHERE city_id IN (
		SELECT city_id
		FROM city
		WHERE city = 'Dallas'
	)
);

SELECT *
FROM category;

--Subquery to grab all horror movies
SELECT title, film_id
FROM film
WHERE film_id IN (
	SELECT film_id
	FROM film_category
	WHERE category_id IN (
		SELECT category_id
		FROM category
		WHERE "name" = 'Horror'
	)
);	

SELECT district
FROM address;


-- Assignments Week5 Day2
-- 1. List all customers who live in Texas (use
-- JOINs)

SELECT *
FROM customer customer
JOIN address ON customer.address_id = address .address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country = 'United States'
  AND address.district = 'Texas';


SELECT *
FROM payment
JOIN district
-- 2. Get all payments above $6.99 with the Customer's Full
-- Name

SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS full_name, payment.amount
FROM payment 
JOIN customer ON payment.customer_id = customer.customer_id
WHERE payment.amount > 6.99;

-- 3. Show all customers names who have made payments over $175(use
-- subqueries)
SELECT CONCAT(customer.first_name, ' ', customer.last_name) AS full_name
FROM customer 
WHERE customer.customer_id IN (
  SELECT payment.customer_id
  FROM payment 
  WHERE payment.amount >= 175
);


-- 4. List all customers that live in Nepal (use the city
-- table)
SELECT customer.*
FROM customer 
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Nepal';


-- 5. Which staff member had the most
-- transactions?
SELECT staff.first_name, staff.last_name, COUNT(*) AS transaction_count
FROM staff 
JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY staff.staff_id
ORDER BY transaction_count DESC
LIMIT 1;

-- 6. How many movies of each rating are
-- there?
SELECT rating, COUNT(*) AS movie_count
FROM film
GROUP BY rating;


-- 7.Show all customers who have made a single payment
-- above $6.99 (Use Subqueries)
SELECT *
FROM customer
WHERE customer_id IN (
  SELECT customer_id
  FROM payment
  WHERE amount > 6.99
  GROUP BY customer_id
  HAVING COUNT(*) = 1
);


-- 8. How many free retals did our stores give away?
SELECT *
FROM customer
WHERE customer_id IN (
  SELECT customer_id
  FROM payment
  WHERE amount > 0.00
  GROUP BY customer_id
);



















































