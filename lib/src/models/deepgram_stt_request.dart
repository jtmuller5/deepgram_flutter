/// Request parameters for speech-to-text conversion
class DeepgramSttRequest {
  /// The text to be converted
  final String? url;
  
  /// Raw audio data as bytes
  final List<int>? audioData;
  
  /// The model to use for transcription
  final String model;
  
  /// Whether to apply smart formatting to the output
  final bool smartFormat;
  
  /// Creates a new speech-to-text request
  DeepgramSttRequest({
    this.url,
    this.audioData,
    this.model = 'nova-2',
    this.smartFormat = true,
  }) : assert(url != null || audioData != null, 'Either url or audioData must be provided');
  
  /// Converts the request parameters to a query parameter map
  Map<String, String> toQueryParameters() {
    return {
      'model': model,
      'smart_format': smartFormat.toString(),
    };
  }
}

/// Response from the speech-to-text API
class DeepgramSttResponse {
  /// The transcribed text
  final String text;
  
  /// Raw response data from the API
  final Map<String, dynamic> rawResponse;
  
  /// Creates a new speech-to-text response
  DeepgramSttResponse({
    required this.text,
    required this.rawResponse,
  });
  
  /// Creates a response from JSON data
  factory DeepgramSttResponse.fromJson(Map<String, dynamic> json) {
    return DeepgramSttResponse(
      text: json['results']['channels'][0]['alternatives'][0]['transcript'],
      rawResponse: json,
    );
  }
}