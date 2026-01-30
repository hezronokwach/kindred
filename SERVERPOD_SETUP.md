# Serverpod Setup & Testing Guide

## Prerequisites

1. **Install Serverpod CLI** (one-time setup):
```bash
dart pub global activate serverpod_cli
```

2. **Ensure Docker Desktop is running** (for PostgreSQL database)

---

## Step 1: Generate Serverpod Code

From the server directory, regenerate the client code:

```bash
cd c:\Users\hezro\Desktop\projects\kindred\kindred_butler\kindred_butler_server
C:\Users\hezro\AppData\Local\Pub\Cache\bin\serverpod generate
```

Or if you added serverpod to PATH:
```bash
serverpod generate
```

This creates the client code with all endpoints (product, account, expense, seed, test).

---

## Step 2: Start Docker Services

Start PostgreSQL database:

```bash
cd c:\Users\hezro\Desktop\projects\kindred\kindred_butler\kindred_butler_server
docker-compose up -d
```

Verify it's running:
```bash
docker ps
```

You should see `postgres` container running on port 8090.

---

## Step 3: Start Serverpod Server

```bash
cd c:\Users\hezro\Desktop\projects\kindred\kindred_butler\kindred_butler_server
dart bin/main.dart
```

**Expected output:**
```
SERVERPOD initialized
API server listening on http://localhost:8080
Insights server listening on http://localhost:8081
Webserver listening on http://localhost:8082
```

Keep this terminal running.

---

## Step 4: Run Flutter App

Open a **NEW terminal** and run:

```bash
cd c:\Users\hezro\Desktop\projects\kindred
flutter run -d chrome
```

**This runs your morphic voice agent UI with Serverpod backend.**

---

## Testing the Agent

Once the Flutter app loads in Chrome:

1. **Click the microphone button** or press the voice input
2. **Say commands like:**
   - "Show me all products"
   - "What's my balance?"
   - "Order 5 Nike shoes"
   - "Show me expenses"

The app will:
- Use speech recognition to capture your voice
- Send to Gemini AI for analysis
- Call Serverpod endpoints for data
- Display results in the UI
- Speak responses via ElevenLabs

---

## Troubleshooting

### If server won't start:
```bash
# Check if port 8080 is in use
netstat -ano | findstr :8080

# Kill process if needed (replace PID)
taskkill /PID <PID> /F
```

### If database connection fails:
```bash
# Restart Docker containers
docker-compose down
docker-compose up -d
```

### If Flutter app shows errors:
```bash
# Clean and rebuild
cd c:\Users\hezro\Desktop\projects\kindred
flutter clean
flutter pub get
flutter run -d chrome
```

### If CORS errors persist:
- Ensure server shows "API server listening on http://localhost:8080"
- Check `.env` has `SERVERPOD_URL=http://localhost:8080`
- Restart both server and Flutter app

---

## Quick Start (After Initial Setup)

**Terminal 1 - Start Server:**
```bash
cd c:\Users\hezro\Desktop\projects\kindred\kindred_butler\kindred_butler_server
dart bin/main.dart
```

**Terminal 2 - Start App:**
```bash
cd c:\Users\hezro\Desktop\projects\kindred
flutter run -d chrome
```

---

## Stopping Everything

1. **Stop Flutter app:** Press `q` in terminal or close Chrome
2. **Stop Serverpod server:** Press `Ctrl+C` in server terminal
3. **Stop Docker (optional):**
```bash
cd c:\Users\hezro\Desktop\projects\kindred\kindred_butler\kindred_butler_server
docker-compose down
```
