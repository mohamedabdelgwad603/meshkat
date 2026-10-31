// Filters for the /edition endpoint.
class EditionsParams {
  final String format;
  final String? type;
  final String language;

  // Creates the filters.
  const EditionsParams({required this.format, this.type, this.language = 'ar'});

  // Arabic tafsir books.
  static const EditionsParams arabicTafsir = EditionsParams(format: 'text', type: 'tafsir');

  // All Arabic recitations, of every type.
  static const EditionsParams arabicRecitations = EditionsParams(format: 'audio');

  // Serializes the filters as query parameters.
  Map<String, dynamic> toJson() => {'format': format, if (type != null) 'type': type, 'language': language};
}
