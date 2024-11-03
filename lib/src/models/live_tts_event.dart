enum LiveTTSEvent { open, close, metadata, audio, flushed, error }

/// https://developers.deepgram.com/docs/models-languages-overview
enum DeepgramModel {
  // Nova-2 Models
  nova2General('nova-2'),
  nova2Meeting('nova-2-meeting'),
  nova2Phonecall('nova-2-phonecall'),
  nova2Finance('nova-2-finance'),
  nova2ConversationalAi('nova-2-conversationalai'),
  nova2Voicemail('nova-2-voicemail'),
  nova2Video('nova-2-video'),
  nova2Medical('nova-2-medical'),
  nova2Drivethru('nova-2-drivethru'),
  nova2Automotive('nova-2-automotive'),
  nova2Atc('nova-2-atc'),
  nova2Custom('nova-2-custom'),

  // Nova Models
  novaGeneral('nova'),
  novaPhonecall('nova-phonecall'),
  novaMedical('nova-medical'),
  novaCustom('nova-custom'),

  // Enhanced Models
  enhancedGeneral('enhanced'),
  enhancedMeeting('enhanced-meeting'),
  enhancedPhonecall('enhanced-phonecall'),
  enhancedFinance('enhanced-finance'),
  enhancedCustom('enhanced-custom'),

  // Base Models
  baseGeneral('base'),
  baseMeeting('base-meeting'),
  basePhonecall('base-phonecall'),
  baseFinance('base-finance'),
  baseConversationalAi('base-conversationalai'),
  baseVoicemail('base-voicemail'),
  baseVideo('base-video'),
  baseCustom('base-custom'),

  // Whisper Models
  whisperTiny('whisper-tiny'),
  whisperBase('whisper-base'),
  whisperSmall('whisper-small'),
  whisperMedium('whisper'),
  whisperLarge('whisper-large');

  const DeepgramModel(this.value);
  final String value;
}

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
