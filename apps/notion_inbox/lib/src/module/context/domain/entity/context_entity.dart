// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:smart_textfield/smart_textfield.dart';

@immutable
class ContextEntity implements Tokenable {
  const ContextEntity({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  String get prefix => throw UnimplementedError();

  @override
  String get stringValue => throw UnimplementedError();

  @override
  String toString() => 'ContextEntity(id: $id, name: $name)';

  @override
  bool operator ==(covariant ContextEntity other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
