# Kindred Butler: Testing & Validation Guide

This guide provides structured test cases to verify the core functionality of the Kindred Butler agent.

## 1. Environment Verification
Before testing, ensure the server and app are running:
1.  **Server**: Terminal shows `API server listening on http://localhost:8080`.
2.  **Flutter**: App is loaded in Chrome or an Emulator.
3.  **Logs**: Terminal logs should be minimal (optimized for performance).

---

## 2. Inventory Test Cases

### 2.1 Full Inventory Display
- **Command**: "Show all products" or "What's in stock?"
- **Expectation**: UI shifts to `UIMode.table`. The table displays all 6 products with their stock counts and status badges.

### 2.2 Specific Product Search
- **Command**: "Show me the Nike Air Max"
- **Expectation**: UI shifts to `UIMode.image`. A card appears showing the Nike Air Max image, price, and current stock.

### 2.3 Smart Reorder
- **Command**: "What should I reorder?"
- **Expectation**: AI identifies products where `stockCount` <= `minStockThreshold` and displays them in a table.

---

## 3. Financial Test Cases

### 3.1 Balance Inquiry
- **Command**: "How much money do we have?"
- **Expectation**: AI responds with the current account balance (e.g., "$15,000.00").

### 3.2 Total Expenses
- **Command**: "Total expenses for this month"
- **Expectation**: AI calculates the sum of all `type: expense` records from the current month and displays a chart. Narrative must mention the exact dollar total.

### 3.3 Weekly Comparison
- **Command**: "How is my spending this week vs last week?"
- **Expectation**: A **Grouped Bar Chart** appears showing side-by-side slate (last week) and emerald (this week) bars.

---

## 4. Business Action Flow (The "Confirmation" Loop)

### 4.1 Recording a Sale
- **Command**: "Record a sale of 2 Nike Air Max"
- **Expectation**:
    1.  An **Action Card** appears with a "shopping bag" icon.
    2.  Card shows: "Record a sale for Nike Air Max? Quantity: 2 units, Revenue: $[Total]".
    3.  Click **Confirm**.
    4.  Verify narrative: "Sale recorded! ... Added $[X] to balance."

### 4.2 Recording an Expense
- **Command**: "Record an expense of $50 for Electricity"
- **Expectation**:
    1.  An **Action Card** appears with a "receipt" icon.
    2.  Card shows Category "Electricity" and Amount "$50".
    3.  Click **Confirm**.
    4.  Verify balance decreases by $50.

---

## 5. Dashboards & Routines

### 5.1 Daily Routine
- **Command**: "Run my daily routine"
- **Expectation**:
    1.  UI shifts to `UIMode.dashboard`.
    2.  Screen shows three sections:
        - **Sales Trend (Today)**
        - **Operational Expenses (Today)**
        - **Restock Required (Table)**
    3.  Narrative summarizes today's net profit.

---

## 6. Troubleshooting Verification
- **Command**: (Mumble or say something nonsensical)
- **Expectation**: Icon shifts to "Help" and narrative says "Business Query Unclear."
- **Command**: "Record an expense of $1,000,000"
- **Expectation**: Action card appears, but "Confirm" button should be disabled because of insufficient funds (Red text warning).
