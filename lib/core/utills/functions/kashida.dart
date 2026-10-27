// Arabic letters that connect to the letter after them.
const String _dualJoining = 'بتثجحخسشصضطظعغفقكلمنهيئىـ';

// Arabic letters that connect to the letter before them.
const String _rightJoining = 'بتثجحخسشصضطظعغفقكلمنهيئىـاأإآٱدذرزوؤة';

// Tatweel, the stroke that stretches the join between two letters.
const String tatweel = 'ـ';

// Tells whether a character is a mark that sits on the letter before it.
bool _isMark(int code) =>
    (code >= 0x064B && code <= 0x065F) || code == 0x0670 || (code >= 0x06D6 && code <= 0x06ED);

// Returns the positions in a word where a tatweel can be inserted, last join first; the name of Allah is never stretched.
List<int> kashidaPositions(String word) {
  final letters = String.fromCharCodes(word.codeUnits.where((c) => !_isMark(c)));
  if (letters.contains('لله')) return const [];
  final positions = <int>[];
  for (var i = 0; i < word.length; i++) {
    if (!_dualJoining.contains(word[i])) continue;
    var next = i + 1;
    while (next < word.length && _isMark(word.codeUnitAt(next))) {
      next++;
    }
    if (next >= word.length || !_rightJoining.contains(word[next])) continue;
    final lamAlef = word[i] == 'ل' && 'اأإآٱ'.contains(word[next]);
    if (!lamAlef) positions.add(next);
  }
  return positions.reversed.toList();
}

// Inserts the given number of tatweels at each position of a word.
String insertKashida(String word, Map<int, int> counts) {
  if (counts.isEmpty) return word;
  final buffer = StringBuffer();
  for (var i = 0; i < word.length; i++) {
    final count = counts[i] ?? 0;
    if (count > 0) buffer.write(tatweel * count);
    buffer.write(word[i]);
  }
  return buffer.toString();
}
