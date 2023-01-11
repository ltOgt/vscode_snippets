import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Class', () {
    test('function', () async {
      expect([[1]], equals([[1]]));
      expect(() => throw Exception(), throwsA(isA<Exception>()));
    });
  });
}
