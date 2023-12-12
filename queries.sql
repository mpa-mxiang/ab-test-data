/* What are the start and end dates of the experiment? */
/* Start date: */
SELECT * FROM activity ORDER BY dt LIMIT 1;









/* End date: */
SELECT * FROM activity ORDER BY dt DESC LIMIT 1;

/* How many total users were in the experiment? */
SELECT DISTINCT COUNT(*) FROM users;
/* How many users were in the control and treatment groups */
SELECT DISTINCT COUNT(*) FROM groups
WHERE groups.group = 'A';
SELECT DISTINCT COUNT(*) FROM groups
WHERE groups.group = 'B';
/* What was the conversion rate of all users? */
SELECT
    COALESCE(
        (COUNT(DISTINCT CASE WHEN a.spent > 0 THEN u.id END) * 100.0) /
        NULLIF(COUNT(DISTINCT u.id), 0), 0
    ) AS conversion_rate
FROM
    users u
LEFT JOIN
    activity a ON u.id = a.uid;
/* What is the user conversion rate for the control and treatment groups? */
SELECT
    g.group,
    COALESCE(
        (COUNT(DISTINCT CASE WHEN a.spent > 0 THEN g.uid END) * 100.0) /
        NULLIF(COUNT(DISTINCT g.uid), 0), 0
    ) AS conversion_rate
FROM
    groups g
LEFT JOIN
    activity a ON g.uid = a.uid
GROUP BY
    g.group;

/* What is the average amount spent per user for the control and treatment groups, including users who did not convert? */
SELECT
    g.group,
    COALESCE(
        SUM(a.spent) / COUNT(DISTINCT g.uid),
        0
    ) AS average_amount_spent
FROM
    groups g
LEFT JOIN
    activity a ON g.uid = a.uid
GROUP BY
    g.group;





/*
Write a SQL query that returns: the user ID,
the user’s country, the user’s gender, the user’s
device type, the user’s test group, whether or not
they converted (spent > $0), and how much they spent
in total ($0+). 
*/
SELECT
    u.id AS user_id,
    u.country,
    u.gender,
    COALESCE(a.device, 'Unknown') AS device,
    g.group AS test_group,
    CASE WHEN a.spent > 0 THEN 1 ELSE 0 END AS converted,
    COALESCE(a.spent, 0) AS total_spent
FROM
    users u
LEFT JOIN
    groups g ON u.id = g.uid
LEFT JOIN
    activity a ON u.id = a.uid;
