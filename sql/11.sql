/*
 * List the name of all actors who have appeared in a movie that has the 'Behind the Scenes' special_feature
 */
SELECT DISTINCT
    a.first_name || ' ' || a.last_name AS "Actor Name"
FROM actor AS a
JOIN film_actor AS fa
    ON a.actor_id = fa.actor_id
JOIN film AS f
    ON fa.film_id = f.film_id,
    unnest(f.special_features) AS feature
WHERE feature = 'Behind the Scenes'
ORDER BY "Actor Name";
