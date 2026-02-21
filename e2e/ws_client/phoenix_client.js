"use strict";

const WebSocket = require("ws");

/**
 * PhoenixTestClient — A minimal Phoenix v2 WebSocket client for E2E testing.
 *
 * Phoenix v2 wire protocol uses JSON arrays (not objects):
 *   [join_ref, ref, topic, event, payload]
 *
 * This client implements the protocol directly for full control over
 * the connection lifecycle, channel joins, heartbeats, and event handling.
 */
class PhoenixTestClient {
  /**
   * @param {string} wsUrl  — Base WebSocket URL, e.g. ws://127.0.0.1:8090/socket/websocket
   * @param {string} token  — Auth token appended as query parameter
   */
  constructor(wsUrl, token) {
    this.wsUrl = `${wsUrl}?token=${encodeURIComponent(token)}&vsn=2.0.0`;
    this.token = token;
    this.ws = null;
    this._ref = 0;
    this._joinRef = 0;
    this._heartbeatTimer = null;
    this._pendingReplies = new Map(); // ref -> { resolve, reject, topic }
    this._eventListeners = [];        // [{ topic, event, resolve, once }]
    this._receivedEvents = [];        // [{ joinRef, ref, topic, event, payload }]
    this._joinedTopics = new Map();   // topic -> joinRef
  }

  /**
   * Returns the next ref as a string (incrementing counter).
   * @returns {string}
   */
  nextRef() {
    this._ref += 1;
    return String(this._ref);
  }

  /**
   * Returns the next join ref as a string (incrementing counter).
   * @returns {string}
   */
  _nextJoinRef() {
    this._joinRef += 1;
    return String(this._joinRef);
  }

  /**
   * Opens the WebSocket connection to the Phoenix server.
   * Starts the heartbeat interval upon successful connection.
   *
   * @returns {Promise<void>} Resolves when the connection is open.
   */
  connect() {
    return new Promise((resolve, reject) => {
      const timeout = setTimeout(() => {
        reject(new Error("WebSocket connection timed out after 10s"));
      }, 10000);

      this.ws = new WebSocket(this.wsUrl);

      this.ws.on("open", () => {
        clearTimeout(timeout);
        this._startHeartbeat();
        resolve();
      });

      this.ws.on("error", (err) => {
        clearTimeout(timeout);
        reject(new Error(`WebSocket connection error: ${err.message}`));
      });

      this.ws.on("close", (code, reason) => {
        clearTimeout(timeout);
        this._stopHeartbeat();
      });

      this.ws.on("message", (data) => {
        this._handleMessage(data);
      });
    });
  }

  /**
   * Sends a heartbeat message every 30 seconds.
   * Phoenix expects: [null, ref, "phoenix", "heartbeat", {}]
   */
  _startHeartbeat() {
    this._heartbeatTimer = setInterval(() => {
      if (this.ws && this.ws.readyState === WebSocket.OPEN) {
        const ref = this.nextRef();
        const msg = JSON.stringify([null, ref, "phoenix", "heartbeat", {}]);
        this.ws.send(msg);
      }
    }, 30000);
  }

  /**
   * Stops the heartbeat interval.
   */
  _stopHeartbeat() {
    if (this._heartbeatTimer) {
      clearInterval(this._heartbeatTimer);
      this._heartbeatTimer = null;
    }
  }

  /**
   * Parses and dispatches an incoming Phoenix v2 message.
   * Format: [join_ref, ref, topic, event, payload]
   *
   * @param {Buffer|string} raw — Raw WebSocket message data
   */
  _handleMessage(raw) {
    let parsed;
    try {
      parsed = JSON.parse(raw.toString());
    } catch (err) {
      console.error("[PhoenixTestClient] Failed to parse message:", raw.toString());
      return;
    }

    if (!Array.isArray(parsed) || parsed.length !== 5) {
      console.error("[PhoenixTestClient] Unexpected message format:", parsed);
      return;
    }

    const [joinRef, ref, topic, event, payload] = parsed;

    // Skip heartbeat replies — they are not interesting for tests.
    if (topic === "phoenix" && event === "phx_reply") {
      return;
    }

    // Store every non-heartbeat event for later inspection.
    const eventRecord = { joinRef, ref, topic, event, payload };
    this._receivedEvents.push(eventRecord);

    // Resolve pending phx_reply promises (channel join acknowledgements, etc.)
    if (event === "phx_reply" && ref && this._pendingReplies.has(ref)) {
      const pending = this._pendingReplies.get(ref);
      this._pendingReplies.delete(ref);

      if (payload && payload.status === "ok") {
        pending.resolve(payload);
      } else {
        pending.reject(
          new Error(
            `Channel reply error on topic "${topic}": ${JSON.stringify(payload)}`
          )
        );
      }
      return;
    }

    // Handle phx_error for pending joins
    if (event === "phx_error" && ref && this._pendingReplies.has(ref)) {
      const pending = this._pendingReplies.get(ref);
      this._pendingReplies.delete(ref);
      pending.reject(
        new Error(
          `Channel error on topic "${topic}": ${JSON.stringify(payload)}`
        )
      );
      return;
    }

    // Notify waiting event listeners.
    this._notifyListeners(eventRecord);
  }

  /**
   * Walks through registered event listeners and resolves those that match.
   * Once-listeners are removed after being resolved.
   *
   * @param {{ topic: string, event: string, payload: any }} eventRecord
   */
  _notifyListeners(eventRecord) {
    const remaining = [];
    for (const listener of this._eventListeners) {
      if (
        listener.topic === eventRecord.topic &&
        listener.event === eventRecord.event
      ) {
        listener.resolve(eventRecord.payload);
        // Once-listeners are consumed; don't keep them.
        if (!listener.once) {
          remaining.push(listener);
        }
      } else {
        remaining.push(listener);
      }
    }
    this._eventListeners = remaining;
  }

  /**
   * Joins a Phoenix channel on the given topic.
   *
   * Sends: [joinRef, ref, topic, "phx_join", payload]
   * Waits for: [joinRef, ref, topic, "phx_reply", { status: "ok", ... }]
   *
   * @param {string} topic   — Channel topic, e.g. "chat:abc123"
   * @param {object} payload — Optional join payload (default {})
   * @returns {Promise<object>} Resolves with the reply payload on success.
   */
  joinChannel(topic, payload = {}) {
    return new Promise((resolve, reject) => {
      const joinRef = this._nextJoinRef();
      const ref = this.nextRef();

      const timeout = setTimeout(() => {
        this._pendingReplies.delete(ref);
        reject(new Error(`Join timed out after 10s for topic "${topic}"`));
      }, 10000);

      this._pendingReplies.set(ref, {
        resolve: (replyPayload) => {
          clearTimeout(timeout);
          this._joinedTopics.set(topic, joinRef);
          resolve(replyPayload);
        },
        reject: (err) => {
          clearTimeout(timeout);
          reject(err);
        },
        topic,
      });

      const msg = JSON.stringify([joinRef, ref, topic, "phx_join", payload]);
      this.ws.send(msg);
    });
  }

  /**
   * Waits for a specific event on a topic. Checks already-received events first,
   * then registers a listener for future events.
   *
   * @param {string} topic      — Channel topic to listen on
   * @param {string} eventName  — Event name to wait for
   * @param {number} timeoutMs  — Maximum wait time in milliseconds (default 10000)
   * @returns {Promise<object>} Resolves with the event payload.
   */
  waitForEvent(topic, eventName, timeoutMs = 10000) {
    // Check if we already received this event.
    const existing = this._receivedEvents.find(
      (e) => e.topic === topic && e.event === eventName
    );
    if (existing) {
      return Promise.resolve(existing.payload);
    }

    return new Promise((resolve, reject) => {
      const timeout = setTimeout(() => {
        // Remove this listener on timeout.
        this._eventListeners = this._eventListeners.filter(
          (l) => l !== listener
        );
        reject(
          new Error(
            `Timed out waiting ${timeoutMs}ms for event "${eventName}" on topic "${topic}"`
          )
        );
      }, timeoutMs);

      const listener = {
        topic,
        event: eventName,
        once: true,
        resolve: (payload) => {
          clearTimeout(timeout);
          resolve(payload);
        },
      };

      this._eventListeners.push(listener);
    });
  }

  /**
   * Collects all events on a topic for a given duration.
   *
   * @param {string} topic       — Channel topic to collect from
   * @param {number} durationMs  — Collection window in milliseconds (default 5000)
   * @returns {Promise<Array<{ event: string, payload: any }>>}
   */
  collectEvents(topic, durationMs = 5000) {
    return new Promise((resolve) => {
      const collected = [];

      // Grab any already-received events for this topic.
      for (const e of this._receivedEvents) {
        if (e.topic === topic) {
          collected.push({ event: e.event, payload: e.payload });
        }
      }

      // Register a persistent (non-once) listener that captures everything on this topic.
      // We use a wildcard approach: match any event on the topic.
      const captureListener = {
        topic,
        event: null, // null means "match all events on this topic"
        once: false,
        resolve: (payload, event) => {
          collected.push({ event, payload });
        },
      };

      // Override _notifyListeners behavior for wildcard matching.
      // We temporarily patch the notification to also handle null-event listeners.
      const origNotify = this._notifyListeners.bind(this);
      this._notifyListeners = (eventRecord) => {
        // Feed our collector for any event on the target topic.
        if (eventRecord.topic === topic) {
          collected.push({
            event: eventRecord.event,
            payload: eventRecord.payload,
          });
        }
        origNotify(eventRecord);
      };

      setTimeout(() => {
        // Restore original notification handler.
        this._notifyListeners = origNotify;
        resolve(collected);
      }, durationMs);
    });
  }

  /**
   * Sends a message/event on a joined channel.
   *
   * @param {string} topic   — Channel topic
   * @param {string} event   — Event name to push
   * @param {object} payload — Event payload
   * @returns {string} The ref of the sent message
   */
  push(topic, event, payload = {}) {
    const joinRef = this._joinedTopics.get(topic) || null;
    const ref = this.nextRef();
    const msg = JSON.stringify([joinRef, ref, topic, event, payload]);
    this.ws.send(msg);
    return ref;
  }

  /**
   * Disconnects the WebSocket and cleans up resources.
   */
  disconnect() {
    this._stopHeartbeat();

    // Reject any pending replies.
    for (const [ref, pending] of this._pendingReplies) {
      pending.reject(new Error("Client disconnected"));
    }
    this._pendingReplies.clear();

    // Clear listeners.
    this._eventListeners = [];

    if (this.ws) {
      if (
        this.ws.readyState === WebSocket.OPEN ||
        this.ws.readyState === WebSocket.CONNECTING
      ) {
        this.ws.close(1000, "Client disconnect");
      }
      this.ws = null;
    }
  }
}

module.exports = { PhoenixTestClient };
