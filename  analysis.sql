-- ══════════════════════════════════════════════════
-- SALES PERFORMANCE ANALYSIS — Superstore Dataset
-- Author: Achwak
-- Tool: PostgreSQL
-- ══════════════════════════════════════════════════

-- ── 1. VUE GLOBALE ─────────────────────────────────
SELECT 
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(SUM(sales)::numeric, 2) AS total_revenue,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND(AVG(discount)::numeric * 100, 2) AS avg_discount_pct
FROM superstore;

-- ── 2. REVENUE ET PROFIT PAR CATÉGORIE ────────────
SELECT 
    category,
    ROUND(SUM(sales)::numeric, 2) AS total_revenue,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales) * 100)::numeric, 2) AS profit_margin_pct,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY category
ORDER BY total_revenue DESC;

-- ── 3. TOP 10 PRODUITS PAR REVENUE ────────────────
SELECT 
    product_name,
    category,
    ROUND(SUM(sales)::numeric, 2) AS total_revenue,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY product_name, category
ORDER BY total_revenue DESC
LIMIT 10;

-- ── 4. TOP 10 CLIENTS LES PLUS VALUABLE ───────────
SELECT 
    customer_name,
    segment,
    ROUND(SUM(sales)::numeric, 2) AS total_revenue,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY customer_name, segment
ORDER BY total_revenue DESC
LIMIT 10;

-- ── 5. RANKING CLIENTS PAR PROFIT (WINDOW FUNCTION)
SELECT 
    customer_name,
    segment,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    RANK() OVER (ORDER BY SUM(profit) DESC) AS profit_rank
FROM superstore
GROUP BY customer_name, segment
LIMIT 10;

-- ── 6. MONTHLY REVENUE GROWTH (LAG) ───────────────
SELECT
    DATE_TRUNC('month', order_date::date) AS month,
    ROUND(SUM(sales)::numeric, 2) AS monthly_revenue,
    ROUND(LAG(SUM(sales)) 
        OVER (ORDER BY DATE_TRUNC('month', order_date::date))
    ::numeric, 2) AS prev_month_revenue,
    ROUND((SUM(sales) - LAG(SUM(sales)) 
        OVER (ORDER BY DATE_TRUNC('month', order_date::date))) 
        / LAG(SUM(sales)) 
        OVER (ORDER BY DATE_TRUNC('month', order_date::date)) * 100
    ::numeric, 2) AS growth_pct
FROM superstore
GROUP BY DATE_TRUNC('month', order_date::date)
ORDER BY month;

-- ── 7. DISCOUNT IMPACT ON PROFIT ──────────────────
SELECT
    CASE 
        WHEN discount = 0 THEN 'No Discount'
        WHEN discount <= 0.2 THEN 'Low (0-20%)'
        WHEN discount <= 0.4 THEN 'Medium (20-40%)'
        ELSE 'High (40%+)'
    END AS discount_category,
    COUNT(*) AS total_orders,
    ROUND(AVG(profit)::numeric, 2) AS avg_profit,
    ROUND(AVG(sales)::numeric, 2) AS avg_sales,
    ROUND((SUM(profit) / SUM(sales) * 100)::numeric, 2) AS profit_margin
FROM superstore
GROUP BY discount_category
ORDER BY avg_profit DESC;

-- ── 8. RFM CUSTOMER SEGMENTATION ──────────────────
WITH rfm AS (
    SELECT
        customer_name,
        MAX(order_date::date) AS last_order_date,
        COUNT(DISTINCT order_id) AS frequency,
        ROUND(SUM(sales)::numeric, 2) AS monetary
    FROM superstore
    GROUP BY customer_name
),
rfm_scores AS (
    SELECT
        customer_name,
        last_order_date,
        frequency,
        monetary,
        NTILE(4) OVER (ORDER BY last_order_date DESC) AS recency_score,
        NTILE(4) OVER (ORDER BY frequency DESC) AS frequency_score,
        NTILE(4) OVER (ORDER BY monetary DESC) AS monetary_score
    FROM rfm
)
SELECT
    customer_name,
    recency_score,
    frequency_score,
    monetary_score,
    recency_score + frequency_score + monetary_score AS rfm_total,
    CASE
        WHEN recency_score + frequency_score + monetary_score >= 10 THEN 'Champion'
        WHEN recency_score + frequency_score + monetary_score >= 7 THEN 'Loyal'
        WHEN recency_score + frequency_score + monetary_score >= 5 THEN 'At Risk'
        ELSE 'Lost'
    END AS customer_segment
FROM rfm_scores
ORDER BY rfm_total DESC
LIMIT 20;

-- ── 9. TOP RÉGIONS PAR PROFIT ─────────────────────
SELECT
    region,
    state,
    ROUND(SUM(sales)::numeric, 2) AS total_revenue,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND((SUM(profit) / SUM(sales) * 100)::numeric, 2) AS profit_margin,
    COUNT(DISTINCT order_id) AS total_orders
FROM superstore
GROUP BY region, state
ORDER BY total_profit DESC
LIMIT 15;