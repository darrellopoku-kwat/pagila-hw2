/*
 * Create a report that shows the total revenue per month and year.
 *
 * HINT:
 * This query is very similar to the previous problem,
 * but requires an additional JOIN.
 */
SELECT
    DATE_PART('year', r.rental_date) AS "Year",
    DATE_PART('month', r.rental_date) AS "Month",
    SUM(p.amount) AS "Total Revenue"
FROM payment AS p
JOIN rental AS r
    ON p.rental_id = r.rental_id
GROUP BY ROLLUP(
    DATE_PART('year', r.rental_date),
    DATE_PART('month', r.rental_date)
)
ORDER BY "Year", "Month";
