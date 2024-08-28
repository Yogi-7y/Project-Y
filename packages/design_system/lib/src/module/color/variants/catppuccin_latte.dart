import 'package:flutter/material.dart';

import '../color.dart';

class CatppuccinLatteColors implements AppColors {
  /// Blue - #1e66f5
  @override
  Color get primary => const Color(0xFF1e66f5);

  /// Pink - #ea76cb
  @override
  Color get secondary => const Color(0xFFea76cb);

  /// Mauve - #8839ef
  @override
  Color get accent => const Color(0xFF8839ef);

  /// Base - #eff1f5
  @override
  Color get background => const Color(0xFFeff1f5);

  /// Mantle - #e6e9ef
  @override
  Color get surface => const Color(0xFFe6e9ef);

  /// Overlay0 - #9ca0b0
  @override
  Color get overlay => const Color(0xFF9ca0b0).withOpacity(0.5);

  /// Red - #d20f39
  @override
  Color get error => const Color(0xFFd20f39);

  /// Green - #40a02b
  @override
  Color get success => const Color(0xFF40a02b);

  /// Lavender - #7287fd
  @override
  Color get icon => const Color(0xFF7287fd);

  /// Surface0 - #ccd0da
  @override
  Color get divider => const Color(0xFFccd0da);

  /// Base - #eff1f5
  @override
  Color get onPrimary => const Color(0xFFeff1f5);

  /// Text - #4c4f69
  @override
  Color get onSecondary => const Color(0xFF4c4f69);

  /// Text - #4c4f69
  @override
  Color get onBackground => const Color(0xFF4c4f69);

  /// Text - #4c4f69
  @override
  Color get onSurface => const Color(0xFF4c4f69);

  /// Base - #eff1f5
  @override
  Color get onError => const Color(0xFFeff1f5);

  /// Base - #eff1f5
  @override
  Color get onSuccess => const Color(0xFFeff1f5);
}
