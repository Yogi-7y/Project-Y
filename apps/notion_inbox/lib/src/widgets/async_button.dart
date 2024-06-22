import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class AsyncButton extends StatefulWidget {
  const AsyncButton({
    required this.onPressed,
    required this.text,
    this.endToEndWidth = false,
    super.key,
  });

  final AsyncCallback onPressed;
  final String text;

  /// Makes the button go end-to-end.
  final bool endToEndWidth;

  @override
  State<AsyncButton> createState() => _AsyncButtonState();
}

class _AsyncButtonState extends State<AsyncButton> {
  bool _isLoading = false;

  Future<void> _onClick() async {
    if (_isLoading) return;

    _isLoading = true;
    setState(() {});

    try {
      await widget.onPressed();
    } finally {
      _isLoading = false;
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.endToEndWidth ? double.infinity : null,
      child: TextButton(
        onPressed: _onClick,
        style: TextButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: _isLoading
            ? const UnconstrainedBox(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              )
            : Text(
                widget.text,
                style: const TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
