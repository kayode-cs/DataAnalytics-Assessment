WITH last_inflow_tx AS (
    SELECT
        p.id AS plan_id,
        p.owner_id,
        CASE
            WHEN p.is_regular_savings = TRUE THEN 'Savings'
            WHEN p.is_a_fund = TRUE THEN 'Investment'
            ELSE 'Other'
        END AS type,
        MAX(s.transaction_date) AS last_transaction_date
    FROM plans_plan p
    LEFT JOIN savings_savingsaccount s
        ON s.plan_id = p.id
        -- assuming confirmed_amount > 0 means inflow deposit
        AND s.confirmed_amount > 0
    WHERE p.is_deleted = FALSE
      AND p.is_archived = FALSE
      AND (p.is_regular_savings = TRUE OR p.is_a_fund = TRUE)
    GROUP BY p.id, p.owner_id, type
)

SELECT
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATEDIFF(CURDATE(), last_transaction_date) AS inactivity_days
FROM last_inflow_tx
WHERE (last_transaction_date IS NULL OR last_transaction_date <= DATE_SUB(CURDATE(), INTERVAL 365 DAY))
ORDER BY inactivity_days DESC;

