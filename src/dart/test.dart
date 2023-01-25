import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Class', () {
    test('throws', () async {
      expect(() => throw Exception(), throwsA(isA<Exception>()));
    });
    test('does not throw', () async {
      expect(() => 5, returnsNormally);
    });

		testWidgets("widget", (tester) async {
      await tester.pumpWidget(Container());
			await tester.pumpAndSettle();
			await tester.binding.setSurfaceSize(kScreenSize);
			await tester.drag(find.byKey(dragKey), moveByOffset);
    });
  });
}
