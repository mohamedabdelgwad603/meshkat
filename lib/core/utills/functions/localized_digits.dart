import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

const List<String> _arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

// Converts the Western digits of a value to Arabic-Indic digits when the app language is Arabic.
String localizedDigits(BuildContext context, Object value) {
  final text = value.toString();
  if (context.locale.languageCode != 'ar') return text;
  return text.replaceAllMapped(RegExp(r'[0-9]'), (m) => _arabicDigits[int.parse(m[0]!)]);
}
