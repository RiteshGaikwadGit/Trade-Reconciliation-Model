# Data Dictionary

Both source files contain synthetic training data. One row represents one trade record in a source system.

| Field | Type / example | Description |
|---|---|---|
| Trade ID | Text, `T1004` | Identifier used to match a trade across source systems. |
| Trade Date | Date, `2026-10-20` | Date the trade was recorded/executed in the sample. |
| Counterparty | Text, `ABC Bank` | Counterparty or broker name in the sample. |
| Ticker | Text, `AAPL` | Sample instrument symbol. |
| Side | Text, `BUY` / `SELL` | Trade direction. |
| Quantity | Whole number | Number of units in the trade. |
| Price | Decimal | Price per unit in the sample. |

## Assumptions
- `Trade ID` is the primary matching key, but duplicates must be detected rather than silently ignored.
- Quantity and price are compared exactly in this learning model.
- In production, price tolerances, currency, settlement date, status, and instrument identifiers may also need to be checked.
- Missing records and duplicate records require investigation; they should not be automatically treated as confirmed errors.
