import 'dart:async';

import 'package:flutter/material.dart';

import 'api/countdown.dart';

enum _Version { a, b }

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  _Version _version = _Version.a;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Countdown')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<_Version>(
              segments: const [
                ButtonSegment(
                  value: _Version.a,
                  label: Text('A: StreamBuilder'),
                ),
                ButtonSegment(value: _Version.b, label: Text('B: listen')),
              ],
              selected: {_version},
              onSelectionChanged: (selection) {
                setState(() {
                  _version = selection.first;
                });
              },
            ),
          ),
          Expanded(
            child: Center(
              child: _version == _Version.a
                  ? const _CountdownA()
                  : const _CountdownB(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownA extends StatefulWidget {
  const _CountdownA();

  @override
  State<_CountdownA> createState() => _CountdownAState();
}

class _CountdownAState extends State<_CountdownA> {
  late final Stream<int> _stream = countdown(10);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _stream,
      builder: (context, snapshot) {
        return Text(
          '${snapshot.data ?? 10}',
          style: Theme.of(context).textTheme.displayLarge,
        );
      },
    );
  }
}

class _CountdownB extends StatefulWidget {
  const _CountdownB();

  @override
  State<_CountdownB> createState() => _CountdownBState();
}

class _CountdownBState extends State<_CountdownB> {
  int _left = 10;
  late StreamSubscription<int> _sub;

  @override
  void initState() {
    super.initState();
    _sub = countdown(10).listen((i) => setState(() => _left = i));
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('$_left', style: Theme.of(context).textTheme.displayLarge);
  }
}
