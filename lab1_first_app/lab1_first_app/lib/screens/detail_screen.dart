import 'dart:async';

import 'package:flutter/material.dart';

import '../models/event_item.dart';
import '../routes.dart';
import '../utils/format.dart';
import '../widgets/dialogs.dart';
import '../widgets/empty_state.dart';

enum _MenuAction { edit, delete }

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.args});

  final DetailArgs args;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late EventItem _item;
  DateTime _now = DateTime.now();
  Timer? _timer;

  String get _me => widget.args.profileName.trim();
  bool get _joined => _me.isNotEmpty && _item.contains(_me);

  @override
  void initState() {
    super.initState();
    _item = widget.args.item;
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _openProfile() {
    if (!mounted) return;
    Navigator.of(context).pop();
    widget.args.onGoToTab(2);
  }

  Future<void> _register() async {
    if (_me.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Fill in your name in the profile first'),
          action: SnackBarAction(label: 'Profile', onPressed: _openProfile),
        ),
      );
      return;
    }
    final ok = await confirmDialog(
      context,
      title: 'Register?',
      message: 'Register as $_me for "${_item.title}"?',
      confirmLabel: 'Register',
    );
    if (!ok || !mounted) return;
    final updated = _item.copyWith(attendees: [..._item.attendees, _me]);
    setState(() => _item = updated);
    widget.args.onChanged(updated);
  }

  void _leave() {
    final updated = _item.copyWith(
      attendees: _item.attendees.where((n) => n != _me).toList(),
    );
    setState(() => _item = updated);
    widget.args.onChanged(updated);
  }

  Future<void> _edit() async {
    final result = await Navigator.pushNamed<EventItem>(
      context,
      Routes.form,
      arguments: FormArgs(item: _item),
    );
    if (result == null || !mounted) return;
    setState(() => _item = result);
    widget.args.onChanged(result);
  }

  Future<void> _delete() async {
    final ok = await confirmDialog(
      context,
      title: 'Delete event?',
      message: '"${_item.title}" will be removed.',
      confirmLabel: 'Delete',
    );
    if (!ok || !mounted) return;
    widget.args.onDelete(_item.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final item = _item;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          actions: [
            PopupMenuButton<_MenuAction>(
              onSelected: (action) {
                switch (action) {
                  case _MenuAction.edit:
                    _edit();
                  case _MenuAction.delete:
                    _delete();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: _MenuAction.edit, child: Text('Edit')),
                PopupMenuItem(value: _MenuAction.delete, child: Text('Delete')),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            _Header(item: item, now: _now),
            TabBar(
              tabs: [
                const Tab(text: 'About'),
                Tab(text: 'Names (${item.count})'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _AboutTab(item: item),
                  _NamesTab(item: item, me: _me),
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    // null = disabled: full and not yet on the list
                    onPressed: _joined ? _leave : (item.isFull ? null : _register),
                    child: Text(_joined ? 'Cancel registration' : 'Register'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.item, required this.now});

  final EventItem item;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 180,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/header.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) =>
                ColoredBox(color: scheme.primaryContainer),
          ),
          Center(
            child: CircleAvatar(
              radius: 36,
              backgroundColor: scheme.surface,
              child: Icon(
                item.category.icon,
                size: 40,
                color: item.category.color(scheme),
              ),
            ),
          ),
          Positioned(
            left: 12,
            top: 12,
            child: Chip(label: Text(item.category.label)),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: Chip(
              label: Text(describeCountdown(item.countdownAt(now))),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutTab extends StatelessWidget {
  const _AboutTab({required this.item});

  final EventItem item;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    // record destructuring
    final (:taken, :free) = item.places;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(item.title, style: text.headlineSmall),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.schedule),
          title: Text(formatDate(item.starts)),
        ),
        ListTile(
          leading: Icon(item.online ? Icons.link : Icons.place),
          title: Text(item.location),
        ),
        ListTile(
          leading: const Icon(Icons.people),
          title: Text('Places: $taken taken, $free free (of ${item.capacity})'),
        ),
        if (item.description case final description?)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(description, style: text.bodyLarge),
          ),
      ],
    );
  }
}

class _NamesTab extends StatelessWidget {
  const _NamesTab({required this.item, required this.me});

  final EventItem item;
  final String me;

  @override
  Widget build(BuildContext context) {
    final names = item.attendees;
    if (names.isEmpty) {
      return const EmptyState(
        icon: Icons.group_off,
        message: 'Nobody is on the list yet',
      );
    }
    final scheme = Theme.of(context).colorScheme;
    return ListView.builder(
      itemCount: names.length,
      itemBuilder: (context, index) {
        final name = names[index];
        final isYou = me.isNotEmpty && name == me;
        return ListTile(
          tileColor: isYou ? scheme.secondaryContainer : null,
          leading: CircleAvatar(child: Text(name.isEmpty ? '?' : name[0])),
          title: Text(
            name,
            style: isYou ? const TextStyle(fontWeight: FontWeight.bold) : null,
          ),
          trailing: isYou ? const Chip(label: Text('You')) : null,
        );
      },
    );
  }
}
