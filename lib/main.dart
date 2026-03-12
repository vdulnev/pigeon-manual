import 'dart:async';

import 'package:flutter/material.dart';

import 'src/messages.g.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pigeon Manual',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription<int>? _counterSubscription;
  int? _count;

  @override
  void initState() {
    super.initState();
    PingFlutterApi.setUp(_PingFlutterApiHandler((message) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }));
  }

  @override
  void dispose() {
    PingFlutterApi.setUp(null);
    _counterSubscription?.cancel();
    super.dispose();
  }

  Future<void> _onButton1Pressed() async {
    final messenger = ScaffoldMessenger.of(context);
    final api = ExampleHostApi();
    try {
      final name = await api.getPlatformName();
      messenger.showSnackBar(SnackBar(content: Text('Platform: $name')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _onButton2Pressed() {
    if (_counterSubscription != null) {
      _counterSubscription!.cancel();
      setState(() {
        _counterSubscription = null;
        _count = null;
      });
    } else {
      final subscription = onCount().listen(
        (count) => setState(() => _count = count),
        onError: (Object e) => setState(() => _counterSubscription = null),
        onDone: () => setState(() => _counterSubscription = null),
      );
      setState(() => _counterSubscription = subscription);
    }
  }

  Future<void> _onButton3Pressed() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await PingHostApi().requestPing();
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _onButtonPressed(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label pressed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listening = _counterSubscription != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _onButton1Pressed,
              child: const Text('Button 1 – Get Platform Name'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _onButton2Pressed,
              child: Text(
                listening
                    ? 'Button 2 – Stop Counter (${_count ?? 0})'
                    : 'Button 2 – Start Counter',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _onButton3Pressed,
              child: const Text('Button 3 – Ping Native'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _onButtonPressed('Button 4'),
              child: const Text('Button 4'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PingFlutterApiHandler implements PingFlutterApi {
  final void Function(String) _callback;

  _PingFlutterApiHandler(this._callback);

  @override
  void onPong(String message) => _callback(message);
}
