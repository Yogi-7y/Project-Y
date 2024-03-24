// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:meta/meta.dart';

@immutable
class Term {
  const Term({
    required this.term,
    required this.definition,
    required this.score,
    this.description = '',
  });

  /// Term or a phrase.
  final String term;

  /// Definition of the term.\
  /// Should be small and concise.
  final String definition;

  /// Any extra information about the term.\
  /// Can include examples, references, etc.
  final String description;

  /// The score of the term.
  /// The score is calculated based on the number of times the term is shown.
  /// The more the term is shown, the higher the score and vice versa.
  /// Score is used to determine which terms to show next.
  final int score;

  @override
  String toString() {
    return 'Term(term: $term, definition: $definition, description: $description, score: $score)';
  }

  @override
  bool operator ==(covariant Term other) {
    if (identical(this, other)) return true;

    return other.term == term &&
        other.definition == definition &&
        other.description == description &&
        other.score == score;
  }

  @override
  int get hashCode {
    return term.hashCode ^ definition.hashCode ^ description.hashCode ^ score.hashCode;
  }
}
