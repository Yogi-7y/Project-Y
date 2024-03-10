// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:meta/meta.dart';

@immutable
class Term {
  Term({
    required this.term,
    required this.definition,
    required this.description,
  });

  /// Term or a phrase.
  final String term;

  /// Definition of the term.\
  /// Should be small and concise.
  final String definition;

  /// Any extra information about the term.\
  /// Can include examples, references, etc.
  final String description;

  @override
  String toString() => 'Term(term: $term, definition: $definition, description: $description)';

  @override
  bool operator ==(covariant Term other) {
    if (identical(this, other)) return true;

    return other.term == term && other.definition == definition && other.description == description;
  }

  @override
  int get hashCode => term.hashCode ^ definition.hashCode ^ description.hashCode;
}
