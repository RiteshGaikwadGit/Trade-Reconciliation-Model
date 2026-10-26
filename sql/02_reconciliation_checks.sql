USE trade_reconciliation;

-- 1. Duplicate Trade IDs: investigate these before relying on a one-to-one match.
SELECT 'Internal' AS source_name, trade_id, COUNT(*) AS occurrence_count
FROM internal_trades
GROUP BY trade_id
HAVING COUNT(*) > 1
UNION ALL
SELECT 'Broker' AS source_name, trade_id, COUNT(*) AS occurrence_count
FROM broker_trades
GROUP BY trade_id
HAVING COUNT(*) > 1
ORDER BY source_name, trade_id;

-- 2. Internal trades that are missing from the broker file.
SELECT i.trade_id, i.trade_date, i.ticker, i.side, i.quantity, i.price
FROM internal_trades i
LEFT JOIN broker_trades b ON i.trade_id = b.trade_id
WHERE b.trade_id IS NULL
ORDER BY i.trade_id;

-- 3. Broker trades that are missing from the internal file.
SELECT b.trade_id, b.trade_date, b.ticker, b.side, b.quantity, b.price
FROM broker_trades b
LEFT JOIN internal_trades i ON b.trade_id = i.trade_id
WHERE i.trade_id IS NULL
ORDER BY b.trade_id;

-- 4. Quantity and price differences for Trade IDs present in both sources.
-- Note: if either source contains duplicate IDs, this join can produce multiple rows.
SELECT
    i.trade_id,
    i.ticker AS internal_ticker,
    i.quantity AS internal_quantity,
    b.quantity AS broker_quantity,
    i.quantity - b.quantity AS quantity_difference,
    i.price AS internal_price,
    b.price AS broker_price,
    ROUND(i.price - b.price, 4) AS price_difference,
    CASE
        WHEN i.quantity = b.quantity AND i.price = b.price THEN 'Matched'
        WHEN i.quantity <> b.quantity AND i.price <> b.price THEN 'Quantity and price mismatch'
        WHEN i.quantity <> b.quantity THEN 'Quantity mismatch'
        ELSE 'Price mismatch'
    END AS reconciliation_status
FROM internal_trades i
JOIN broker_trades b ON i.trade_id = b.trade_id
WHERE i.quantity <> b.quantity OR i.price <> b.price
ORDER BY i.trade_id;

-- 5. Combined exception list: missing records and quantity/price breaks.
-- Run duplicate detection (query 1) as a separate control because duplicates
-- can make a simple Trade ID join ambiguous.
SELECT
    i.trade_id,
    'Missing at Broker' AS break_type,
    'Confirm broker receipt/confirmation; investigate timing or source-file issue' AS suggested_action
FROM internal_trades i
LEFT JOIN broker_trades b ON i.trade_id = b.trade_id
WHERE b.trade_id IS NULL

UNION ALL

SELECT
    b.trade_id,
    'Missing Internally' AS break_type,
    'Check trade capture, booking status, and source-system feed' AS suggested_action
FROM broker_trades b
LEFT JOIN internal_trades i ON b.trade_id = i.trade_id
WHERE i.trade_id IS NULL

UNION ALL

SELECT
    i.trade_id,
    CASE
        WHEN i.quantity <> b.quantity AND i.price <> b.price THEN 'Quantity and price mismatch'
        WHEN i.quantity <> b.quantity THEN 'Quantity mismatch'
        ELSE 'Price mismatch'
    END AS break_type,
    'Compare confirmations and trade details; resolve or escalate under procedure' AS suggested_action
FROM internal_trades i
JOIN broker_trades b ON i.trade_id = b.trade_id
WHERE i.quantity <> b.quantity OR i.price <> b.price
ORDER BY trade_id, break_type;

-- 6. Quick high-level counts (record-level counts; duplicates can affect counts).
SELECT
    (SELECT COUNT(*) FROM internal_trades) AS internal_rows,
    (SELECT COUNT(*) FROM broker_trades) AS broker_rows,
    (SELECT COUNT(DISTINCT trade_id) FROM internal_trades) AS distinct_internal_trade_ids,
    (SELECT COUNT(DISTINCT trade_id) FROM broker_trades) AS distinct_broker_trade_ids;
