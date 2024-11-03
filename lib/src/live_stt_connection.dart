import 'dart:async';
import 'dart:convert';

import 'package:deepgram_flutter/deepgram_flutter.dart';
import 'package:web_socket_channel/io.dart';

/// Events emitted by the live transcription connection
enum LiveTranscriptionEvent {
  /// Connection is opened
  open,

  /// Connection is closed
  close,

  /// Transcription data received
  transcript,

  /// Metadata received
  metadata,

  /// Error occurred
  error,
}

/// Configuration for live transcription
class LiveTranscriptionConfig {
  /// The model to use for transcription
  final String model;

  /// The language to transcribe
  final String language;

  /// Whether to apply smart formatting
  final bool smartFormat;

  /// Creates a new live transcription configuration
  const LiveTranscriptionConfig({
    this.model = 'nova-2',
    this.language = 'en-US',
    this.smartFormat = true,
  });

  /// Converts config to query parameters
  Map<String, String> toQueryParameters() => {
        'model': model,
        'language': language,
        'smart_format': smartFormat.toString(),
      };
}

/// Handles live speech-to-text transcription via WebSocket
class LiveSTTConnection {
  final String _apiKey;
  final LiveTranscriptionConfig _config;
  IOWebSocketChannel? _socket;
  final _eventController = StreamController<dynamic>.broadcast();

  /// Creates a new live transcription connection
  LiveSTTConnection(
    this._apiKey, {
    LiveTranscriptionConfig? config,
  }) : _config = config ?? const LiveTranscriptionConfig();

  /// Stream of transcription events
  Stream<dynamic> get events => _eventController.stream;

  /// Connects to the Deepgram WebSocket API
  Future<void> connect() async {
    final uri = Uri.parse('wss://api.deepgram.com/v1/listen').replace(queryParameters: _config.toQueryParameters());

    try {
      _socket = IOWebSocketChannel.connect(
        uri.toString(),
        headers: {'Authorization': 'Token $_apiKey'},
      );

      _eventController.add(LiveTranscriptionEvent.open);

      _socket!.stream.listen(
        (data) {
          final json = jsonDecode(data);
          if (json['type'] == 'Results') {
            _eventController.add({
              'event': LiveTranscriptionEvent.transcript,
              'data': json,
            });
          } else if (json['type'] == 'Metadata') {
            _eventController.add({
              'event': LiveTranscriptionEvent.metadata,
              'data': json,
            });
          }
        },
        onError: (error) {
          _eventController.add({
            'event': LiveTranscriptionEvent.error,
            'error': error.toString(),
          });
        },
        onDone: () {
          _eventController.add(LiveTranscriptionEvent.close);
        },
      );
    } catch (e) {
      _eventController.add({
        'event': LiveTranscriptionEvent.error,
        'error': e.toString(),
      });
    }
  }

  /// Sends audio data to be transcribed
  void send(List<int> audioData) {
    if (_socket == null) {
      throw DeepgramException('Connection not established');
    }
    _socket!.sink.add(audioData);
  }

  /// Closes the connection
  Future<void> close() async {
    await _socket?.sink.close();
    await _eventController.close();
  }
}
