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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _onButton1Pressed(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final api = ExampleHostApi();
    try {
      final name = await api.getPlatformName();
      messenger.showSnackBar(SnackBar(content: Text('Platform: $name')));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _onButtonPressed(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label pressed')),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => _onButton1Pressed(context),
              child: const Text('Button 1 – Get Platform Name'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _onButtonPressed(context, 'Button 2'),
              child: const Text('Button 2'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _onButtonPressed(context, 'Button 3'),
              child: const Text('Button 3'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _onButtonPressed(context, 'Button 4'),
              child: const Text('Button 4'),
            ),
          ],
        ),
      ),
    );
  }
}
