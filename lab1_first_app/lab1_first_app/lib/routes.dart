import 'package:flutter/material.dart';

import 'models/event_item.dart';
import 'screens/detail_screen.dart';
import 'screens/form_screen.dart';

class Routes {
  static const shell = '/';
  static const detail = '/detail';
  static const form = '/form';
}

class DetailArgs {
  const DetailArgs({
    required this.item,
    required this.profileName,
    required this.onChanged,
    required this.onDelete,
    required this.onGoToTab,
  });

  final EventItem item;
  final String profileName;
  final ValueChanged<EventItem> onChanged;
  final ValueChanged<String> onDelete;
  final ValueChanged<int> onGoToTab;
}

class FormArgs {
  const FormArgs({this.item});

  final EventItem? item;
}

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  final args = settings.arguments;
  switch (settings.name) {
    case Routes.detail:
      if (args is DetailArgs) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (context) => DetailScreen(args: args),
        );
      }
    case Routes.form:
      return MaterialPageRoute<EventItem>(
        settings: settings,
        builder: (context) =>
            FormScreen(item: args is FormArgs ? args.item : null),
      );
  }
  return null;
}

Route<dynamic> onUnknownRoute(RouteSettings settings) {
  return MaterialPageRoute<void>(
    settings: settings,
    builder: (context) => Scaffold(
      appBar: AppBar(title: const Text('Not found')),
      body: const Center(child: Text('Not found')),
    ),
  );
}
