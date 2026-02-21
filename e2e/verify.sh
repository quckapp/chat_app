#!/bin/bash
# E2E Test Orchestrator
#
# Orchestrates Maestro UI flows (Device A) with WebSocket/API verification (Device B).
#
# Usage:
#   bash verify.sh --device emulator-5554 --scenario 01
#   bash verify.sh --device emulator-5554 --all
#
# Prerequisites:
#   - Android emulator running with app installed
#   - Backend services running (Kong, go-bff, realtime-service, etc.)
#   - Node.js installed (for WS client)
#   - Maestro CLI installed
#   - Run setup_test_users.sh first

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="$(dirname "$SCRIPT_DIR")"
MAESTRO_DIR="$APP_DIR/.maestro"
WS_CLIENT_DIR="$SCRIPT_DIR/ws_client"

source "$SCRIPT_DIR/api_helpers.sh"

# ── Parse args ────────────────────────────────────────────────────────────────
DEVICE=""
SCENARIO=""
RUN_ALL=false
PASSED=0
FAILED=0
SKIPPED=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --device) DEVICE="$2"; shift 2 ;;
    --scenario) SCENARIO="$2"; shift 2 ;;
    --all) RUN_ALL=true; shift ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

if [ -z "$DEVICE" ]; then
  DEVICE=$(adb devices | grep "emulator" | head -1 | awk '{print $1}')
  if [ -z "$DEVICE" ]; then
    echo "ERROR: No emulator found. Start one with: maestro start-device --platform android"
    exit 1
  fi
  echo "Auto-detected device: $DEVICE"
fi

# ── Load tokens ───────────────────────────────────────────────────────────────
TOKENS_FILE="$SCRIPT_DIR/.tokens.json"
if [ ! -f "$TOKENS_FILE" ]; then
  echo "Tokens not found. Running setup..."
  bash "$SCRIPT_DIR/setup_test_users.sh"
fi

TOKEN_B=$(jq -r '.userB.token' "$TOKENS_FILE")
USER_B_ID=$(jq -r '.userB.id' "$TOKENS_FILE")
TOKEN_A=$(jq -r '.userA.token' "$TOKENS_FILE")
USER_A_ID=$(jq -r '.userA.id' "$TOKENS_FILE")

# ── Install WS deps if needed ────────────────────────────────────────────────
if [ ! -d "$WS_CLIENT_DIR/node_modules" ]; then
  echo "Installing WS client dependencies..."
  cd "$WS_CLIENT_DIR" && npm install --silent && cd "$SCRIPT_DIR"
fi

# ── Scenario runner ───────────────────────────────────────────────────────────

run_scenario() {
  local num="$1"
  local name="$2"
  local ws_scenario="$3"
  local needs_conv="$4"

  echo ""
  echo "================================================================"
  echo "  Scenario $num: $name"
  echo "================================================================"

  local conv_id=""

  # Create conversation if needed
  if [ "$needs_conv" = "true" ]; then
    echo "Creating DM conversation between User A and User B..."
    local conv_resp
    conv_resp=$(create_direct_conversation "$TOKEN_A" "$USER_B_ID")
    conv_id=$(echo "$conv_resp" | jq -r '.data.id // .id // empty')

    if [ -z "$conv_id" ] || [ "$conv_id" = "null" ]; then
      echo "WARNING: Could not create conversation, trying to find existing..."
      local convs
      convs=$(get_conversations "$TOKEN_A")
      conv_id=$(echo "$convs" | jq -r '.data[0].id // .[0].id // empty')
    fi

    if [ -z "$conv_id" ] || [ "$conv_id" = "null" ]; then
      echo "SKIP: Could not get conversation ID"
      SKIPPED=$((SKIPPED + 1))
      return
    fi
    echo "Conversation ID: $conv_id"
  fi

  # Start WS listener in background
  local ws_args="--scenario $ws_scenario"
  [ -n "$conv_id" ] && ws_args="$ws_args --conv-id $conv_id"

  echo "Starting WebSocket listener (scenario: $ws_scenario)..."
  node "$WS_CLIENT_DIR/verify_events.js" $ws_args &
  local WS_PID=$!

  # Give WS client time to connect and join channels
  sleep 3

  # Run Maestro flow
  echo "Running Maestro flow: ${num}_*.yaml on $DEVICE..."
  local maestro_flow="$MAESTRO_DIR/e2e/${num}_*.yaml"
  local maestro_file
  maestro_file=$(ls $maestro_flow 2>/dev/null | head -1)

  if [ -z "$maestro_file" ]; then
    echo "SKIP: No Maestro flow found matching $maestro_flow"
    kill $WS_PID 2>/dev/null || true
    SKIPPED=$((SKIPPED + 1))
    return
  fi

  if maestro --device "$DEVICE" test "$maestro_file"; then
    echo "Maestro flow passed."
  else
    echo "Maestro flow FAILED."
    kill $WS_PID 2>/dev/null || true
    FAILED=$((FAILED + 1))
    return
  fi

  # Wait for WS verification to complete (max 30s)
  local ws_exit=0
  if wait $WS_PID; then
    echo "WebSocket verification PASSED."
  else
    ws_exit=$?
    echo "WebSocket verification FAILED (exit: $ws_exit)."
  fi

  # REST API double-check
  if [ -n "$conv_id" ] && [ "$ws_scenario" = "text_chat" ]; then
    echo "API verification: checking messages..."
    local msgs
    msgs=$(get_messages "$TOKEN_B" "$conv_id")
    local msg_count
    msg_count=$(echo "$msgs" | jq '.data | length // 0')
    if [ "$msg_count" -gt 0 ]; then
      echo "API verification PASSED: $msg_count messages found."
    else
      echo "API verification WARNING: No messages found via API."
    fi
  fi

  if [ "$ws_exit" -eq 0 ]; then
    PASSED=$((PASSED + 1))
  else
    FAILED=$((FAILED + 1))
  fi
}

# ── Scenario runner with User B action ─────────────────────────────────────────
# For scenarios where User B must ACT (not just listen) after Device A sends.
# E.g., scenario 04 (read receipts): User B marks read after receiving message.
# E.g., scenario 05 (reactions): User B adds reaction after receiving message.

run_scenario_with_user_b_action() {
  local num="$1"
  local name="$2"
  local ws_scenario="$3"
  local needs_conv="$4"
  local user_b_action="$5"

  echo ""
  echo "================================================================"
  echo "  Scenario $num: $name (with User B action: $user_b_action)"
  echo "================================================================"

  local conv_id=""

  # Create conversation if needed
  if [ "$needs_conv" = "true" ]; then
    echo "Creating DM conversation between User A and User B..."
    local conv_resp
    conv_resp=$(create_direct_conversation "$TOKEN_A" "$USER_B_ID")
    conv_id=$(echo "$conv_resp" | jq -r '.data.id // .id // empty')

    if [ -z "$conv_id" ] || [ "$conv_id" = "null" ]; then
      echo "WARNING: Could not create conversation, trying to find existing..."
      local convs
      convs=$(get_conversations "$TOKEN_A")
      conv_id=$(echo "$convs" | jq -r '.data[0].id // .[0].id // empty')
    fi

    if [ -z "$conv_id" ] || [ "$conv_id" = "null" ]; then
      echo "SKIP: Could not get conversation ID"
      SKIPPED=$((SKIPPED + 1))
      return
    fi
    echo "Conversation ID: $conv_id"
  fi

  # Start WS listener in background
  local ws_args="--scenario $ws_scenario --conv-id $conv_id"

  echo "Starting WebSocket listener (scenario: $ws_scenario)..."
  node "$WS_CLIENT_DIR/verify_events.js" $ws_args &
  local WS_PID=$!

  sleep 3

  # Run Maestro flow (Device A sends message)
  echo "Running Maestro flow: ${num}_*.yaml on $DEVICE..."
  local maestro_flow="$MAESTRO_DIR/e2e/${num}_*.yaml"
  local maestro_file
  maestro_file=$(ls $maestro_flow 2>/dev/null | head -1)

  if [ -z "$maestro_file" ]; then
    echo "SKIP: No Maestro flow found matching $maestro_flow"
    kill $WS_PID 2>/dev/null || true
    SKIPPED=$((SKIPPED + 1))
    return
  fi

  if maestro --device "$DEVICE" test "$maestro_file"; then
    echo "Maestro flow passed."
  else
    echo "Maestro flow FAILED."
    kill $WS_PID 2>/dev/null || true
    FAILED=$((FAILED + 1))
    return
  fi

  # Wait briefly for message to propagate
  sleep 2

  # Perform User B action via REST API
  echo "Performing User B action: $user_b_action..."
  case "$user_b_action" in
    mark_read)
      mark_read "$TOKEN_B" "$conv_id"
      echo "User B marked conversation as read."
      ;;
    add_reaction)
      # Get the latest message ID first
      local msgs
      msgs=$(get_messages "$TOKEN_B" "$conv_id")
      local msg_id
      msg_id=$(echo "$msgs" | jq -r '.data[-1].id // .[-1].id // empty')
      if [ -n "$msg_id" ] && [ "$msg_id" != "null" ]; then
        add_reaction "$TOKEN_B" "$conv_id" "$msg_id" "👍"
        echo "User B added 👍 reaction to message $msg_id."
      else
        echo "WARNING: Could not find message ID for reaction."
      fi
      ;;
    *)
      echo "WARNING: Unknown User B action: $user_b_action"
      ;;
  esac

  # Wait for WS verification to complete
  local ws_exit=0
  if wait $WS_PID; then
    echo "WebSocket verification PASSED."
  else
    ws_exit=$?
    echo "WebSocket verification FAILED (exit: $ws_exit)."
  fi

  if [ "$ws_exit" -eq 0 ]; then
    PASSED=$((PASSED + 1))
  else
    FAILED=$((FAILED + 1))
  fi
}

# ── Execute scenarios ─────────────────────────────────────────────────────────

if [ "$RUN_ALL" = "true" ] || [ "$SCENARIO" = "01" ]; then
  run_scenario "01" "Two-User Text Chat" "text_chat" "true"
fi

if [ "$RUN_ALL" = "true" ] || [ "$SCENARIO" = "02" ]; then
  run_scenario "02" "Group Messaging" "group_message" "true"
fi

if [ "$RUN_ALL" = "true" ] || [ "$SCENARIO" = "03" ]; then
  run_scenario "03" "Typing Indicators" "typing" "true"
fi

if [ "$RUN_ALL" = "true" ] || [ "$SCENARIO" = "04" ]; then
  run_scenario_with_user_b_action "04" "Read Receipts" "read_receipt" "true" "mark_read"
fi

if [ "$RUN_ALL" = "true" ] || [ "$SCENARIO" = "05" ]; then
  run_scenario_with_user_b_action "05" "Message Reactions" "reaction" "true" "add_reaction"
fi

if [ "$RUN_ALL" = "true" ] || [ "$SCENARIO" = "06" ]; then
  run_scenario "06" "Image Attachment" "image_attachment" "true"
fi

if [ "$RUN_ALL" = "true" ] || [ "$SCENARIO" = "07" ]; then
  run_scenario "07" "Presence Online" "presence" "false"
fi

if [ "$RUN_ALL" = "true" ] || [ "$SCENARIO" = "08" ]; then
  run_scenario "08" "Call Initiation" "call" "true"
fi

if [ "$RUN_ALL" = "true" ] || [ "$SCENARIO" = "09" ]; then
  run_scenario "09" "Disappearing Messages" "disappearing_messages" "true"
fi

if [ "$RUN_ALL" = "true" ] || [ "$SCENARIO" = "10" ]; then
  run_scenario "10" "File Sharing" "file_sharing" "true"
fi

if [ "$RUN_ALL" = "true" ] || [ "$SCENARIO" = "11" ]; then
  run_scenario "11" "Message Reply" "message_reply" "true"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "================================================================"
echo "  E2E Results: $PASSED passed, $FAILED failed, $SKIPPED skipped"
echo "================================================================"

if [ "$FAILED" -gt 0 ]; then
  exit 1
fi
