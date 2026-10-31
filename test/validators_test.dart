import 'package:flutter_test/flutter_test.dart';
import 'package:tablet_store/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('accepts a valid email', () {
      expect(Validators.email('user@example.com'), isNull);
    });
    test('rejects empty and malformed values', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('not-an-email'), isNotNull);
    });
  });

  group('Validators.password', () {
    test('requires at least 6 characters', () {
      expect(Validators.password('12345'), isNotNull);
      expect(Validators.password('123456'), isNull);
    });
  });

  group('Validators.price', () {
    test('accepts positive numbers only', () {
      expect(Validators.price('99.5'), isNull);
      expect(Validators.price('0'), isNotNull);
      expect(Validators.price('abc'), isNotNull);
      expect(Validators.price(''), isNotNull);
    });
  });

  group('Validators.imageUrl', () {
    test('accepts http(s) URLs only', () {
      expect(Validators.imageUrl('https://example.com/a.png'), isNull);
      expect(Validators.imageUrl('ftp://example.com/a.png'), isNotNull);
      expect(Validators.imageUrl('just text'), isNotNull);
    });
  });
}
