// A phrase that recurs across the Quran with the word ranges where it appears in each ayah.
class MutashabihPhraseModel {
  final int id;
  final String text;
  final String sourceKey;
  final Map<String, List<(int, int)>> ayahs;

  // Creates the phrase.
  const MutashabihPhraseModel({required this.id, required this.text, required this.sourceKey, required this.ayahs});

  // Parses the phrase from the bundled mutashabihat JSON.
  factory MutashabihPhraseModel.fromJson(Map<String, dynamic> json) => MutashabihPhraseModel(
        id: json['id'] as int,
        text: json['text'] as String,
        sourceKey: json['source'] as String,
        ayahs: {
          for (final entry in (json['ayahs'] as Map<String, dynamic>).entries)
            entry.key: [
              for (final range in entry.value as List<dynamic>) ((range as List<dynamic>)[0] as int, range[1] as int),
            ],
        },
      );

  // Returns how many different surahs the phrase appears in.
  int get surahCount => ayahs.keys.map((k) => k.split(':').first).toSet().length;

  // Builds a placeholder phrase for Skeletonizer loading states.
  factory MutashabihPhraseModel.dummy() => const MutashabihPhraseModel(
        id: 0,
        text: 'مِّن دُونِ ٱللَّهِ',
        sourceKey: '2:23',
        ayahs: {
          '2:23': [(15, 17)],
          '2:107': [(11, 13)],
        },
      );
}
