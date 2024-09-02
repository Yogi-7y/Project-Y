import 'package:meta/meta.dart';

typedef Cache<V> = Map<String, _CacheValue<V>>;
typedef OnExpire = void Function();
typedef GroupId = String;
typedef Key = String;

class CacheManager<V> {
  final _cache = <Key, _CacheValue<V>>{};
  final _keepAliveLinks = <GroupId, KeepAliveLink>{};

  V? get(Key key) => _cache[key]?.value;

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

  KeepAliveLink _createLink(Key key) => KeepAliveLink(
        [() => _remove(key)],
      );

  void _remove(Key key) {
    _cache.remove(key);
  }
}

@immutable
class _CacheValue<V> {
  const _CacheValue(this.value);

  final V value;
}

@immutable
class KeepAliveLink {
  const KeepAliveLink(this._onExpire);
  final List<OnExpire> _onExpire;

  void expire() {
    for (final onExpire in _onExpire) {
      onExpire();
    }
  }

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
