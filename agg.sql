-- 1. Select the first name, last name, and email address of all the customers who have rented a movie.
SELECT DISTINCT customer.first_name, customer.last_name, customer.email
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id;

-- 2. What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
SELECT customer.customer_id, CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name, AVG(payment.amount) AS average_payment
FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id;

-- 3. Select the name and email address of all the customers who have rented the "Action" movies.
-- Using multiple join statements:
SELECT DISTINCT customer.first_name, customer.last_name, customer.email
FROM customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Action';

-- Using subqueries with multiple WHERE clause and `IN` condition:
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
WHERE customer.customer_id IN (
    SELECT rental.customer_id
    FROM rental
    WHERE rental.inventory_id IN (
        SELECT inventory.inventory_id
        FROM inventory
        WHERE inventory.film_id IN (
            SELECT film.film_id
            FROM film
            JOIN film_category ON film.film_id = film_category.film_id
            WHERE film_category.category_id = (
                SELECT category.category_id
                FROM category
                WHERE category.name = 'Action'
            )
        )
    )
);

-- 4. Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment.
SELECT payment_id, amount,
CASE
    WHEN amount BETWEEN 0 AND 2 THEN 'low'
    WHEN amount BETWEEN 2 AND 4 THEN 'medium'
    WHEN amount > 4 THEN 'high'
    ELSE 'undefined'
END AS value_classification
FROM payment;