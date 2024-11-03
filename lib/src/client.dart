import 'dart:convert';
import 'dart:typed_data';
import 'package:deepgram_flutter/src/models/deepgram_tts_request.dart';
import 'package:http/http.dart' as http;
import 'live_tts_connection.dart';
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
  Future<Uint8List> textToSpeech(DeepgramTtsRequest request) async {
    final url = Uri.parse('$baseUrl/speak').replace(queryParameters: request.toQueryParameters());

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $apiKey',
        },
        body: jsonEncode({
          'text': request.text,
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
