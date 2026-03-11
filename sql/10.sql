/*
 * Management is planning on purchasing new inventory.
 * Films with special features cost more to purchase than films without special features,
 * and so management wants to know if the addition of special features impacts revenue from movies.
 *
 * Write a query that for each special_feature, calculates the total profit of all movies rented with that special feature.
 *
 * HINT:
 * Start with the query you created in pagila-hw1 problem 16, but add the special_features column to the output.
 * Use this query as a subquery in a select statement similar to answer to the previous problem.
 */
SELECT
    feature AS special_feature,
    SUM(profit) AS profit
FROM (
    SELECT
        f.film_id,
        SUM(p.amount) AS profit,
        f.special_features
    FROM payment AS p
    JOIN rental AS r
        ON r.rental_id = p.rental_id
    JOIN inventory AS i
        ON i.inventory_id = r.inventory_id
    JOIN film AS f
        ON f.film_id = i.film_id
    GROUP BY f.film_id
) AS film_profits,
    unnest(special_features) AS feature
GROUP BY feature
ORDER BY feature;
