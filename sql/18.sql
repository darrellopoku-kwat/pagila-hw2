/*
 * Compute the total revenue for each film.
 * The output should include another new column "revenue percent" that shows the percent of total revenue that comes from the current film and all previous films.
 * That is, the "revenue percent" column is 100*"total revenue"/sum(revenue)
 *
 * HINT:
 * The `to_char` function can be used to achieve the correct formatting of your percentage.
 * See: <https://www.postgresql.org/docs/current/functions-formatting.html#FUNCTIONS-FORMATTING-EXAMPLES-TABLE>
 */
WITH film_revenue AS (
    SELECT
        f.title,
        COALESCE(SUM(p.amount), 0.00::numeric) AS revenue
    FROM film AS f
    LEFT JOIN inventory AS i ON f.film_id = i.film_id
    LEFT JOIN rental AS r ON i.inventory_id = r.inventory_id
    LEFT JOIN payment AS p ON r.rental_id = p.rental_id
    GROUP BY f.title
),
windowed AS (
    SELECT
        RANK() OVER (ORDER BY revenue DESC) AS rank,
        title,
        revenue,
        SUM(revenue) OVER (ORDER BY revenue DESC RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total_revenue,
        SUM(revenue) OVER () AS grand_total
    FROM film_revenue
)
SELECT
    rank,
    title,
    revenue,
    total_revenue AS "total revenue",
    CASE
        WHEN ROUND(100 * total_revenue / grand_total, 2) >= 100
        THEN to_char(ROUND(100 * total_revenue / grand_total, 2), 'FM000.00')
        ELSE to_char(ROUND(100 * total_revenue / grand_total, 2), 'FM00.00')
    END AS "percent revenue"
FROM windowed
ORDER BY revenue DESC, title;
