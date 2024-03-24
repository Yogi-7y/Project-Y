import 'package:core/core.dart';
import 'package:meta/meta.dart';
import 'package:network/network.dart';
import 'package:resurface/src/module/domain/entity/term.dart';

typedef IterableMapPayload = Iterable<MapPayload>;

@immutable
class NotionTermDto extends Term {
  const NotionTermDto({
    required super.term,
    required super.definition,
    required super.score,
  });

  factory NotionTermDto.fromMap(Map<String, Object?> map) {
    final _properties = SerializationValidator()(map)<MapPayload>('properties');
    final _term = SerializationValidator()(_properties)<MapPayload>('Term');
    final _definition = SerializationValidator()(_properties)<MapPayload>('Definition');
    final _score = SerializationValidator()(_properties)<MapPayload>('Score');

    final _termTitle = SerializationValidator()(_term)<IterableMapPayload>('title').first;
    final _termText = SerializationValidator()(_termTitle)<MapPayload>('text');
    final _termContent = SerializationValidator()(_termText)<String>('content');

    final _number = SerializationValidator()(_score)<int>('number');

    final _definitionRichText =
        SerializationValidator()(_definition)<IterableMapPayload>('rich_text').first;
    final _definitionText = SerializationValidator()(_definitionRichText)<MapPayload>('text');
    final _definitionContent = SerializationValidator()(_definitionText)<String>('content');

    return NotionTermDto(
      term: _termContent,
      score: _number,
      definition: _definitionContent,
    );
  }
}
