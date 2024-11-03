import 'dart:async';
import 'dart:convert';
import 'package:deepgram_flutter/src/models/metadata.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class LiveTTSConnection {
  final IOWebSocketChannel _channel;
  final _audioController = StreamController<List<int>>.broadcast();
  final _metadataController = StreamController<TTSMetadata>.broadcast();
  final _errorController = StreamController<String>.broadcast();

  Stream<List<int>> get audioStream => _audioController.stream;
  Stream<TTSMetadata> get metadataStream => _metadataController.stream;
  Stream<String> get errorStream => _errorController.stream;

  LiveTTSConnection(String apiKey, {String model = 'aura-asteria-en'})
      : _channel = IOWebSocketChannel.connect(
          Uri.parse('wss://api.deepgram.com/v1/speak?model=$model'),
          headers: {'Authorization': 'Token $apiKey'},
        ) {
    _setupListeners();
  }

  void _setupListeners() {
    _channel.stream.listen(
      (data) {
        if (data is List<int>) {
          _audioController.add(data);
        } else {
          final jsonData = jsonDecode(data);
          if (jsonData['type'] == 'metadata') {
            _metadataController.add(TTSMetadata.fromJson(jsonData));
          }
        }
      },
      onError: (error) => _errorController.add(error.toString()),
      onDone: () => close(),
    );
  }

  void sendText(String text) {
    _channel.sink.add(jsonEncode({'text': text}));
  }

  void flush() {
    _channel.sink.add(jsonEncode({'type': 'flush'}));
  }

  Future<void> close() async {
    await _channel.sink.close(status.goingAway);
    await _audioController.close();
    await _metadataController.close();
    await _errorController.close();
  }
}
