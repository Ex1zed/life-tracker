import 'package:flutter/material.dart';

class CheckinScreen extends StatelessWidget {
  const CheckinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сегодня')),
      body: const Center(child: Text('Check-in — day 5')),
    );
  }
}