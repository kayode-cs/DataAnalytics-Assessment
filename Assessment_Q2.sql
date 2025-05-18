WITH customer_monthly_transactions AS (
    SELECT
        s.owner_id,
        DATE_FORMAT(s.transaction_date, '%Y-%m') AS month,
        COUNT(*) AS monthly_transaction_count
    FROM savings_savingsaccount s
    WHERE s.transaction_date IS NOT NULL
    GROUP BY s.owner_id, DATE_FORMAT(s.transaction_date, '%Y-%m')
),

average_transactions AS (
    SELECT
        owner_id,
        AVG(monthly_transaction_count) AS avg_tx_per_month
    FROM customer_monthly_transactions
    GROUP BY owner_id
),

categorized_customers AS (
    SELECT
        owner_id,
        CASE
            WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
            WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_tx_per_month
    FROM average_transactions
)

SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_tx_per_month), 1) AS avg_transactions_per_month
FROM categorized_customers
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');

