// Strips Arabic diacritics and unifies letter forms so searches ignore tashkeel.
String normalizeArabic(String input) {
  return input
      .replaceAll(RegExp(r'[ؐ-ًؚ-ٰٟۖ-ۭـ]'), '')
      .replaceAll(RegExp(r'[ٱأإآ]'), 'ا')
      .replaceAll('ة', 'ه')
      .replaceAll('ى', 'ي')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim()
      .toLowerCase();
}

// Converts Arabic-Indic digits in a string to Western digits.
String toWesternDigits(String input) =>
    input.replaceAllMapped(RegExp('[٠-٩]'), (m) => (m[0]!.codeUnitAt(0) - 0x0660).toString());
