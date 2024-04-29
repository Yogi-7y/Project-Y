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

    return PortalTarget(
      // visible: _controller.activeSelectionMenu != null,
      visible: false,
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
                  // _controller.activeOptions.length,
                  0,
                  (index) => ListTile(
                        title: const Text(''),
                        onTap: () {},
                      )),
            ),
          ),
        ),
      ),
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
