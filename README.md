# DataAnalytics-Assessment

## Overview

This repository contains my SQL solutions to a Data Analyst assessment focused on customer transactions, account activity, and value analysis using MySQL. This tasks cover joins, aggregations, filtering, and date calculations. Each query addresses specific business questions by analyzing user data, savings accounts, plans, and withdrawals.


## Question 1: High-Value Customers with Multiple Products

**Approach:**

- started by inserting the file into MySQL so as to read the file and i start by checking the tables and it Values. **CODE USED** is (`SHOW TABLES;`). i listed out the tables from the results and i checked for the columns and rows in each table using (`DESCRIBE tablename`). and it shows the following (`field i.e Column, Type i'e Data type, Null, Key, Default, Extra`)
- Identified customers who have at least one active funded savings plan (`is_regular_savings = 1`) **and** one funded investment plan (`is_a_fund = 1`).
- Joined the `plans_plan` and `savings_savingsaccount` tables to count deposits per product type.
- Calculated total deposits per customer summing `confirmed_amount` from deposits only.
- Returned customer IDs, full names (concatenated `first_name` and `last_name`), counts of savings and investment plans, and total deposits.
- Sorted by total deposits descending to highlight high-value customers.

**Challenges:**

- Ensuring the correct join conditions and filtering only active plans.
- Handling customers with multiple plans without double counting.
- Formatting full customer names from separate fields.

---

## Question 2: Transaction Frequency Analysis

**Approach:**

- Calculated the number of transactions per customer grouped by month.
- Averaged transactions per month per customer over their active months.
- Categorized customers into frequency buckets:
  - High Frequency: ≥10 transactions/month
  - Medium Frequency: 3–9 transactions/month
  - Low Frequency: ≤2 transactions/month
- Aggregated counts of customers per category and average transaction frequency.

**Challenges:**

- Computing average transactions accurately over varying customer tenures.
- Correctly bucketing customers according to specified frequency ranges.
- Handling customers with no transactions or very recent signups.

---

## Question 3: Account Inactivity Alert

**Approach:**

- Identified active savings or investment plans (`is_regular_savings = 1` or `is_a_fund = 1`) that are neither deleted nor archived.
- Joined with `savings_savingsaccount` to find the latest inflow transaction date per plan (`confirmed_amount > 0`).
- Flagged plans with no inflow in the last 365 days or with no inflow transactions at all.
- Calculated days since last transaction for inactivity monitoring.

**Challenges:**

- Defining inflow transactions strictly using `confirmed_amount`.
- Managing plans with no transactions (null dates).
- Filtering out inactive or archived plans correctly.

---

## Question 4: Customer Lifetime Value (CLV) Estimation

**Approach:**

- Calculated each customer’s tenure in months since signup using `date_joined`.
- Counted total transactions from `savings_savingsaccount`.
- Estimated CLV with the formula:  
  \[
  CLV = \left(\frac{\text{total\_transactions}}{\text{tenure\_months}}\right) \times 12 \times \text{avg\_profit\_per\_transaction}
  \]
  where profit per transaction = 0.1% of transaction value (`confirmed_amount`).
- Converted amounts from kobo to base currency.
- Sorted customers by highest estimated CLV.

**Challenges:**

- Handling customers with very short tenure (avoiding division by zero).
- Converting kobo to base currency correctly.
- Aggregating data efficiently with joins and groupings.

---

## Notes:

- All queries were written in MySQL.
- Used aggregate functions and date functions for clarity and efficiency.
- Assumed `confirmed_amount` > 0 represents inflow deposits; withdrawals ignored unless stated.
- Careful handling of null and zero values to avoid errors.

---
