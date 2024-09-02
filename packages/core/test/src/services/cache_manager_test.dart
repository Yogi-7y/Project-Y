// ignore_for_file: unused_local_variable, cascade_invocations

import 'package:core_y/src/services/cache_manager.dart';
import 'package:test/test.dart';

void main() {
  late CacheManager<String> cacheManager;

  setUp(() {
    cacheManager = CacheManager<String>();
  });

  group('Basic operations', () {
    test('Set and get value', () {
      cacheManager.set('key1', 'value1');
      expect(cacheManager.get('key1'), equals('value1'));
    });

    test('Get non-existent key returns null', () {
      expect(cacheManager.get('non-existent'), isNull);
    });

    test('Overwrite existing value', () {
      cacheManager
        ..set('key1', 'value1')
        ..set('key1', 'value2');
      expect(cacheManager.get('key1'), equals('value2'));
    });
  });

  group('Time-to-live', () {
    test('Value expires after time-to-live', () async {
      cacheManager.set('key1', 'value1', timeToLive: const Duration(milliseconds: 50));
      expect(cacheManager.get('key1'), equals('value1'));

      await Future<void>.delayed(const Duration(milliseconds: 60));
      expect(cacheManager.get('key1'), isNull);
    });

    test('Value without time-to-live does not expire', () async {
      cacheManager.set('key1', 'value1');
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(cacheManager.get('key1'), equals('value1'));
    });
  });

  group('Group-based cache management', () {
    test('Group-based expiration', () {
      final link1 = cacheManager.set('key1', 'value1', groupId: 'group1');
      final link2 = cacheManager.set('key2', 'value2', groupId: 'group1');
      cacheManager.set('key3', 'value3', groupId: 'group2');

      expect(cacheManager.get('key1'), equals('value1'));
      expect(cacheManager.get('key2'), equals('value2'));
      expect(cacheManager.get('key3'), equals('value3'));

      print('before expire');
      link1.expire();
      print('after expire');

      expect(cacheManager.get('key1'), isNull);
      expect(cacheManager.get('key2'), isNull);
      expect(cacheManager.get('key3'), equals('value3'));
    });

    test('Multiple groups', () {
      final link1 = cacheManager.set('key1', 'value1', groupId: 'group1');
      final link2 = cacheManager.set('key2', 'value2', groupId: 'group2');

      link1.expire();

      expect(cacheManager.get('key1'), isNull);
      expect(cacheManager.get('key2'), equals('value2'));
    });

    test('Adding to existing group', () {
      final link1 = cacheManager.set('key1', 'value1', groupId: 'group1');
      final link2 = cacheManager.set('key2', 'value2', groupId: 'group1');

      expect(link1, equals(link2));

      link1.expire();

      expect(cacheManager.get('key1'), isNull);
      expect(cacheManager.get('key2'), isNull);
    });
  });

  group('KeepAliveLink', () {
    test('KeepAliveLink expiration', () {
      var expired = false;
      final link = KeepAliveLink([() => expired = true]);

      link.expire();

      expect(expired, isTrue);
    });

    test('Adding multiple expiration callbacks', () {
      var count = 0;
      final link = KeepAliveLink([() => count++]);
      link.addOnExpire(() => count++);

      link.expire();

      expect(count, equals(2));
    });
  });

  group('Edge cases and error handling', () {
    test('Set with empty string value', () {
      cacheManager.set('key1', '');
      expect(cacheManager.get('key1'), equals(''));
    });

    test('Expire non-existent group', () {
      const link = KeepAliveLink([]);
      expect(() => link.expire(), returnsNormally);
    });
  });
}
