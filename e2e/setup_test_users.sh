#!/usr/bin/env bash
# setup_test_users.sh — Provisions User A and User B for E2E tests.
# Authenticates both users via OTP and saves their tokens to .tokens.json.
set -euo pipefail

# ── Source helpers ──────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/api_helpers.sh"

TOKENS_FILE="${SCRIPT_DIR}/.tokens.json"

echo "=== QuckApp E2E — Setting up test users ==="

# ── User A ──────────────────────────────────────────────────────────
echo ""
echo "--- User A (${USER_A_PHONE}) ---"

echo "  Requesting OTP …"
request_otp "${USER_A_PHONE}" > /dev/null

echo "  Logging in …"
USER_A_RESPONSE="$(login_with_otp "${USER_A_PHONE}" "${TEST_OTP}")"

USER_A_TOKEN="$(extract_token "${USER_A_RESPONSE}")"
USER_A_ID="$(extract_user_id "${USER_A_RESPONSE}")"

if [[ -z "${USER_A_TOKEN}" || "${USER_A_TOKEN}" == "null" ]]; then
  echo "ERROR: Failed to obtain access token for User A." >&2
  echo "  Response: ${USER_A_RESPONSE}" >&2
  exit 1
fi

if [[ -z "${USER_A_ID}" || "${USER_A_ID}" == "null" ]]; then
  echo "WARNING: Could not extract user ID for User A. Token was obtained." >&2
  echo "  Response: ${USER_A_RESPONSE}" >&2
  USER_A_ID=""
fi

echo "  User A token: ${USER_A_TOKEN:0:20}…"
echo "  User A id:    ${USER_A_ID:-<unknown>}"

# ── User B ──────────────────────────────────────────────────────────
echo ""
echo "--- User B (${USER_B_PHONE}) ---"

echo "  Requesting OTP …"
request_otp "${USER_B_PHONE}" > /dev/null

echo "  Logging in …"
USER_B_RESPONSE="$(login_with_otp "${USER_B_PHONE}" "${TEST_OTP}")"

USER_B_TOKEN="$(extract_token "${USER_B_RESPONSE}")"
USER_B_ID="$(extract_user_id "${USER_B_RESPONSE}")"

if [[ -z "${USER_B_TOKEN}" || "${USER_B_TOKEN}" == "null" ]]; then
  echo "ERROR: Failed to obtain access token for User B." >&2
  echo "  Response: ${USER_B_RESPONSE}" >&2
  exit 1
fi

if [[ -z "${USER_B_ID}" || "${USER_B_ID}" == "null" ]]; then
  echo "WARNING: Could not extract user ID for User B. Token was obtained." >&2
  echo "  Response: ${USER_B_RESPONSE}" >&2
  USER_B_ID=""
fi

echo "  User B token: ${USER_B_TOKEN:0:20}…"
echo "  User B id:    ${USER_B_ID:-<unknown>}"

# ── Write .tokens.json ──────────────────────────────────────────────
echo ""
echo "--- Saving tokens to ${TOKENS_FILE} ---"

cat > "${TOKENS_FILE}" <<EOF
{
  "userA": {
    "id": "${USER_A_ID}",
    "phone": "${USER_A_PHONE}",
    "token": "${USER_A_TOKEN}"
  },
  "userB": {
    "id": "${USER_B_ID}",
    "phone": "${USER_B_PHONE}",
    "token": "${USER_B_TOKEN}"
  }
}
EOF

echo "  Saved."
echo ""
echo "=== Setup complete ==="
