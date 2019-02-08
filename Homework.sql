/* Created by Thinh Nguyen */


use sakila;

/* 1a. Display the first and last names of all actors from the table actor. */
select first_name,last_name from actor;
/* Querying for the two columns in the actor table.


/* 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name. */

select concat(first_name,' ',last_name) as 'Actor Name'
from actor;

/* Concatenating two columns together. Strings are already upper case. */




/* 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information? */

select actor_id,first_name,last_name 
from actor
where first_name = "JOE";


/* 2b. Find all actors whose last name contain the letters `GEN`: */

select *
from actor
where last_name like "%GEN%";
/* Used like operation to search for a last name that contains the phrase "GEN".


/* 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order: */
select *
from actor
where last_name like "%LI%"
order by last_name ASC, first_name ASC;

/* Used the like operation again, and sorted using the order by operation by last name,first name in ascending order.


/* 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China: */

select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

/* Using the IN operation, it finds the rows where Afghanistan, Bangladesh, and China are present.

/* 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant). */
ALTER TABLE actor
add Description BLOB;

/* Adds Description Column with BLOB datatype.

/* 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column. */
ALTER TABLE actor
drop Description;

/* Deletes Description Column with BLOB datatype.*/

/* 4a. List the last names of actors, as well as how many actors have that last name. */

select last_name, count(last_name) 
from actor
group by last_name;


/* 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors */

select last_name, count(last_name) 
from actor
group by last_name
having count(last_name) >=2;

/* Returns counts where the count is greater than or equal to 2. */


/* 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record. */
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name ='WILLIAMS'; 
/* Updates the table by setting GROUCHO to HARPO. */

/* 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. */

UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name ='WILLIAMS'; 
/* Re-Updates the table by setting HARPO to GROUCHO. */


/* 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it? */
SHOW CREATE TABLE address;

/*Used the sql DEV to get the Query needed */
  /* Hint: [https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html](https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html) */
  
/* 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`: */
SELECT first_name,last_name,address
FROM staff JOIN address
ON staff.address_id=address.address_id;
/* Joined two tabled based on their address_id.*/

/* 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. */
SELECT first_name,last_name,SUM(amount) as Total
FROM staff JOIN payment
ON staff.staff_id=payment.staff_id
group by first_name;


/* 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join. */
select title,count(film.film_id) as ActorCount
from film JOIN film_actor
ON film.film_id =film_actor.film_id
group by title;

/*Joins the tables and counts up the number of actors listed in each film. */

/* 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system? */

select title,count(film.film_id) as Copies_Available
from film JOIN inventory
ON film.film_id =inventory.film_id
WHERE title ='Hunchback Impossible';

	/*Checks inventory using a join to check the number of copies available for Hunchback Impossible */


	/* 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name: */

	SELECT first_name,last_name,SUM(payment.amount)
	FROM payment JOIN customer
	ON payment.customer_id = customer.customer_id
	GROUP BY last_name
    ORDER BY last_name;
/*Joins the payment and customer table by using customer_id and counts up the total purchases of each customer. */


/* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. */
select title
FROM film JOIN language
ON film.language_id =language.language_id
WHERE name = 'English';	
    (select title
    FROM film
	WHERE title LIKE 'Q%' OR title LIKE 'K%');

/* Uses a subquery to find titles that have Q or K. It also checks if the language used is English. */


/* 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.*/

select first_name,last_name
FROM actor


 WHERE actor_id IN (select actor_id
    FROM film JOIN film_actor
	ON film.film_id=film_actor.film_id
	WHERE film.title ='ALONE TRIP'
    );
    
    /* Used the subquery to look for the actor_id of people who are in Alone Trip and passes that information to the main query
    to look for the first and last name of the actors using the actor_id. */





/* 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.*/

select first_name, last_name, email
FROM customer
WHERE address_id IN 
(
select address.address_id
FROM address JOIN city
ON address.city_id = city.city_id
WHERE country_id IN
(
SELECT city.country_id
FROM city JOIN country
ON city.country_id = country.country_id
WHERE country.country ='Canada'
)
);

/* Used a subquery within a subquery to parse between tables. It looks inside the country for the country_id of Canada.
It then ties it to cities that have the Canada country_id. It then uses the city_id to tie it to the address table. Using the address_id,
it connects it to the customer tables and queries for the customers that have that address_id. */

/* 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.*/

SELECT title
FROM film
WHERE film_id IN
(
SELECT film.film_id
FROM film JOIN film_category
ON film.film_id = film_category.film_id
WHERE category_id IN
(
SELECT category_id
FROM category
WHERE name ='Family'
)
);

/* Sub queries the category table for the id of Family, and uses that to get the films that have the Family category. Finally it will create a query that brings out
the family movies */

/* 7e. Display the most frequently rented movies in descending order.*/

SELECT title,COUNT(title) as Rental_Count
FROM film JOIN inventory
ON film.film_id = inventory.film_id
WHERE inventory_id IN 
(

SELECT inventory_id
FROM rental
)
GROUP BY title
ORDER BY Rental_Count DESC;


/*Counts up number of rentals by descending title. Uses subquery to get the inventory_id to connect to the inventory table and connect that to the film table.

/* 7f. Write a query to display how much business, in dollars, each store brought in.*/

SELECT staff_id as Store,SUM(amount)
FROM payment
GROUP BY staff_id;

/* Each staff member manages a different store. the SUM function counts up the payments rung up by each staff member and shows the business brought in.*/


/* 7g. Write a query to display for each store its store ID, city, and country.*/

SELECT store.store_id,city.city,country.country
FROM store
	JOIN address
		ON address.address_id = store.store_id
	JOIN city
		ON city.city_id = address.city_id
	JOIN country
		ON country.country_id = city.country_id;

/* Uses multiple joins to grab the different columns needed. */

/* 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)*/

SELECT category.name, SUM(amount) as Revenue
FROM category
	JOIN film_category
		ON category.category_id =film_category.category_id
	JOIN inventory
		ON film_category.film_id = inventory.film_Id
	JOIN rental
		ON inventory.inventory_id = rental.inventory_id
	JOIN payment
		ON rental.rental_id =payment.rental_id
GROUP BY category.name
ORDER BY Revenue DESC
LIMIT 5;

/*Utlize joining multiple tables using IDs to get the payment amount total for each category. */




/* 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.*/
CREATE VIEW TOP5Genres AS

SELECT category.name, SUM(amount) as Revenue
FROM category
	JOIN film_category
		ON category.category_id =film_category.category_id
	JOIN inventory
		ON film_category.film_id = inventory.film_Id
	JOIN rental
		ON inventory.inventory_id = rental.inventory_id
	JOIN payment
		ON rental.rental_id =payment.rental_id
GROUP BY category.name
ORDER BY Revenue DESC
LIMIT 5;

/* Utilized Previous solution to create the view. */

/* 8b. How would you display the view that you created in 8a? */

SELECT * FROM Top5Genres;

/* Viewing a VIEW */

/* 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it. */


DROP VIEW top5Genres;

/* Drops VIEW from the databaes.

## Appendix: List of Tables in the Sakila DB

/* A schema is also available as `sakila_schema.svg`. Open it with a browser to view.

```sql
'actor'
'actor_info'
'address'
'category'
'city'
'country'
'customer'
'customer_list'
'film'
'film_actor'
'film_category'
'film_list'
'film_text'
'inventory'
'language'
'nicer_but_slower_film_list'
'payment'
'rental'
'sales_by_film_category'
'sales_by_store'
'staff'
'staff_list'
'store'
```
*/
/*## Uploading Homework

* To submit this homework using BootCampSpot:

  * Create a GitHub repository.
  * Upload your .sql file with the completed queries.
  * Submit a link to your GitHub repo through BootCampSpot.
*/