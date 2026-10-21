import 'package:flutter/material.dart';

import 'summary_card.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal)),
    home: const SignUpScreen(),
  );
}

const groups = ['IT-2301', 'IT-2302', 'IT-2303', 'IT-2304', 'IT-2305'];

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _birthText = TextEditingController();
  final _emailFocus = FocusNode();

  String? _group;
  DateTime? _birth;
  bool _agreed = false;
  bool _done = false;
  int _passLen = 0;

  @override
  void dispose() {
    for (final c in [_name, _email, _password, _confirm, _birthText]) {
      c.dispose();
    }
    _emailFocus.dispose();
    super.dispose();
  }

  void _hideKeyboard(PointerDownEvent _) =>
      FocusManager.instance.primaryFocus?.unfocus();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Account created')));
      setState(() => _done = true);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birth ?? DateTime(2005),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    if (!mounted) return;
    setState(() {
      _birth = picked;
      _birthText.text =
          '${picked.day.toString().padLeft(2, '0')}.'
          '${picked.month.toString().padLeft(2, '0')}.${picked.year}';
    });
  }

  void _startOver() {
    setState(() {
      for (final c in [_name, _email, _password, _confirm, _birthText]) {
        c.clear();
      }
      _group = null;
      _birth = null;
      _agreed = false;
      _passLen = 0;
      _done = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Sign up')),
    body: _done ? _summary() : _form(),
  );

  Widget _summary() => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        SummaryCard(
          name: _name.text,
          email: _email.text,
          group: _group ?? '',
          birth: _birthText.text,
        ),
        const SizedBox(height: 16),
        TextButton(onPressed: _startOver, child: const Text('Start over')),
      ],
    ),
  );

  Widget _form() => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Name'),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _emailFocus.requestFocus(),
            onTapOutside: _hideKeyboard,
            validator: (v) =>
                (v ?? '').trim().length < 2 ? 'Name is too short' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _email,
            focusNode: _emailFocus,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            textInputAction: TextInputAction.next,
            onTapOutside: _hideKeyboard,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'name@kbtu.kz',
            ),
            validator: (v) {
              final s = (v ?? '').trim();
              final at = s.indexOf('@');
              if (at < 1 || !s.substring(at).contains('.')) {
                return 'Email looks wrong';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _password,
            obscureText: true,
            textInputAction: TextInputAction.next,
            onTapOutside: _hideKeyboard,
            onChanged: (v) => setState(() => _passLen = v.length),
            decoration: const InputDecoration(
              labelText: 'Password',
              helperText: 'At least 8 characters',
            ),
            validator: (v) =>
                (v ?? '').length < 8 ? 'Password is too short' : null,
          ),
          Text('$_passLen of 8'),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirm,
            obscureText: true,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _submit(),
            onTapOutside: _hideKeyboard,
            decoration: const InputDecoration(labelText: 'Confirm password'),
            validator: (v) =>
                v != _password.text ? 'Passwords do not match' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _group,
            decoration: const InputDecoration(labelText: 'Group'),
            items: [
              for (final g in groups)
                DropdownMenuItem(value: g, child: Text(g)),
            ],
            onChanged: (v) => setState(() => _group = v),
            validator: (g) => g == null ? 'Choose a group' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _birthText,
            readOnly: true,
            onTap: _pickDate,
            onTapOutside: _hideKeyboard,
            decoration: const InputDecoration(
              labelText: 'Date of birth',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            validator: (_) => _birth == null ? 'Choose a date of birth' : null,
          ),
          CheckboxListTile(
            value: _agreed,
            onChanged: (v) => setState(() => _agreed = v ?? false),
            title: const Text('I agree to the rules'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _agreed ? _submit : null,
            child: const Text('Sign up'),
          ),
        ],
      ),
    ),
  );
}
