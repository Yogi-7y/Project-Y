import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

import 'smart_text_field_controller.dart';

class SmartTextField extends StatefulWidget {
  const SmartTextField({
    required this.controller,
    super.key,
  });

  final SmartTextFieldController controller;

  @override
  State<SmartTextField> createState() => _SmartTextFieldState();
}

class _SmartTextFieldState extends State<SmartTextField> {
  late final _globalKey = GlobalKey<FormState>();

  String query = '';
  int currentModifier = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return ValueListenableBuilder(
      valueListenable: widget.controller.suggestions,
      child: TextField(
        autofocus: true,
        key: _globalKey,
        controller: widget.controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      builder: (context, suggestions, child) => PortalTarget(
        visible: suggestions.isNotEmpty,
        anchor: const Aligned(
          follower: Alignment.bottomRight,
          target: Alignment.topRight,
        ),
        portalFollower: Material(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: _width * .8,
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  suggestions.length,
                  (index) {
                    final _suggestion = suggestions[index];
                    return ListTile(
                      title: Text(_suggestion.stringValue),
                      onTap: () {
                        /// current cursor position
                        final _cursorPosition = widget.controller.selection.base.offset;

                        /// text before cursor
                        final _textBeforeCursor =
                            widget.controller.text.substring(0, _cursorPosition);

                        /// text after cursor
                        final _textAfterCursor = widget.controller.text.substring(_cursorPosition);

                        /// prefix index

                        final _prefixIndex = _textBeforeCursor.lastIndexOf(_suggestion.prefix);

                        /// value to be inserted
                        final _value = _suggestion.prefix + _suggestion.stringValue;

                        /// new text
                        /// text before cursor + value + text after cursor
                        final _newText =
                            '${_textBeforeCursor.substring(0, _prefixIndex)}$_value$_textAfterCursor';

                        widget.controller.text = _newText;
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        child: child!,
      ),
    );
  }
}

@immutable
class SmartTextFieldOverlay extends StatelessWidget {
  const SmartTextFieldOverlay({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Portal(
      child: child,
    );
  }
}
