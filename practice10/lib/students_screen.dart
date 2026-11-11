import 'package:flutter/material.dart';

import 'api/fake_api.dart';
import 'widgets/empty_view.dart';
import 'widgets/error_view.dart';
import 'widgets/loading_view.dart';
import 'widgets/student_list.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Student>? _students;
  Object? _error;
  bool _saving = false;
  final _api = FakeApi();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _students = null;
      _error = null;
    });
    try {
      final list = await _api.fetchStudents();
      if (!mounted) return;
      setState(() => _students = list);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
  }

  Widget _buildBody() {
    if (_error != null) return ErrorView(onRetry: _load);
    if (_students == null) return const LoadingView();
    if (_students!.isEmpty) return const EmptyView();
    return StudentList(_students!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('By hand')),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: (_saving || _students == null)
            ? null
            : () async {
                final n = _students!.length;
                setState(() => _saving = true);
                try {
                  await _api.save(n);
                  if (!context.mounted) return;
                  Navigator.pop(context); // pop only on success
                } on StateError catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(e.message)));
                  setState(() => _saving = false);
                }
              },
        child: _saving
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.save),
      ),
    );
  }
}
