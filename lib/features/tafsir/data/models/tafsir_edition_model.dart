import 'package:equatable/equatable.dart';

// One tafsir book available from the API.
class TafsirEditionModel extends Equatable {
  final String identifier;
  final String name;
  final String englishName;

  // Creates the edition model.
  const TafsirEditionModel({required this.identifier, required this.name, required this.englishName});

  // Parses an edition from the API JSON.
  factory TafsirEditionModel.fromJson(Map<String, dynamic> json) => TafsirEditionModel(
        identifier: json['identifier'] as String,
        name: (json['name'] as String? ?? '').trim(),
        englishName: (json['englishName'] as String? ?? '').trim(),
      );

  // Serializes the edition for the local cache.
  Map<String, dynamic> toJson() => {'identifier': identifier, 'name': name, 'englishName': englishName};

  // Builds a placeholder edition for Skeletonizer loading states.
  factory TafsirEditionModel.dummy() =>
      const TafsirEditionModel(identifier: 'ar.muyassar', name: 'تفسير الميسر', englishName: 'Al-Muyassar');

  // Returns a short chip label, dropping the leading word "تفسير".
  String label(bool isArabic) {
    if (!isArabic && englishName.isNotEmpty) return englishName.replaceFirst(RegExp(r'^Tafsir\s+', caseSensitive: false), '');
    return name.replaceFirst(RegExp(r'^تفسير\s+'), '');
  }

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [identifier];
}
