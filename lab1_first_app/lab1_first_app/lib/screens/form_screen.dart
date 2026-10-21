import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/category.dart';
import '../models/event_item.dart';
import '../utils/format.dart';
import '../widgets/dialogs.dart';


typedef _FormValues = ({
String title,
String place,
String limit,
String description,
EventCategory? category,
bool online,
DateTime? date,
TimeOfDay? time,
});

class FormScreen extends StatefulWidget {
  const FormScreen({super.key, this.item});


  final EventItem? item;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleFocus = FocusNode();
  final _placeFocus = FocusNode();
  final _limitFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  late final TextEditingController _title;
  late final TextEditingController _place;
  late final TextEditingController _limit;
  late final TextEditingController _description;
  late final TextEditingController _dateText;
  late final TextEditingController _timeText;
  late final _FormValues _initial;

  EventCategory? _category;
  bool _online = false;
  DateTime? _date;
  TimeOfDay? _time;
  bool _saving = false;

  bool get _isNew => widget.item == null;

  @override
  void initState() {
    super.initState();
    final item = widget.item ?? EventItem.empty();
    _title = TextEditingController(text: item.title);
    _place = TextEditingController(text: item.location);
    _limit = TextEditingController(text: item.capacity.toString());
    _description = TextEditingController(text: item.description ?? '');
    _online = item.online;
    if (!_isNew) {
      _category = item.category;
      _date = DateTime(item.starts.year, item.starts.month, item.starts.day);
      _time = TimeOfDay(hour: item.starts.hour, minute: item.starts.minute);
    }
    final date = _date;
    final time = _time;
    _dateText = TextEditingController(
      text: date == null ? '' : formatDay(date),
    );
    _timeText = TextEditingController(
      text: time == null ? '' : formatClock(time.hour, time.minute),
    );
    _initial = _values();
  }

  @override
  void dispose() {
    _title.dispose();
    _place.dispose();
    _limit.dispose();
    _description.dispose();
    _dateText.dispose();
    _timeText.dispose();
    _titleFocus.dispose();
    _placeFocus.dispose();
    _limitFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  _FormValues _values() => (
  title: _title.text,
  place: _place.text,
  limit: _limit.text,
  description: _description.text,
  category: _category,
  online: _online,
  date: _date,
  time: _time,
  );

  bool get _dirty => _values() != _initial;

  DateTime? get _combined {
    final d = _date;
    final t = _time;
    if (d == null || t == null) return null;
    return DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }



  String? _validateTitle(String? value) {
    final text = (value ?? '').trim();
    if (text.length < 3) return 'At least 3 characters';
    if (text.length > 60) return 'At most 60 characters';
    return null;
  }

  String? _validatePlace(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return _online ? 'Link is required' : 'Place is required';
    if (_online && !text.contains('://')) return 'A link must contain ://';
    return null;
  }

  String? _validateLimit(String? value) {
    final n = int.tryParse((value ?? '').trim());
    if (n == null) return 'Enter a whole number';
    if (n < 1 || n > 500) return 'From 1 to 500';
    final taken = widget.item?.count ?? 0;
    if (n < taken) return 'Not below the current count ($taken)';
    return null;
  }

  String? _futureError() {
    final moment = _combined;
    if (_isNew && moment != null && !moment.isAfter(DateTime.now())) {
      return 'Must be in the future';
    }
    return null;
  }

  String? _validateDate(String? value) {
    if (_date == null) return 'Choose a date';
    return _futureError();
  }

  String? _validateTime(String? value) {
    if (_time == null) return 'Choose a time';
    return _futureError();
  }



  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _date = picked;
      _dateText.text = formatDay(picked);
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _time = picked;
      _timeText.text = formatClock(picked.hour, picked.minute);
    });
  }

  Future<void> _save() async {
    if (_saving) return; // a second tap does nothing
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    final base = widget.item ?? EventItem.empty();
    final description = _description.text.trim();
    final saved = base.copyWith(
      id: base.id.isEmpty
          ? DateTime.now().microsecondsSinceEpoch.toString()
          : base.id,
      title: _title.text.trim(),
      category: _category,
      starts: _combined,
      location: _place.text.trim(),
      capacity: int.tryParse(_limit.text.trim()),
      online: _online,
      description: description,
      clearDescription: description.isEmpty,
    );
    Navigator.of(context).pop(saved);
  }

  void _dismissKeyboard(PointerDownEvent event) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final discard = await confirmDialog(
          context,
          title: 'Discard changes?',
          message: 'Your changes will be lost.',
          confirmLabel: 'Discard',
        );
        if (!discard || !mounted) return;
        Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(_isNew ? 'New event' : 'Edit event')),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // the values live in controllers; this only re-evaluates "dirty"
          onChanged: () => setState(() {}),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _title,
                  focusNode: _titleFocus,
                  maxLength: 60,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  validator: _validateTitle,
                  onTapOutside: _dismissKeyboard,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<EventCategory>(
                  initialValue: _category,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    for (final c in EventCategory.values)
                      DropdownMenuItem(
                        value: c,
                        child: Row(
                          children: [
                            Icon(c.icon),
                            const SizedBox(width: 8),
                            Text(c.label),
                          ],
                        ),
                      ),
                  ],
                  onChanged: (value) => setState(() => _category = value),
                  validator: (value) => value == null ? 'Choose a category' : null,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Online event'),
                  value: _online,
                  onChanged: (value) => setState(() => _online = value),
                ),
                TextFormField(
                  controller: _place,
                  focusNode: _placeFocus,
                  decoration: InputDecoration(
                    labelText: _online ? 'Link' : 'Place',
                    border: const OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: _online ? TextInputType.url : TextInputType.text,
                  validator: _validatePlace,
                  onTapOutside: _dismissKeyboard,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _limit,
                  focusNode: _limitFocus,
                  decoration: const InputDecoration(
                    labelText: 'Limit (places)',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: _validateLimit,
                  onTapOutside: _dismissKeyboard,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dateText,
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: _validateDate,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _timeText,
                  readOnly: true,
                  onTap: _pickTime,
                  decoration: const InputDecoration(
                    labelText: 'Time',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  validator: _validateTime,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _description,
                  focusNode: _descriptionFocus,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  onTapOutside: _dismissKeyboard,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
