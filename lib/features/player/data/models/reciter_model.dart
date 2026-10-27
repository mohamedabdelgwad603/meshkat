import 'package:equatable/equatable.dart';

// A verse-by-verse recitation edition (a reciter).
class ReciterModel extends Equatable {
  final String identifier;
  final String name;
  final String englishName;

  // Creates the reciter model.
  const ReciterModel({required this.identifier, required this.name, required this.englishName});

  // Parses a reciter from the API JSON.
  factory ReciterModel.fromJson(Map<String, dynamic> json) => ReciterModel(
        identifier: json['identifier'] as String,
        name: (json['name'] as String? ?? '').trim(),
        englishName: (json['englishName'] as String? ?? '').trim(),
      );

  // Serializes the reciter for the local cache.
  Map<String, dynamic> toJson() => {'identifier': identifier, 'name': name, 'englishName': englishName};

  // Builds the default reciter, also used as a Skeletonizer placeholder.
  factory ReciterModel.dummy() =>
      const ReciterModel(identifier: 'ar.alafasy', name: 'مشاري راشد العفاسي', englishName: 'Alafasy');

  // Returns the name suited to the current language.
  String displayName(bool isArabic) => isArabic || englishName.isEmpty ? name : englishName;

  // Returns the first letter of the name for the avatar.
  String initial(bool isArabic) {
    final source = displayName(isArabic).trim();
    return source.isEmpty ? '' : String.fromCharCode(source.runes.first);
  }

  // Lists the fields used for equality.
  @override
  List<Object?> get props => [identifier];
}
