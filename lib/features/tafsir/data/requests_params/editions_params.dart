// Filters for the /edition endpoint.
class EditionsParams {
  final String format;
  final String type;
  final String language;

  // Creates the filters.
  const EditionsParams({required this.format, required this.type, this.language = 'ar'});

  // Arabic tafsir books.
  static const EditionsParams arabicTafsir = EditionsParams(format: 'text', type: 'tafsir');

  // Arabic verse-by-verse recitations.
  static const EditionsParams arabicRecitations = EditionsParams(format: 'audio', type: 'versebyverse');

  // Serializes the filters as query parameters.
  Map<String, dynamic> toJson() => {'format': format, 'type': type, 'language': language};
}
