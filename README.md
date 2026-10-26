# Trade Reconciliation Model

**Portfolio project | Excel, MySQL | Finance Operations / Investment Banking Operations**

## Project overview
This project demonstrates a basic trade-reconciliation workflow: compare an internal trade blotter with a broker trade file, identify discrepancies (“breaks”), summarize the breaks, and suggest an investigation action.

The workbook uses **synthetic sample data** created for learning and portfolio demonstration. It does not contain real client, bank, broker, or market records.

## Business problem
Operations teams need to confirm that trades recorded internally agree with the corresponding broker records. Differences can create settlement, reporting, or operational risk if they are not investigated promptly.

## Objectives
- Match trades using a unique Trade ID.
- Compare trade dates, quantities, and prices between internal and broker records.
- Flag missing trades, quantity/price mismatches, and duplicate IDs.
- Summarize break types and record a suggested next action.
- Demonstrate how Excel checks can be translated into SQL queries.

## Files and folders
- `Trade_Reconciliation_Model.xlsx` — interactive workbook with source data, formula-driven reconciliation, break summary, and practice tasks.
- `data/internal_trades.csv` — synthetic internal trade records.
- `data/broker_trades.csv` — synthetic broker trade records.
- `sql/01_create_tables.sql` — MySQL 8 table definitions.
- `sql/02_reconciliation_checks.sql` — SQL checks for missing records, mismatches, and duplicates.
- `docs/data_dictionary.md` — field definitions and assumptions.
- `docs/resume_bullets.md` — resume-ready project description.

## Excel workflow
1. Review the `Internal Trades` and `Broker Trades` tabs.
2. Use Trade ID as the matching key.
3. Use `XLOOKUP` to bring broker fields beside internal fields.
4. Use `IF` / `AND` to compare fields and classify matches or breaks.
5. Use `IFERROR` to handle IDs not found in a source file.
6. Use `COUNTIF` to flag duplicate Trade IDs.
7. Review `Break Summary` for break counts and suggested actions.

> The workbook uses modern Excel functions such as `XLOOKUP`, supported by Microsoft 365 and recent Excel versions. If your Excel version does not support XLOOKUP, replace it with `INDEX`/`MATCH` or `VLOOKUP` where appropriate.

## SQL workflow
1. Create the two tables using `sql/01_create_tables.sql`.
2. Import the two CSV files into MySQL Workbench using the Table Data Import Wizard, or load them into the tables using your preferred method.
3. Run the queries in `sql/02_reconciliation_checks.sql`.
4. Review each result set and explain the operational follow-up.

The SQL script is written for MySQL 8+. The CSV files include a header row, so import them with the header row excluded from data rows.

## Checks included
- Internal trades missing from the broker file.
- Broker trades missing from the internal file.
- Quantity differences for matching Trade IDs.
- Price differences for matching Trade IDs.
- Duplicate Trade IDs within either source.
- A combined exception list for investigation.

## Suggested operational interpretation
A break is an exception to investigate, not automatic proof of a trading error. Confirm source files, trade lifecycle events, corrections/cancellations, timing differences, and broker confirmations before closing a break. Keep an evidence trail and follow the applicable escalation process.

## Limitations and next improvements
- The dataset is intentionally small and synthetic; it is designed to demonstrate logic, not production-scale performance.
- The sample model checks a limited set of fields. A production control may also check currency, side, counterparty, settlement date, instrument identifiers, trade status, and tolerance rules.
- A next iteration could add a break owner, aging/SLA tracking, resolution notes, and a Power BI dashboard for break trends.

## Skills demonstrated
Excel formulas (`XLOOKUP`, `IF`, `IFERROR`, `AND`, `COUNTIF`), data comparison, exception identification, break summaries, MySQL joins and aggregations, operational risk awareness, and documentation.

## Portfolio presentation tip
When presenting this project, explain the business problem first, then show one matched trade, one quantity/price break, one missing trade, and the summary/action tracker. Be clear that the data is synthetic and describe the checks you implemented yourself.
