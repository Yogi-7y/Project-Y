import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

import '../../../smart_textfield.dart';
import 'smart_textfield_controller.dart';

class SmartTextField extends StatefulWidget {
  const SmartTextField({
    required this.selectionMenus,
    super.key,
  });

  final List<SelectionMenu> selectionMenus;

  @override
  State<SmartTextField> createState() => _SmartTextFieldState();
}

class _SmartTextFieldState extends State<SmartTextField> {
  late final _controller = SmartTextFieldController(
    selectionMenus: widget.selectionMenus,
  );

  late final _globalKey = GlobalKey<FormState>();

  String query = '';
  int currentModifier = -1;

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;

    return PortalTarget(
      visible: _controller.activeSelectionMenu != null,
      anchor: const Aligned(
        follower: Alignment.bottomRight,
        target: Alignment.topRight,
      ),
      portalFollower: Material(
        elevation: 8,
        color: maroonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          width: _width * .8,
          // height: 200,
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                  _controller.activeOptions.length,
                  (index) => ListTile(
                        title: Text(_controller.activeOptions[index].queryContent),
                        onTap: () {
                          _controller.selectValue(
                            _controller.activeSelectionMenu!.pattern,
                            _controller.activeOptions[index],
                          );
                        },
                      )),
            ),
          ),
        ),
      ),
      child: TextField(
        autofocus: true,
        key: _globalKey,
        controller: _controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

// class SmartTextFieldController extends TextEditingController {
//   SmartTextFieldController({required this.smartTextFieldUseCase});

//   final SmartTextFieldUseCase smartTextFieldUseCase;

//   @override
//   TextSpan buildTextSpan({
//     required BuildContext context,
//     required bool withComposing,
//     TextStyle? style,
//   }) {
//     final _value = smartTextFieldUseCase.processDateTime(text);

//     if (_value == null) {
//       return TextSpan(
//         style: style,
//         children: [
//           TextSpan(
//             text: value.text,
//           ),
//         ],
//       );
//     }

//     final _before = TextSpan(
//       text: value.text.substring(0, _value.start),
//       style: style,
//     );

//     final _highlight = TextSpan(
//       text: value.text.substring(_value.start, _value.end),
//       style: style!.copyWith(
//         decoration: TextDecoration.underline,
//         decorationStyle: TextDecorationStyle.dashed,
//         decorationThickness: 2,
//         decorationColor: grey.withOpacity(.8),
//       ),
//     );

//     final _after = TextSpan(
//       text: value.text.substring(_value.end),
//       style: style,
//     );

//     return TextSpan(
//       style: style,
//       children: [
//         _before,
//         _highlight,
//         _after,
//       ],
//     );
//   }
// }

const primaryColor = Color(0xff0f0e0e);
const maroonColor = Color(0xff541212);
const greenColor = Color(0xff8b9a46);
const grey = Color(0xffeeeeee);

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
