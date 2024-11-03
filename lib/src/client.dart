import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'live_tts_connection.dart';
import 'models/live_tts_event.dart';

/// Exception thrown when Deepgram API requests fail
class DeepgramException implements Exception {
  final String message;
  final int? statusCode;

  DeepgramException(this.message, {this.statusCode});

  @override
  String toString() => 'DeepgramException: $message (Status: $statusCode)';
}

/// Main client for interacting with Deepgram API
class DeepgramClient {
  final String apiKey;
  final String baseUrl;

  DeepgramClient({
    required this.apiKey,
    this.baseUrl = 'https://api.deepgram.com/v1',
  });

  /// Creates a live WebSocket connection for streaming TTS
  LiveTTSConnection createLiveConnection({String model = 'aura-asteria-en'}) {
    return LiveTTSConnection(apiKey, model: model);
  }

  /// Converts text to speech using REST API
  Future<Uint8List> textToSpeech({
    required String text,
    String model = 'aura-asteria-en',
    DeepgramAudioEncoding encoding = DeepgramAudioEncoding.mp3,
  }) async {
    final url = Uri.parse('$baseUrl/speak').replace(queryParameters: {
      'model': model,
      'encoding': encoding.value,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $apiKey',
        },
        body: jsonEncode({
          'text': text,
        }),
      );

      if (response.statusCode != 200) {
        throw DeepgramException(
          'Failed to convert text to speech',
          statusCode: response.statusCode,
        );
      }

      return response.bodyBytes;
    } catch (e) {
      throw DeepgramException(e.toString());
    }
  }
}
