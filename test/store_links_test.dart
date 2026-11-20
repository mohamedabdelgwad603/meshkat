import 'package:flutter_test/flutter_test.dart';
import 'package:mishkat/features/settings/data/models/store_links_model.dart';

// Checks which store links are kept for sharing.
void main() {
  test('keeps full store links and drops a bare domain or an empty value', () {
    final links = StoreLinksModel.fromJson({
      'android': ' https://play.google.com/store/apps/details?id=com.mishkat.mishkat ',
      'ios': 'https://apps.apple.com',
    });
    expect(links.android, 'https://play.google.com/store/apps/details?id=com.mishkat.mishkat');
    expect(links.ios, isEmpty);
    expect(links.hasAny, isTrue);
    expect(StoreLinksModel.fromJson({'android': '', 'ios': 'not a link'}).hasAny, isFalse);
    expect(StoreLinksModel.fromJson({'ios': 'https://apps.apple.com/app/id123456789'}).ios, isNotEmpty);
  });
}
