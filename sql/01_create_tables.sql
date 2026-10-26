-- MySQL 8+ schema for the Trade Reconciliation Model.
-- Import data/internal_trades.csv and data/broker_trades.csv into these tables.
-- For the simplest import, use MySQL Workbench's Table Data Import Wizard.

CREATE DATABASE IF NOT EXISTS trade_reconciliation;
USE trade_reconciliation;

DROP TABLE IF EXISTS internal_trades;
CREATE TABLE internal_trades (
    trade_id VARCHAR(20) NOT NULL,
    trade_date DATE,
    counterparty VARCHAR(100),
    ticker VARCHAR(20),
    side VARCHAR(10),
    quantity INT,
    price DECIMAL(18, 4)
);

DROP TABLE IF EXISTS broker_trades;
CREATE TABLE broker_trades (
    trade_id VARCHAR(20) NOT NULL,
    trade_date DATE,
    counterparty VARCHAR(100),
    ticker VARCHAR(20),
    side VARCHAR(10),
    quantity INT,
    price DECIMAL(18, 4)
);

-- After importing the CSV files, verify the loaded row counts:
SELECT 'internal_trades' AS source_name, COUNT(*) AS row_count FROM internal_trades
UNION ALL
SELECT 'broker_trades' AS source_name, COUNT(*) AS row_count FROM broker_trades;
