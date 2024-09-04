import 'package:meta/meta.dart';

typedef Cache<V> = Map<String, _CacheValue<V>>;

/// A function type that represents an action to be taken when a cache entry expires.
typedef OnExpire = void Function();

typedef GroupId = String;

typedef Key = String;

/// A generic cache manager that supports time-based expiration and group-based management.
class CacheManager<V> {
  /// The internal cache storage.
  final _cache = <Key, _CacheValue<V>>{};

  /// Storage for keep-alive links, grouped by their identifiers.
  final _keepAliveLinks = <GroupId, KeepAliveLink>{};

  /// Retrieves a value from the cache.
  ///
  /// Returns the value associated with [key], or null if the key doesn't exist.
  V? get(Key key) => _cache[key]?.value;

  /// Sets a value in the cache and returns a [KeepAliveLink] for management.
  ///
  /// - [key]: The unique identifier for the cache entry.
  /// - [value]: The value to be stored in the cache.
  /// - [timeToLive]: Optional duration after which the entry will be automatically removed.
  /// - [groupId]: Optional identifier to group related cache entries so it returns a common [KeepAliveLink] which can then expire all the items in one go with the same [groupId].
  ///
  /// Returns a [KeepAliveLink] that can be used to manually expire the entry or its group.
  ///
  /// Examples:
  ///
  /// 1. Basic usage:
  ///    ```dart
  ///    final cache = CacheManager<String>();
  ///    cache.set('user_1', 'John Doe');
  ///    print(cache.get('user_1')); // Output: John Doe
  ///    ```
  ///
  /// 2. Using time-to-live (TTL):
  ///    ```dart
  ///    final cache = CacheManager<int>();
  ///    cache.set('score', 100, timeToLive: Duration(minutes: 5));
  ///    // The 'score' entry will be automatically removed after 5 minutes
  ///    ```
  ///
  /// 3. Using group expiry:
  ///    ```dart
  ///    final cache = CacheManager<String>();
  ///    final link1 = cache.set('temp1', 'value1', groupId: 'tempGroup');
  ///    final link2 = cache.set('temp2', 'value2', groupId: 'tempGroup');
  ///
  ///    // Later, expire all entries in the group:
  ///    link1.expire();
  ///    // Both 'temp1' and 'temp2' are now removed from the cache
  ///    ```
  ///
  /// 4. Combining TTL and group expiry:
  ///    ```dart
  ///    final cache = CacheManager<String>();
  ///    final link = cache.set('session_token', 'abc123',
  ///                           timeToLive: Duration(hours: 1),
  ///                           groupId: 'user_session');
  ///
  ///    // The entry will be removed after 1 hour or when manually expired:
  ///    // link.expire();
  ///    ```
  KeepAliveLink set(
    Key key,
    V value, {
    Duration? timeToLive,
    String? groupId,
  }) {
    final cacheValue = _CacheValue(value);
    _cache[key] = cacheValue;

    if (timeToLive != null) {
      Future.delayed(timeToLive, () {
        _cache.remove(key);
      });
    }

    if (groupId != null) return _resolveLink(key: key, groupId: groupId);

    return KeepAliveLink([() => _remove(key)]);
  }

  /// Resolves or creates a KeepAliveLink for a given key and group.
  ///
  /// If a link for the [groupId] already exists, it adds the expiration callback for [key].
  /// Otherwise, it creates a new link and associates it with the group.
  KeepAliveLink _resolveLink({
    required Key key,
    required GroupId groupId,
  }) {
    final _link = _keepAliveLinks[groupId];

    if (_link == null) {
      final link = _createLink(key);
      _keepAliveLinks[groupId] = link;

      return link;
    }

    _link.addOnExpire(() => _remove(key));

    return _link;
  }

  /// Creates a new KeepAliveLink for a given key.
  KeepAliveLink _createLink(Key key) => KeepAliveLink(
        [() => _remove(key)],
      );

  /// Removes an entry from the cache.
  void _remove(Key key) {
    _cache.remove(key);
  }
}

/// A wrapper class for cache values.
@immutable
class _CacheValue<V> {
  /// Creates a new cache value.
  const _CacheValue(this.value);

  /// The actual value stored in the cache.
  final V value;
}

/// A class that manages the expiration of cache entries or groups.
@immutable
class KeepAliveLink {
  /// Creates a new KeepAliveLink with the given expiration callbacks.
  const KeepAliveLink(this._onExpire);

  /// A list of callbacks to be executed when this link expires.
  final List<OnExpire> _onExpire;

  /// Triggers the expiration of this link, executing all registered callbacks.
  void expire() {
    for (final onExpire in _onExpire) {
      onExpire();
    }
  }

  /// Adds a new expiration callback to this link.
  void addOnExpire(OnExpire onExpire) {
    _onExpire.add(onExpire);
  }

  @override
  String toString() => 'KeepAliveLink{onExpire: $_onExpire}';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KeepAliveLink && other._onExpire == _onExpire;
  }

  @override
  int get hashCode => _onExpire.hashCode;
}
