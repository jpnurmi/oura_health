import 'package:flutter/material.dart';

import 'sleep/sleep_view.dart';

class HealthApp extends StatefulWidget {
  const HealthApp({super.key});

  @override
  State<HealthApp> createState() => _HealthAppState();
}

class _HealthAppState extends State<HealthApp> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oura Health',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(title: const Text('Oura Health')),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            SleepView.create(),
            const Center(child: Text('TODO')),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              label: 'Sleep',
              activeIcon: Icon(Icons.bed),
              icon: Icon(Icons.bed_outlined),
            ),
            BottomNavigationBarItem(
              label: 'Activity',
              activeIcon: Icon(Icons.run_circle),
              icon: Icon(Icons.run_circle_outlined),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
      ),
    );
  }
}
