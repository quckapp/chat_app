#!/bin/bash
# ──────────────────────────────────────────────────────────────────────────────
# ci_e2e.sh — CI pipeline entry point for E2E two-device chat tests.
#
# Runs the full E2E test suite: builds APK, installs on emulator,
# sets up test users, runs all 11 Maestro + WS verification scenarios.
#
# Usage:
#   bash ci_e2e.sh                    # Run full suite
#   bash ci_e2e.sh --scenario 01      # Run single scenario
#   bash ci_e2e.sh --skip-build       # Skip Flutter build (use existing APK)
#   bash ci_e2e.sh --skip-install     # Skip APK install (already installed)
#
# Prerequisites:
#   - Android SDK with emulator configured
#   - Flutter SDK on PATH
#   - Maestro CLI installed
#   - Node.js + npm installed
#   - Backend services running (docker compose up)
#   - jq installed
# ──────────────────────────────────────────────────────────────────────────────

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_ROOT="$(cd "$APP_DIR/../.." && pwd)"

# ── Parse args ────────────────────────────────────────────────────────────────
SKIP_BUILD=false
SKIP_INSTALL=false
SCENARIO=""
DEVICE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-build)   SKIP_BUILD=true; shift ;;
    --skip-install) SKIP_INSTALL=true; shift ;;
    --scenario)     SCENARIO="$2"; shift 2 ;;
    --device)       DEVICE="$2"; shift 2 ;;
    *)              echo "Unknown arg: $1"; exit 1 ;;
  esac
done

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║         QuckApp E2E Two-Device Chat Test Suite              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# ── Step 1: Check prerequisites ──────────────────────────────────────────────
echo "Step 1: Checking prerequisites..."

for cmd in adb flutter maestro node npm jq; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "ERROR: $cmd not found on PATH"
    exit 1
  fi
done
echo "  All prerequisites found."

# ── Step 2: Start emulator if needed ─────────────────────────────────────────
echo ""
echo "Step 2: Checking Android emulator..."

if [ -z "$DEVICE" ]; then
  DEVICE=$(adb devices | grep "emulator" | head -1 | awk '{print $1}')
fi

if [ -z "$DEVICE" ]; then
  echo "  No emulator running. Starting one..."
  # Try to start the default AVD
  AVD_NAME=$(emulator -list-avds 2>/dev/null | head -1)
  if [ -z "$AVD_NAME" ]; then
    echo "ERROR: No AVDs available. Create one with: avdmanager create avd ..."
    exit 1
  fi
  echo "  Starting emulator: $AVD_NAME"
  emulator -avd "$AVD_NAME" -no-window -no-audio -no-boot-anim &
  EMULATOR_PID=$!

  # Wait for emulator to boot
  echo "  Waiting for emulator to boot (up to 120s)..."
  adb wait-for-device
  for i in $(seq 1 60); do
    BOOT=$(adb shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')
    if [ "$BOOT" = "1" ]; then
      break
    fi
    sleep 2
  done

  DEVICE=$(adb devices | grep "emulator" | head -1 | awk '{print $1}')
  if [ -z "$DEVICE" ]; then
    echo "ERROR: Emulator failed to start."
    exit 1
  fi
fi

echo "  Device: $DEVICE"

# ── Step 3: Build Flutter APK ────────────────────────────────────────────────
echo ""
echo "Step 3: Building Flutter APK..."

APK_PATH="$APP_DIR/build/app/outputs/flutter-apk/app-debug.apk"

if [ "$SKIP_BUILD" = "true" ] && [ -f "$APK_PATH" ]; then
  echo "  Skipping build (--skip-build). Using existing APK."
else
  cd "$APP_DIR"
  flutter build apk --debug \
    --dart-define=API_BASE_URL=http://10.0.2.2:8080 \
    --dart-define=WS_BASE_URL=ws://10.0.2.2:8090
  echo "  APK built: $APK_PATH"
fi

# ── Step 4: Install APK on emulator ─────────────────────────────────────────
echo ""
echo "Step 4: Installing APK on emulator..."

if [ "$SKIP_INSTALL" = "true" ]; then
  echo "  Skipping install (--skip-install)."
else
  adb -s "$DEVICE" install -r "$APK_PATH"
  echo "  APK installed on $DEVICE."
fi

# ── Step 5: Verify backend is running ────────────────────────────────────────
echo ""
echo "Step 5: Checking backend services..."

BACKEND_OK=true
for service in kong go-bff redis realtime; do
  if ! docker compose -p quckapp-local ps --format "{{.Name}}" 2>/dev/null | grep -q "$service"; then
    echo "  WARNING: $service may not be running"
    BACKEND_OK=false
  fi
done

if [ "$BACKEND_OK" = "true" ]; then
  echo "  Backend services appear to be running."
else
  echo "  Some services may be missing. Tests may fail."
fi

# Quick health check on Kong
if curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:8080/" 2>/dev/null | grep -q "^[234]"; then
  echo "  Kong gateway reachable on port 8080."
else
  echo "  WARNING: Kong gateway not reachable on port 8080."
fi

# ── Step 6: Setup test users ────────────────────────────────────────────────
echo ""
echo "Step 6: Setting up test users..."

cd "$SCRIPT_DIR"
bash setup_test_users.sh

# ── Step 7: Install WS client dependencies ──────────────────────────────────
echo ""
echo "Step 7: Installing WS client dependencies..."

if [ ! -d "$SCRIPT_DIR/ws_client/node_modules" ]; then
  cd "$SCRIPT_DIR/ws_client" && npm install --silent
  echo "  Dependencies installed."
else
  echo "  Dependencies already installed."
fi

# ── Step 8: Run E2E tests ───────────────────────────────────────────────────
echo ""
echo "Step 8: Running E2E tests..."
echo ""

cd "$SCRIPT_DIR"
VERIFY_ARGS="--device $DEVICE"

if [ -n "$SCENARIO" ]; then
  VERIFY_ARGS="$VERIFY_ARGS --scenario $SCENARIO"
else
  VERIFY_ARGS="$VERIFY_ARGS --all"
fi

bash verify.sh $VERIFY_ARGS
EXIT_CODE=$?

# ── Step 9: Cleanup ─────────────────────────────────────────────────────────
echo ""
echo "Step 9: Cleaning up..."
bash cleanup.sh

# ── Done ────────────────────────────────────────────────────────────────────
echo ""
if [ "$EXIT_CODE" -eq 0 ]; then
  echo "╔══════════════════════════════════════════════════════════════╗"
  echo "║                    ALL TESTS PASSED ✓                       ║"
  echo "╚══════════════════════════════════════════════════════════════╝"
else
  echo "╔══════════════════════════════════════════════════════════════╗"
  echo "║                   SOME TESTS FAILED ✗                       ║"
  echo "╚══════════════════════════════════════════════════════════════╝"
fi

exit $EXIT_CODE
