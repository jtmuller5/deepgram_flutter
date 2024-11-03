import 'dart:convert';
import 'dart:typed_data';
import 'package:deepgram_flutter/deepgram_flutter.dart';
import 'package:deepgram_flutter/src/live_stt_connection.dart';
import 'package:http/http.dart' as http;

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

  /// Creates a live transcription connection for streaming audio
  LiveSTTConnection createLiveTranscriptionConnection({
    LiveTranscriptionConfig? config,
  }) {
    return LiveSTTConnection(apiKey, config: config);
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

  /// Converts speech to text using the Deepgram API
  Future<DeepgramSttResponse> speechToText(DeepgramSttRequest request) async {
    final url = Uri.parse('$baseUrl/listen').replace(
      queryParameters: request.toQueryParameters(),
    );

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Token $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          request.url != null ? {'url': request.url} : {'buffer': base64Encode(request.audioData!)},
        ),
      );

      if (response.statusCode != 200) {
        throw DeepgramException(
          'Failed to convert speech to text',
          statusCode: response.statusCode,
        );
      }

      return DeepgramSttResponse.fromJson(
        jsonDecode(response.body),
      );
    } catch (e) {
      throw DeepgramException(e.toString());
    }
  }
}
