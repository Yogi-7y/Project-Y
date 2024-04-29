// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'token.dart';

// ignore: avoid_implementing_value_types
class TokenableString implements Tokenable {
  const TokenableString(this.value);

  final String value;

  @override
  String get stringValue => value;

  @override
  String toString() => 'TokenableString(value: $value)';

  @override
  bool operator ==(covariant TokenableString other) {
    if (identical(this, other)) return true;

    return other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
