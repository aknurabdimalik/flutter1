import 'package:flutter/material.dart';

import '../models/event_item.dart';
import '../models/profile.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({
    super.key,
    required this.profile,
    required this.events,
    required this.onChanged,
    required this.themeMode,
    required this.onThemeChanged,
  });

  final Profile profile;
  final List<EventItem> events;
  final ValueChanged<Profile> onChanged;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  static final _groupPattern = RegExp(r'^[A-Z]{2,4}-\d{2,4}$');

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _group;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.profile.name);
    _group = TextEditingController(text: widget.profile.group);
  }

  @override
  void didUpdateWidget(ProfileTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The model changed from outside (for example "Reset data").
    if (oldWidget.profile.name != widget.profile.name &&
        _name.text != widget.profile.name) {
      _name.text = widget.profile.name;
    }
    if (oldWidget.profile.group != widget.profile.group &&
        _group.text != widget.profile.group) {
      _group.text = widget.profile.group;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _group.dispose();
    super.dispose();
  }

  String? _validateGroup(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return null; // the group is optional
    return _groupPattern.hasMatch(text) ? null : 'Use a format like IT-2301';
  }

  void _saveName(String value) {
    widget.onChanged(widget.profile.copyWith(name: value.trim()));
  }

  void _saveGroup(String value) {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onChanged(widget.profile.copyWith(group: value.trim()));
    }
  }

  void _dismissKeyboard(PointerDownEvent event) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  String _modeLabel(ThemeMode mode) => switch (mode) {
    ThemeMode.system => 'System',
    ThemeMode.light => 'Light',
    ThemeMode.dark => 'Dark',
  };

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final name = widget.profile.name;
    // computed on every build, never stored
    final lists = name.isEmpty
        ? 0
        : widget.events.where((e) => e.contains(name)).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                onFieldSubmitted: _saveName,
                onTapOutside: _dismissKeyboard,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _group,
                decoration: const InputDecoration(
                  labelText: 'Group',
                  hintText: 'IT-2301',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                validator: _validateGroup,
                onFieldSubmitted: _saveGroup,
                onTapOutside: _dismissKeyboard,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          lists == 1 ? 'You are on 1 list' : 'You are on $lists lists',
          style: text.titleMedium,
        ),
        const SizedBox(height: 24),
        Text('Theme', style: text.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final mode in ThemeMode.values)
              ChoiceChip(
                label: Text(_modeLabel(mode)),
                selected: widget.themeMode == mode,
                onSelected: (_) => widget.onThemeChanged(mode),
              ),
          ],
        ),
      ],
    );
  }
}
