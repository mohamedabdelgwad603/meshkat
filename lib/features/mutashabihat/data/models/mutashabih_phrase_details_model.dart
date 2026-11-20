import 'package:mishkat/features/mutashabihat/data/models/mutashabih_ayah_model.dart';

// A phrase of the opened ayah with every other ayah it appears in.
class MutashabihPhraseDetailsModel {
  final String text;
  final int ayahCount;
  final int surahCount;
  final List<MutashabihAyahModel> otherAyahs;

  // Creates the phrase details.
  const MutashabihPhraseDetailsModel({
    required this.text,
    required this.ayahCount,
    required this.surahCount,
    required this.otherAyahs,
  });

  // Builds a placeholder for Skeletonizer loading states.
  factory MutashabihPhraseDetailsModel.dummy() => MutashabihPhraseDetailsModel(
        text: 'مِّن دُونِ ٱللَّهِ',
        ayahCount: 3,
        surahCount: 2,
        otherAyahs: [MutashabihAyahModel.dummy(), MutashabihAyahModel.dummy()],
      );
}

// The opened ayah with all its similar phrases highlighted, and each phrase's other ayahs.
class MutashabihatResultModel {
  final MutashabihAyahModel ayah;
  final List<MutashabihPhraseDetailsModel> phrases;

  // Creates the result.
  const MutashabihatResultModel({required this.ayah, required this.phrases});

  // Builds a placeholder for Skeletonizer loading states.
  factory MutashabihatResultModel.dummy() => MutashabihatResultModel(
        ayah: MutashabihAyahModel.dummy(),
        phrases: [MutashabihPhraseDetailsModel.dummy()],
      );
}
