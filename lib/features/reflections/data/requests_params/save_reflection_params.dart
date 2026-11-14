// The ayah a reflection is written on and the text the user typed.
class SaveReflectionParams {
  final int surahNumber;
  final String surahName;
  final String surahEnglishName;
  final int ayahNumber;
  final String ayahText;
  final String note;

  // Creates the params.
  const SaveReflectionParams({
    required this.surahNumber,
    required this.surahName,
    required this.surahEnglishName,
    required this.ayahNumber,
    required this.ayahText,
    required this.note,
  });

  // Returns a copy with a different note.
  SaveReflectionParams copyWithNote(String newNote) => SaveReflectionParams(
        surahNumber: surahNumber,
        surahName: surahName,
        surahEnglishName: surahEnglishName,
        ayahNumber: ayahNumber,
        ayahText: ayahText,
        note: newNote,
      );

  // Serializes the params.
  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'surahName': surahName,
        'surahEnglishName': surahEnglishName,
        'ayahNumber': ayahNumber,
        'ayahText': ayahText,
        'note': note,
      };
}
