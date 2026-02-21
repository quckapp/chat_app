#!/usr/bin/env bash
# api_helpers.sh — Reusable bash functions for QuckApp E2E tests.
# Source this file from other test scripts.
set -euo pipefail

# ── Load environment ────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "${SCRIPT_DIR}/.env.test" ]]; then
  # Export every non-comment, non-empty line
  set -a
  # shellcheck disable=SC1091
  source "${SCRIPT_DIR}/.env.test"
  set +a
else
  echo "ERROR: ${SCRIPT_DIR}/.env.test not found" >&2
  exit 1
fi

# ── Retry helper ────────────────────────────────────────────────────
# Usage: retry <max_attempts> <delay_seconds> <command...>
# Retries a command up to N times with exponential backoff.
retry() {
  local max_attempts="${1:?missing max_attempts}"
  local delay="${2:?missing delay}"
  shift 2

  local attempt=1
  while true; do
    if "$@"; then
      return 0
    fi

    if (( attempt >= max_attempts )); then
      echo "ERROR: command failed after ${max_attempts} attempts: $*" >&2
      return 1
    fi

    echo "  retry ${attempt}/${max_attempts} — waiting ${delay}s …" >&2
    sleep "${delay}"
    delay=$(( delay * 2 ))
    (( attempt++ ))
  done
}

# ── Auth helpers ────────────────────────────────────────────────────

# request_otp <phone_number>
# Sends a POST to the request-otp endpoint.
request_otp() {
  local phone="${1:?missing phone number}"

  curl -s -w "\n%{http_code}" \
    -X POST "${KONG_URL}/api/auth/v1/auth/phone/request-otp" \
    -H "Content-Type: application/json" \
    -d "{\"phoneNumber\": \"${phone}\"}"
}

# login_with_otp <phone_number> <otp>
# Posts phone + OTP to the login endpoint. Returns the full JSON response body.
login_with_otp() {
  local phone="${1:?missing phone number}"
  local otp="${2:?missing otp}"

  curl -s \
    -X POST "${KONG_URL}/api/auth/v1/auth/phone/login" \
    -H "Content-Type: application/json" \
    -d "{\"phoneNumber\": \"${phone}\", \"otp\": \"${otp}\"}"
}

# extract_token <login_json>
# Extracts the access token from a login response using jq.
# Tries several common response shapes.
extract_token() {
  local json="${1:?missing json}"
  echo "${json}" | jq -r '.data.accessToken // .accessToken // .token // empty'
}

# extract_user_id <login_json>
# Extracts the user ID from a login response using jq.
extract_user_id() {
  local json="${1:?missing json}"
  echo "${json}" | jq -r '.data.user.id // .user.id // .userId // empty'
}

# ── Conversation helpers ────────────────────────────────────────────

# create_direct_conversation <auth_token> <participant_id>
# Creates a 1-on-1 (single) conversation.
create_direct_conversation() {
  local token="${1:?missing auth token}"
  local participant_id="${2:?missing participant id}"

  curl -s \
    -X POST "${KONG_URL}/api/v1/conversations/single" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${token}" \
    -d "{\"participantId\": \"${participant_id}\"}"
}

# get_conversations <auth_token>
# Lists all conversations for the authenticated user.
get_conversations() {
  local token="${1:?missing auth token}"

  curl -s \
    -X GET "${KONG_URL}/api/v1/conversations" \
    -H "Authorization: Bearer ${token}"
}

# get_messages <auth_token> <conversation_id>
# Fetches messages for a given conversation.
get_messages() {
  local token="${1:?missing auth token}"
  local conversation_id="${2:?missing conversation id}"

  curl -s \
    -X GET "${KONG_URL}/api/v1/conversations/${conversation_id}/messages" \
    -H "Authorization: Bearer ${token}"
}

# mark_read <auth_token> <conversation_id>
# Marks a conversation as read.
mark_read() {
  local token="${1:?missing auth token}"
  local conversation_id="${2:?missing conversation id}"

  curl -s \
    -X PUT "${KONG_URL}/api/v1/conversations/${conversation_id}/read" \
    -H "Authorization: Bearer ${token}"
}

# ── Call helpers ────────────────────────────────────────────────────

# get_call_history <auth_token>
# Retrieves the call history for the authenticated user.
get_call_history() {
  local token="${1:?missing auth token}"

  curl -s \
    -X GET "${KONG_URL}/api/v1/calls" \
    -H "Authorization: Bearer ${token}"
}

# ── Group helpers ──────────────────────────────────────────────────

# create_group_conversation <auth_token> <name> <participant_ids_json_array>
# Creates a group conversation with the given name and participant IDs.
# participant_ids should be a JSON array string like '["id1","id2"]'
create_group_conversation() {
  local token="${1:?missing auth token}"
  local name="${2:?missing group name}"
  local participant_ids="${3:?missing participant ids}"

  curl -s \
    -X POST "${KONG_URL}/api/v1/conversations/group" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${token}" \
    -d "{\"name\": \"${name}\", \"participantIds\": ${participant_ids}}"
}

# ── Message helpers ────────────────────────────────────────────────

# send_message_api <auth_token> <conversation_id> <content>
# Sends a text message via REST API (used for User B actions).
send_message_api() {
  local token="${1:?missing auth token}"
  local conversation_id="${2:?missing conversation id}"
  local content="${3:?missing message content}"

  curl -s \
    -X POST "${KONG_URL}/api/v1/conversations/${conversation_id}/messages" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${token}" \
    -d "{\"content\": \"${content}\", \"type\": \"text\"}"
}

# extract_message_id <messages_json>
# Extracts the first message ID from a get_messages response.
extract_message_id() {
  local json="${1:?missing json}"
  echo "${json}" | jq -r '.data[0].id // .[0].id // empty'
}

# extract_latest_message_id <messages_json>
# Extracts the latest (last) message ID from a get_messages response.
extract_latest_message_id() {
  local json="${1:?missing json}"
  echo "${json}" | jq -r '.data[-1].id // .[-1].id // empty'
}

# ── Reaction helpers ───────────────────────────────────────────────

# add_reaction <auth_token> <conversation_id> <message_id> <emoji>
# Adds a reaction to a message.
add_reaction() {
  local token="${1:?missing auth token}"
  local conversation_id="${2:?missing conversation id}"
  local message_id="${3:?missing message id}"
  local emoji="${4:?missing emoji}"

  curl -s \
    -X POST "${KONG_URL}/api/v1/conversations/${conversation_id}/messages/${message_id}/reactions" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${token}" \
    -d "{\"emoji\": \"${emoji}\"}"
}

# ── User/search helpers ───────────────────────────────────────────

# search_users <auth_token> <query>
# Searches for users by name or username.
search_users() {
  local token="${1:?missing auth token}"
  local query="${2:?missing search query}"

  curl -s \
    -X GET "${KONG_URL}/api/users/v1/search?q=${query}" \
    -H "Authorization: Bearer ${token}"
}

# ── Presence helpers ───────────────────────────────────────────────

# get_user_presence <auth_token> <user_id>
# Gets the online/offline status of a user.
get_user_presence() {
  local token="${1:?missing auth token}"
  local user_id="${2:?missing user id}"

  curl -s \
    -X GET "${KONG_URL}/api/v1/presence/${user_id}" \
    -H "Authorization: Bearer ${token}"
}
