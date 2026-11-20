// The phrase whose ayahs are requested.
class MutashabihPhraseParams {
  final int phraseId;

  // Creates the params.
  const MutashabihPhraseParams({required this.phraseId});

  // Serializes the params.
  Map<String, dynamic> toJson() => {'phraseId': phraseId};
}
