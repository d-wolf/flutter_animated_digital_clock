import 'package:flutter/material.dart';

import 'clock/clock_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Animated Clock',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Digital Animated Clock'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ClockWidget(
        dateTime: DateTime.now(),
        curveIn: Curves.elasticInOut,
        curveOut: Curves.linear,
        is24HourClockFormat: false,
        separator: ':',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 42, color: Theme.of(context).colorScheme.inversePrimary),
      ),
    );
  }
}
