import 'package:flutter/material.dart';

class HeroesMarchScreen extends StatelessWidget {
  const HeroesMarchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero\'s March'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_run, size: 64, color: Colors.deepPurple),
            SizedBox(height: 16),
            Text(
              'Hero\'s March',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Step tracking and dashboard will go here.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
