import 'package:flutter/material.dart';

const Color _seed = Color(0xFF3F51B5);

ThemeData buildTheme(Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: brightness),
  );
}

class ThemeModeScope extends InheritedWidget {
  const ThemeModeScope({
    super.key,
    required this.mode,
    required this.onChanged,
    required super.child,
  });

  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;

  static ThemeModeScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ThemeModeScope>();
    if (scope == null) throw StateError('ThemeModeScope not found');
    return scope;
  }

  @override
  bool updateShouldNotify(ThemeModeScope oldWidget) => mode != oldWidget.mode;
}
