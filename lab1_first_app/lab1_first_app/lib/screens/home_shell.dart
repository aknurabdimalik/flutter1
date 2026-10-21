import 'package:flutter/material.dart';

import '../data/seed.dart';
import '../models/event_item.dart';
import '../models/profile.dart';
import '../routes.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/dialogs.dart';
import 'events_tab.dart';
import 'favourites_tab.dart';
import 'profile_tab.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  static const _titles = ['Events', 'Favourites', 'Profile'];

  List<EventItem> _items = seedEvents();
  Profile _profile = const Profile.empty();
  int _tab = 0;

  void _goToTab(int index) {
    setState(() => _tab = index);
  }

  void _toggleFavourite(String id) {
    setState(() {
      _items = [
        for (final e in _items)
          if (e.id == id) e.copyWith(favourite: !e.favourite) else e,
      ];
    });
  }

  void _upsert(EventItem item) {
    setState(() {
      final exists = _items.any((e) => e.id == item.id);
      _items = exists
          ? [for (final e in _items) e.id == item.id ? item : e]
          : [..._items, item];
    });
  }

  void _delete(String id) {
    setState(() => _items = _items.where((e) => e.id != id).toList());
  }

  void _setProfile(Profile profile) {
    setState(() => _profile = profile);
  }

  void _openDetail(EventItem item) {
    Navigator.pushNamed(
      context,
      Routes.detail,
      arguments: DetailArgs(
        item: item,
        profileName: _profile.name,
        onChanged: _upsert,
        onDelete: _delete,
        onGoToTab: _goToTab,
      ),
    );
  }

  Future<void> _addEvent() async {
    final created = await Navigator.pushNamed<EventItem>(
      context,
      Routes.form,
      arguments: const FormArgs(),
    );
    if (created == null || !mounted) return;
    _upsert(created);
  }

  void _showAbout() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('About'),
        content: const Text(
          'Campus Events\nLab 1, Mobile Development (Flutter 1).\n'
              'All data lives in memory.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetData() async {
    final ok = await confirmDialog(
      context,
      title: 'Reset data?',
      message: 'Events return to the seed list and the profile is cleared.',
      confirmLabel: 'Reset',
    );
    if (!ok || !mounted) return;
    setState(() {
      _items = seedEvents();
      _profile = const Profile.empty();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scope = ThemeModeScope.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_tab])),
      drawer: AppDrawer(onAbout: _showAbout, onReset: _resetData),
      body: IndexedStack(
        index: _tab,
        children: [
          EventsTab(
            items: _items,
            onOpen: _openDetail,
            onFavourite: _toggleFavourite,
          ),
          FavouritesTab(
            items: _items,
            onOpen: _openDetail,
            onFavourite: _toggleFavourite,
          ),
          ProfileTab(
            profile: _profile,
            events: _items,
            onChanged: _setProfile,
            themeMode: scope.mode,
            onThemeChanged: scope.onChanged,
          ),
        ],
      ),
      floatingActionButton: _tab == 0
          ? FloatingActionButton(
        onPressed: _addEvent,
        tooltip: 'New event',
        child: const Icon(Icons.add),
      )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: _goToTab,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.event), label: 'Events'),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            label: 'Favourites',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
