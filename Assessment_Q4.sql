SELECT
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    COUNT(s.id) AS total_transactions,
    ROUND(
        (COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0)) * 12
        * AVG(s.confirmed_amount * 0.001 / 100), 2
    ) AS estimated_clv
FROM users_customuser u
LEFT JOIN savings_savingsaccount s ON s.owner_id = u.id
GROUP BY u.id, name, tenure_months
HAVING tenure_months > 0
ORDER BY estimated_clv DESC;
