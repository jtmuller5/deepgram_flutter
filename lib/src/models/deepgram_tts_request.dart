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

/// Supported container formats for Deepgram TTS audio output
enum DeepgramContainer {
  /// WAV container format
  wav('wav'),

  /// MP3 container format
  mp3('mp3'),

  /// OGG container format
  ogg('ogg'),

  /// No container format (for WebSocket streaming)
  none('none');

  const DeepgramContainer(this.value);
  final String value;
}

/// A request object for Deepgram's Text-to-Speech API that encapsulates
/// all parameters needed for speech synthesis.
///
/// This class handles configuration for:
/// * Text input to be converted to speech
/// * Model selection (e.g. 'aura-asteria-en')
/// * Audio encoding format (mp3, wav, etc.)
/// * Container format for audio output
/// * Bit rate for audio output
/// * Sample rate in Hz
///
/// Example usage:
/// ```dart
/// final request = DeepgramTtsRequest(
///   text: 'Hello world',
///   model: 'aura-asteria-en',
///   encoding: DeepgramAudioEncoding.mp3,
///   container: DeepgramContainer.mp3,
///   bitRate: 32000,
///   sampleRate: 24000,
/// );
/// ```
class DeepgramTtsRequest {
  /// The text to convert to speech
  final String text;

  /// The model to use for speech synthesis
  final String model;

  /// The audio encoding format
  final DeepgramAudioEncoding encoding;

  /// The container format for the audio output
  final DeepgramContainer? container;

  /// The bit rate for audio output (optional)
  final int? bitRate;

  /// The sample rate in Hz for the audio output (optional)
  final int? sampleRate;

  DeepgramTtsRequest({
    required this.text,
    this.model = 'aura-asteria-en',
    this.encoding = DeepgramAudioEncoding.mp3,
    this.container,
    this.bitRate,
    this.sampleRate,
  });

  /// Converts the request parameters to query parameters for the API
  Map<String, String> toQueryParameters() {
    final params = {
      'model': model,
      'encoding': encoding.value,
    };

    if (bitRate != null) {
      params['bit_rate'] = bitRate.toString();
    }

    if (container != null) {
      params['container'] = container!.value;
    }

    if (sampleRate != null) {
      params['sample_rate'] = sampleRate.toString();
    }

    return params;
  }
}
