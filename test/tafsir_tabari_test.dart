import 'package:flutter_test/flutter_test.dart';
import 'package:mishkat/core/api/end_points.dart';
import 'package:mishkat/features/tafsir/data/models/tafsir_model.dart';

// Checks that Quran.com tafsir HTML becomes clean paragraphs.
void main() {
  test('parses a Quran.com tafsir response into plain paragraphs', () {
    final model = TafsirModel.fromQuranComJson({
      'tafsir': {
        'verses': {
          '2:255': {'id': 262},
        },
        'text': '<p>القول في تأويل قوله تعالى :  اللَّهُ لا إِلَهَ إِلا هُوَ</p>'
            '<p>قال أبو جعفر: <span class="red">&quot; الله &quot;</span> <span class="arabic qpc-hafs green">(17)</span> .</p>'
            '<p>* * *</p>',
      },
    }, edition: EndPoints.tabariTafsir);
    expect(model.surahNumber, 2);
    expect(model.ayahNumber, 255);
    expect(model.edition, EndPoints.tabariTafsir);
    expect(model.text, 'القول في تأويل قوله تعالى : اللَّهُ لا إِلَهَ إِلا هُوَ\n\nقال أبو جعفر: " الله " (17) .\n\n* * *');
  });
}
