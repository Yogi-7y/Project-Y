import 'package:flutter/material.dart';

abstract class AppColors {
  /// Main color of the app, used for key components like the app bar.
  Color get primary;

  /// A complementary color to the primary
  Color get secondary;

  /// A vibrant color used to draw attention to certain elements, like highlighting a selected item.
  Color get accent;

  /// The color of the main background of the app.
  Color get background;

  /// The color used for surfaces of components, such as cards.
  Color get surface;

  /// The color for overlay elements like modal barriers.
  Color get overlay;

  /// The color used to indicate errors or dangerous actions.
  Color get error;

  /// The color used to indicate success or positive actions.
  Color get success;

  /// The color for icons.
  Color get icon;

  /// The color for dividers or borders.
  Color get divider;

  /// The color of text/icons that appear on top of the primary color.
  Color get onPrimary;

  /// The color of text/icons that appear on top of the secondary color.
  Color get onSecondary;

  /// The color of text/icons that appear on top of the background color.
  Color get onBackground;

  /// The color of text/icons that appear on top of the surface color.
  Color get onSurface;

  /// The color of text/icons that appear on top of the error color.
  Color get onError;
}
