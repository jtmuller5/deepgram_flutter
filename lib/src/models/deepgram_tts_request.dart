import 'dart:typed_data';

enum DeepgramAudioEncoding {
  linear16('linear16'),
  mulaw('mulaw'),
  alaw('alaw'),
  mp3('mp3'),
  opus('opus'),
  flac('flac'),
  aac('aac');

  const DeepgramAudioEncoding(this.value);
  final String value;
}

class DeepgramTtsRequest {
  final String text;
  final String model;
  final DeepgramAudioEncoding encoding;
  final int? bitRate;

  DeepgramTtsRequest({
    required this.text,
    this.model = 'aura-asteria-en',
    this.encoding = DeepgramAudioEncoding.mp3,
    this.bitRate,
  });

  Map<String, String> toQueryParameters() {
    final params = {
      'model': model,
      'encoding': encoding.value,
    };

    if (bitRate != null) {
      params['bit_rate'] = bitRate.toString();
    }

    return params;
  }
}