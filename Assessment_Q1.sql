Assessment_Q1.sql
High-Value Customers with Both Savings and Investment Plans

SELECT
    u.id AS owner_id,
    TRIM(CONCAT(u.first_name, ' ', u.last_name)) AS name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = TRUE THEN p.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = TRUE THEN p.id END) AS investment_count,
    ROUND(SUM(s.confirmed_amount) / 100, 2) AS total_deposits
FROM users_customuser u
JOIN plans_plan p ON u.id = p.owner_id
JOIN savings_savingsaccount s ON s.plan_id = p.id AND s.confirmed_amount IS NOT NULL
WHERE p.is_deleted = FALSE AND p.is_archived = FALSE
GROUP BY u.id, u.first_name, u.last_name
HAVING 
    savings_count >= 1 AND
    investment_count >= 1
ORDER BY total_deposits DESC;
