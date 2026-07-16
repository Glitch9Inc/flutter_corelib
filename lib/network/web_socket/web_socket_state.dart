import 'dart:io';

enum WebSocketState {
  disconnected('Not connected to the WebSocket server.'),
  connecting('Connecting to the WebSocket server...'),
  connected('Connected to the WebSocket server.'),
  receivingStart('Receiving data from the WebSocket server...'),
  receivingEnd('Finished receiving data from the WebSocket server.'),
  error('An error occurred during WebSocket communication.');

  final String stateText;
  const WebSocketState(this.stateText);
}

abstract mixin class WebSocketStateListener {
  /// Called when the WebSocket state changes.
  void onWebSocketStateChanged(WebSocketState state);

  /// Called when the WebSocket connection is established.
  void onWebSocketConnected() {
    onWebSocketStateChanged(WebSocketState.connected);
  }

  /// Called when the WebSocket server sends a 'start' message.
  void onReceivingDataStarted(String requestId) {
    onWebSocketStateChanged(WebSocketState.receivingStart);
  }

  /// Called when the WebSocket server sends an 'end' message.
  void onReceivingDataCompleted(String requestId) {
    onWebSocketStateChanged(WebSocketState.receivingEnd);
  }

  /// Called when an error occurs in the WebSocket connection.
  void onWebSocketError(dynamic error) {
    onWebSocketStateChanged(WebSocketState.error);
  }

  /// Called when the WebSocket connection is closed.
  String onWebSocketClosed(int closeCode) {
    onWebSocketStateChanged(WebSocketState.disconnected);
    return _getCloseReason(closeCode);
  }

  /// Called when a WebSocket request times out.
  void onWebSocketRequestTimeout() {
    onWebSocketStateChanged(WebSocketState.error);
  }

  static String _getCloseReason(int code) {
    switch (code) {
      case WebSocketStatus.normalClosure:
        return 'WebSocket closed normally.';
      case WebSocketStatus.goingAway:
        return 'WebSocket closed because the server is going away.';
      case WebSocketStatus.protocolError:
        return 'WebSocket closed due to protocol error.';
      case WebSocketStatus.unsupportedData:
        return 'WebSocket closed because the server received unsupported data.';
      case WebSocketStatus.reserved1004:
        return 'WebSocket closed with reserved code 1004.';
      case WebSocketStatus.noStatusReceived:
        return 'WebSocket closed without receiving a status code.';
      case WebSocketStatus.abnormalClosure:
        return 'WebSocket closed abnormally.';
      case WebSocketStatus.invalidFramePayloadData:
        return 'WebSocket closed due to invalid frame payload data.';
      case WebSocketStatus.policyViolation:
        return 'WebSocket closed due to policy violation.';
      case WebSocketStatus.messageTooBig:
        return 'WebSocket closed because the message was too big.';
      case WebSocketStatus.missingMandatoryExtension:
        return 'WebSocket closed because a mandatory extension was missing.';
      case WebSocketStatus.internalServerError:
        return 'WebSocket closed due to internal server error.';
      case WebSocketStatus.reserved1015:
        return 'WebSocket closed with reserved code 1015.';
      default:
        return 'WebSocket closed with unknown code: $code';
    }
  }
}
