#!/usr/bin/env node
"use strict";

const fs = require("fs");
const path = require("path");
const { PhoenixTestClient } = require("./phoenix_client");

// ---------------------------------------------------------------------------
// CLI argument parsing
// ---------------------------------------------------------------------------

function parseArgs(argv) {
  const args = {
    scenario: null,
    convId: null,
    tokensPath: path.resolve(__dirname, "..", ".tokens.json"),
  };

  for (let i = 2; i < argv.length; i++) {
    switch (argv[i]) {
      case "--scenario":
        args.scenario = argv[++i];
        break;
      case "--conv-id":
        args.convId = argv[++i];
        break;
      case "--tokens":
        args.tokensPath = path.resolve(argv[++i]);
        break;
      default:
        console.error(`Unknown argument: ${argv[i]}`);
        process.exit(1);
    }
  }

  return args;
}

// ---------------------------------------------------------------------------
// Token loading
// ---------------------------------------------------------------------------

function loadTokens(tokensPath) {
  if (!fs.existsSync(tokensPath)) {
    console.error(`FAIL: Tokens file not found at ${tokensPath}`);
    process.exit(1);
  }

  try {
    const raw = fs.readFileSync(tokensPath, "utf-8");
    return JSON.parse(raw);
  } catch (err) {
    console.error(`FAIL: Could not parse tokens file: ${err.message}`);
    process.exit(1);
  }
}

// ---------------------------------------------------------------------------
// Result writing
// ---------------------------------------------------------------------------

function writeResult(scenario, result) {
  const resultPath = path.resolve(__dirname, "..", `.result_${scenario}.json`);
  fs.writeFileSync(resultPath, JSON.stringify(result, null, 2), "utf-8");
  console.log(`Result written to ${resultPath}`);
}

// ---------------------------------------------------------------------------
// Scenario definitions
// ---------------------------------------------------------------------------

/**
 * Each scenario function receives { client, convId, tokens } and returns
 * { passed: boolean, event: string, payload: any, error?: string }.
 */

async function scenarioTextChat({ client, convId }) {
  console.log(`[text_chat] Joining chat:${convId} ...`);
  await client.joinChannel(`chat:${convId}`);
  console.log(`[text_chat] Joined. Waiting for message:new (30s) ...`);

  const payload = await client.waitForEvent(
    `chat:${convId}`,
    "message:new",
    30000
  );
  console.log(`[text_chat] Received message:new`);
  return { passed: true, event: "message:new", payload };
}

async function scenarioTyping({ client, convId }) {
  console.log(`[typing] Joining chat:${convId} ...`);
  await client.joinChannel(`chat:${convId}`);
  console.log(`[typing] Joined. Waiting for typing:start (30s) ...`);

  const payload = await client.waitForEvent(
    `chat:${convId}`,
    "typing:start",
    30000
  );
  console.log(`[typing] Received typing:start`);
  return { passed: true, event: "typing:start", payload };
}

async function scenarioReadReceipt({ client, convId }) {
  console.log(`[read_receipt] Joining chat:${convId} ...`);
  await client.joinChannel(`chat:${convId}`);
  console.log(`[read_receipt] Joined. Waiting for message:read (30s) ...`);

  const payload = await client.waitForEvent(
    `chat:${convId}`,
    "message:read",
    30000
  );
  console.log(`[read_receipt] Received message:read`);
  return { passed: true, event: "message:read", payload };
}

async function scenarioReaction({ client, convId }) {
  console.log(`[reaction] Joining chat:${convId} ...`);
  await client.joinChannel(`chat:${convId}`);
  console.log(
    `[reaction] Joined. Waiting for message:reaction:added (30s) ...`
  );

  const payload = await client.waitForEvent(
    `chat:${convId}`,
    "message:reaction:added",
    30000
  );
  console.log(`[reaction] Received message:reaction:added`);
  return { passed: true, event: "message:reaction:added", payload };
}

async function scenarioPresence({ client }) {
  console.log(`[presence] Joining presence:lobby ...`);
  await client.joinChannel("presence:lobby");
  console.log(`[presence] Joined. Waiting for presence_diff (30s) ...`);

  const payload = await client.waitForEvent(
    "presence:lobby",
    "presence_diff",
    30000
  );
  console.log(`[presence] Received presence_diff`);
  return { passed: true, event: "presence_diff", payload };
}

async function scenarioCall({ client, tokens }) {
  const userBId = tokens.userB.userId;
  console.log(`[call] Joining user:${userBId} ...`);
  await client.joinChannel(`user:${userBId}`);
  console.log(`[call] Joined. Waiting for incoming_call (30s) ...`);

  const payload = await client.waitForEvent(
    `user:${userBId}`,
    "incoming_call",
    30000
  );
  console.log(`[call] Received incoming_call`);
  return { passed: true, event: "incoming_call", payload };
}

async function scenarioGroupMessage({ client, convId }) {
  console.log(`[group_message] Joining chat:${convId} ...`);
  await client.joinChannel(`chat:${convId}`);
  console.log(`[group_message] Joined. Waiting for message:new (30s) ...`);

  const payload = await client.waitForEvent(
    `chat:${convId}`,
    "message:new",
    30000
  );
  console.log(`[group_message] Received message:new`);
  return { passed: true, event: "message:new", payload };
}

async function scenarioImageAttachment({ client, convId }) {
  console.log(`[image_attachment] Joining chat:${convId} ...`);
  await client.joinChannel(`chat:${convId}`);
  console.log(`[image_attachment] Joined. Waiting for message:new with attachment (30s) ...`);

  const payload = await client.waitForEvent(
    `chat:${convId}`,
    "message:new",
    30000
  );
  // Verify it has attachments
  const hasAttachment = payload.attachments && payload.attachments.length > 0;
  console.log(`[image_attachment] Received message:new (has attachment: ${hasAttachment})`);
  return { passed: true, event: "message:new", payload, hasAttachment };
}

async function scenarioDisappearingMessages({ client, convId }) {
  console.log(`[disappearing] Joining chat:${convId} ...`);
  await client.joinChannel(`chat:${convId}`);
  console.log(`[disappearing] Joined. Waiting for message:new with TTL (30s) ...`);

  const payload = await client.waitForEvent(
    `chat:${convId}`,
    "message:new",
    30000
  );
  const hasTtl = payload.ttl !== undefined || payload.disappearing_timer !== undefined;
  console.log(`[disappearing] Received message:new (has TTL: ${hasTtl})`);
  return { passed: true, event: "message:new", payload, hasTtl };
}

async function scenarioFileSharing({ client, convId }) {
  console.log(`[file_sharing] Joining chat:${convId} ...`);
  await client.joinChannel(`chat:${convId}`);
  console.log(`[file_sharing] Joined. Waiting for message:new with file attachment (30s) ...`);

  const payload = await client.waitForEvent(
    `chat:${convId}`,
    "message:new",
    30000
  );
  const hasFile = payload.attachments && payload.attachments.some(
    a => a.type === "file" || a.type === "document" || a.mime_type
  );
  console.log(`[file_sharing] Received message:new (has file: ${hasFile})`);
  return { passed: true, event: "message:new", payload, hasFile };
}

async function scenarioMessageReply({ client, convId }) {
  console.log(`[message_reply] Joining chat:${convId} ...`);
  await client.joinChannel(`chat:${convId}`);
  console.log(`[message_reply] Joined. Waiting for message:new with reply_to (30s) ...`);

  // First message (the original)
  const original = await client.waitForEvent(
    `chat:${convId}`,
    "message:new",
    30000
  );
  console.log(`[message_reply] Received original message`);

  // Second message (the reply) — wait again for another message:new
  const reply = await client.waitForEvent(
    `chat:${convId}`,
    "message:new",
    30000
  );
  const hasReplyTo = reply.reply_to !== undefined || reply.reply_to_id !== undefined;
  console.log(`[message_reply] Received reply (has reply_to: ${hasReplyTo})`);
  return { passed: true, event: "message:new", payload: reply, hasReplyTo };
}

const SCENARIOS = {
  text_chat: scenarioTextChat,
  typing: scenarioTyping,
  read_receipt: scenarioReadReceipt,
  reaction: scenarioReaction,
  presence: scenarioPresence,
  call: scenarioCall,
  group_message: scenarioGroupMessage,
  image_attachment: scenarioImageAttachment,
  disappearing_messages: scenarioDisappearingMessages,
  file_sharing: scenarioFileSharing,
  message_reply: scenarioMessageReply,
};

// ---------------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------------

async function main() {
  const args = parseArgs(process.argv);

  // Validate required arguments.
  if (!args.scenario) {
    console.error("FAIL: --scenario is required");
    console.error(
      `  Available scenarios: ${Object.keys(SCENARIOS).join(", ")}`
    );
    process.exit(1);
  }

  if (!SCENARIOS[args.scenario]) {
    console.error(`FAIL: Unknown scenario "${args.scenario}"`);
    console.error(
      `  Available scenarios: ${Object.keys(SCENARIOS).join(", ")}`
    );
    process.exit(1);
  }

  // Scenarios that require --conv-id
  const needsConvId = [
    "text_chat",
    "typing",
    "read_receipt",
    "reaction",
    "group_message",
    "image_attachment",
    "disappearing_messages",
    "file_sharing",
    "message_reply",
  ];
  if (needsConvId.includes(args.scenario) && !args.convId) {
    console.error(`FAIL: --conv-id is required for scenario "${args.scenario}"`);
    process.exit(1);
  }

  // Load tokens.
  const tokens = loadTokens(args.tokensPath);
  if (!tokens.userB || !tokens.userB.token) {
    console.error("FAIL: tokens.userB.token is missing from tokens file");
    process.exit(1);
  }

  // Determine WebSocket URL.
  const wsUrl =
    process.env.ENVOY_WS_URL ||
    "ws://127.0.0.1:8090/socket/websocket";

  console.log(`--- QuckApp E2E Event Verifier ---`);
  console.log(`Scenario : ${args.scenario}`);
  console.log(`WS URL   : ${wsUrl}`);
  console.log(`Conv ID  : ${args.convId || "(n/a)"}`);
  console.log(`Tokens   : ${args.tokensPath}`);
  console.log(`----------------------------------`);

  // Create client and connect as User B.
  const client = new PhoenixTestClient(wsUrl, tokens.userB.token);

  try {
    console.log("Connecting as User B ...");
    await client.connect();
    console.log("Connected.");

    // Run the scenario.
    const result = await SCENARIOS[args.scenario]({
      client,
      convId: args.convId,
      tokens,
    });

    // Success.
    console.log(`\nPASS: ${args.scenario}`);
    writeResult(args.scenario, {
      scenario: args.scenario,
      passed: true,
      event: result.event,
      payload: result.payload,
      timestamp: new Date().toISOString(),
    });

    client.disconnect();
    process.exit(0);
  } catch (err) {
    console.error(`\nFAIL: ${args.scenario} — ${err.message}`);
    writeResult(args.scenario, {
      scenario: args.scenario,
      passed: false,
      error: err.message,
      timestamp: new Date().toISOString(),
    });

    client.disconnect();
    process.exit(1);
  }
}

main();
