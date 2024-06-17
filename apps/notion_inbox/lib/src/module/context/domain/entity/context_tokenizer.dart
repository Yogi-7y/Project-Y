import 'package:smart_textfield/smart_textfield.dart';

import 'context_entity.dart';

class ContextTokenizer extends Tokenizer<ContextEntity> {
  ContextTokenizer({
    required super.prefix,
    required super.values,
  });

  static const prefixId = '#';
}
