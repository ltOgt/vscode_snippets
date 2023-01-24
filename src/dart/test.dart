import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Class', () {
    test('function', () async {
      expect(() => throw Exception(), throwsA(isA<Exception>()));
    });
		testWidgets("widget", (tester) async {
      await tester.pumpWidget(Container());
    });
  });
}
