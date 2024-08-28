import 'package:flutter/material.dart';

import '../color.dart';

class CatppuccinMochaColors implements AppColors {
  @override

  /// Blue - #89b4fa
  Color get primary => const Color(0xFF89b4fa);

  /// Pink - #f5c2e7
  @override
  Color get secondary => const Color(0xFFf5c2e7);

  /// Mauve - #cba6f7
  @override
  Color get accent => const Color(0xFFcba6f7);

  /// Base - #1e1e2e
  @override
  Color get background => const Color(0xFF1e1e2e);

  /// Mantle - #181825
  @override
  Color get surface => const Color(0xFF181825);

  /// Overlay0 - #6c7086
  @override
  Color get overlay => const Color(0xFF6c7086).withOpacity(0.5);

  /// Red - #f38ba8
  @override
  Color get error => const Color(0xFFf38ba8);

  /// Green - #a6e3a1
  @override
  Color get success => const Color(0xFFa6e3a1);

  /// Lavender - #b4befe
  @override
  Color get icon => const Color(0xFFb4befe);

  /// Surface0 - #313244
  @override
  Color get divider => const Color(0xFF313244);

  /// Base - #1e1e2e
  @override
  Color get onPrimary => const Color(0xFF1e1e2e);

  /// Base - #1e1e2e
  @override
  Color get onSecondary => const Color(0xFF1e1e2e);

  /// Text - #cdd6f4
  @override
  Color get onBackground => const Color(0xFFcdd6f4);

  /// Text - #cdd6f4
  @override
  Color get onSurface => const Color(0xFFcdd6f4);

  /// Base - #1e1e2e
  @override
  Color get onError => const Color(0xFF1e1e2e);
}
