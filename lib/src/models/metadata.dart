class TTSMetadata {
  final String requestId;
  final int duration;
  final int characters;
  
  TTSMetadata({
    required this.requestId,
    required this.duration,
    required this.characters,
  });

  factory TTSMetadata.fromJson(Map<String, dynamic> json) {
    return TTSMetadata(
      requestId: json['request_id'],
      duration: json['duration'],
      characters: json['characters'],
    );
  }
}