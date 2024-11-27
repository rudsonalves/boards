import 'package:flutter_test/flutter_test.dart';
import 'package:boards/core/utils/utils.dart';

void main() {
  group('Utils.title', () {
    test('Converts single word to title case', () {
      expect(Utils.title('hello'), 'Hello');
    });

    test('Converts multiple words to title case', () {
      expect(Utils.title('hello world'), 'Hello World');
    });

    test('Handles leading and trailing spaces', () {
      expect(Utils.title('  hello world  '), 'Hello World');
    });

    test('Handles multiple spaces between words', () {
      expect(Utils.title('hello   world'), 'Hello   World');
    });

    test('Handles mixed case input', () {
      expect(Utils.title('hElLo WoRLd'), 'Hello World');
    });

    test('Handles empty string', () {
      expect(Utils.title(''), '');
    });

    test('Handles string with only spaces', () {
      expect(Utils.title('   '), '');
    });

    test('Handles string with special characters', () {
      expect(Utils.title('hello-world'), 'Hello-world');
      expect(Utils.title('hello_world'), 'Hello_world');
    });

    test('Handles string with numeric characters', () {
      expect(Utils.title('hello123 world456'), 'Hello123 World456');
      expect(Utils.title('hello123 456world'), 'Hello123 456world');
    });
  });
}
