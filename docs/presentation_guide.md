# 60–90 Second Project Walkthrough

1. **Problem:** Trade reconciliation compares internal records with a broker file so discrepancies can be investigated before they create downstream operational or settlement issues.
2. **Data:** I created two synthetic source files, internal trades and broker trades, with Trade ID, date, ticker, side, quantity, and price.
3. **Method:** In Excel, I used XLOOKUP to bring matching broker fields into a reconciliation sheet, IF/AND to compare values, IFERROR to handle missing IDs, and COUNTIF to detect duplicate IDs.
4. **Outputs:** The workbook classifies breaks and summarizes them with suggested next actions. I also wrote MySQL queries for missing records, duplicate IDs, and quantity/price differences.
5. **Control mindset:** A break is an exception to investigate, not automatic proof of an error. The next step is to validate source records, check trade status/timing, document evidence, and escalate according to procedure.
6. **Limitation:** The dataset is synthetic and designed to demonstrate the workflow; it is not a production reconciliation system.
