# Kindred AI Project Overview

## Inspiration
I started this project because I realized that for many small business owners, technology is often a barrier rather than a helper. Someone running a shoe store is focused on their products and their customers, not on navigating complex dropdown menus or filling out forms on a screen. I wanted to build an interface that was invisible. I wanted a business partner that you could talk to while you were unpacking boxes or helping a customer, and it would just handle the logistics in the background.

## What it does
Kindred is a voice-first business management ecosystem. It functions as a retail intelligence agent that stays synchronized with a live inventory and financial ledger. I can tell it to record a sale of three Nike Air Max shoes, and it doesn't just "understand" me—it actually executes the business logic to subtract those items from the warehouse and add the revenue to the digital till. It generates daily briefings, predicts when stock will run out based on sales velocity, and handles operational expenses through a smart confirmation system.

## How I built it
I chose a stack that emphasizes stability and structure because business data is too important to leave to chance.

### The Backend with Serverpod
I used Serverpod as the primary framework for the server-side logic. It allowed me to define my data models—Products, Expenses, Accounts—in simple YAML files and automatically generated the PostgreSQL tables and the Dart client-side code. I implemented specific server-side modules for different business domains. For instance, the account module handles the balance logic to ensure that an expense can only be recorded if there are sufficient funds, while the seed module allows for rapid environment setup with realistic business data for testing.

### The Brain with Gemini
The intelligence layer is powered by Gemini 2.0 Flash. I didn't treat it as a simple text-in-text-out assistant. Instead, I built it as an Orchestrator. When a user speaks, I pass their transcription to Gemini along with a set of tool definitions. Gemini has the ability to "call" functions like get_products or get_expenses. This is crucial because it means the AI never hallucinates a stock count; it pauses its thought process, asks the Serverpod backend for the latest data, and only then formulates its answer. I enforced a strict JSON schema for its output, forcing it to decide on an Intent (like retail or finance) and a UI Mode (like chart or table).

### The Morphic UI in Flutter
On the frontend, I developed what I call a Morphic UI system using Flutter. The entire main screen is a dynamic container that listens to the AppState. When the AI returns a state, the screen completely reconstructs itself. If the AI detects a financial trend, the screen shifts to a gradient-filled line chart. If it detects a stock inquiry, it transforms into an inventory dashboard with status badges and zebra-striped tables. I used Provider for clean state management and ElevenLabs to give the agent a premium, natural-sounding voice that doesn't feel robotic.

## Challenges ran into
One of the hardest parts was the state synchronization between the voice input and the UI. Since the AI might take a few seconds to think and fetch data, I had to implement skeleton loaders and typing indicators to keep the user engaged. Another challenge was the math for profit analysis. I had to write logic that traces every single sale back to the original cost price of the specific product sold to calculate a true net profit, rather than just raw revenue. Handling the "Action Confirmations" was also tricky—building a system where the AI proposes a change (like adding an expense) but waits for a physical tap on a glassmorphic card before the database actually updates.

## Accomplishments that I'm proud of
The Daily Routine is definitely the highlight. It is an "AI Shortcut" that triggers multiple backend queries simultaneously. It identifies low stock, sums today's sales, calculates the profit margin, and finds the total operational expenses—all starting from a single sentence. I'm also proud of the visual aesthetic. I moved away from boring, flat business designs and used deep slates, emerald highlights, and glassmorphism to make the software feel like a premium tool.

## What I learned
I learned that the most effective AI applications are those that use the LLM to navigate traditional, structured data rather than trying to replace it. By using Serverpod to provide "guardrails" for the data and Gemini to provide the "interface," I was able to build something that is both flexible and mathematically accurate. I also learned a lot about audio processing in Flutter and how to build responsive charts that can handle both simple lists and complex comparisons.

## What the prediction logic actually does
I designed the prediction system to look at the last 30 days of activity. It calculates a simple linear projection by finding the daily average of your expenses or revenue and then multiplying it by the month ahead. While it is a linear model for now, it provides a realistic forecast that helps a shop owner see their "burn rate" before it's too late.

## What's next for Kindred AI
The next step is to make the system more proactive. Instead of me asking "What is my stock?", I want Kindred to push a notification to my phone saying "You sold 10 Nikes this morning, and at this rate, you will be out by Friday. Should I draft an order now?" I also want to incorporate multi-location support, so a business owner with three different branches can compare their performance through a single voice interface.
