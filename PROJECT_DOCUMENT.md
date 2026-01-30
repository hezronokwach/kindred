# Kindred Butler: Project Specification

## 1. Project Identity
**Name**: Kindred Butler (formerly Morphic)
**Core Value Proposition**: Reducing operational friction for small retail businesses through a voice-driven AI strategic partner.

## 2. System Architecture

### 2.1 Frontend (Flutter)
The UI is built on a "Morphic" design philosophy where the layout is not static but determined by the AI's intent.
- **State Management**: `Provider` handles real-time updates for AI transcription and UI transitions.
- **Components**: 
  - `MorphicContainer`: The master controller that switches `UIMode` between `table`, `chart`, `image`, `action`, and `dashboard`.
  - `ActionCard`: A high-fidelity glassmorphic component for transaction confirmation.
  - `FinanceChart`: A modular chart system using `fl_chart` for trends and comparisons.

### 2.2 Backend (Serverpod)
The server acts as the source of truth for all business data.
- **ORM**: PostgreSQL tables for `Product`, `Expense`, `Account`, `Alert`, and `Shortcut`.
- **Endpoints**:
  - `ProductEndpoint`: Inventory CRUD and stock management.
  - `AccountEndpoint`: Financial balance integrity and transaction processing.
  - `ExpenseEndpoint`: Ledger management for both operational costs and sales revenue.
  - `SeedEndpoint`: Automatic database population for demo environments.

### 2.3 Intelligence (Gemini AI)
Google Gemini 2.0 Flash is used as a tool-calling orchestrator.
- **Role**: Strategic Business Assistant.
- **Logic**: It parses natural language, identifies required data tools (functions), and generates a response structured as a restricted JSON object.
- **Safety**: No database writes happen through AI interpretation alone; all writes are routed through `ActionService` for user confirmation.

## 3. Core Modules

### 3.1 Inventory Management
Tracks stock levels, brands, and categories. Includes a "Smart Reorder" system that identifies items below the `minStockThreshold`.

### 3.2 Financial Ledger
Tracks revenue (sales) and costs (operational expenses).
- **Sales Flow**: Sale -> Add Balance -> Subtract Stock -> Record Transaction.
- **Expense Flow**: Expense -> Verify Balance -> Subtract Balance -> Record Transaction.

### 3.3 Analytics & Dashboards
Uses rolling averages for 30-day forecasting and grouped data for week-over-week comparisons. The "Daily Routine" is a composite shortcut that aggregates these metrics.

## 4. Branding & Design
- **Theme**: Dark Mode (Slate and Emerald).
- **Visual Language**: Glassmorphism, smooth animations, and high-contrast typography.
- **Voice**: Professional, strategic, and concise.

## 5. Security & Integrity
- **Database**: PostgreSQL with Serverpod migrations.
- **Validation**: All financial transactions check for sufficient funds before execution.
- **Environment**: Secrets managed via `.env` (client) and `passwords.yaml` (server).
