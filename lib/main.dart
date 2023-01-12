import 'package:flutter/material.dart';
import 'pages/matches.dart' as matches;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _PageState();

  const MyApp({super.key});
}

class _PageState extends State<MyApp> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<BottomNavigationBarItem> _barItems =
      <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.smart_toy),
      label: 'Matches',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.leaderboard),
      label: 'Rankings',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.edit_note),
      label: 'Pit Notes',
    )
  ];
  static const List<Widget> _pages = <Widget>[
    Icon(
      Icons.chat,
      size: 150,
    ),
    matches.Page(),
    matches.Page(),
    matches.Page(),
  ];

  @override
  Widget build(BuildContext context) {
    Scaffold scaffold = Scaffold(
        appBar: AppBar(
          title: const Text('FRC Scout'),
        ),
        body: Center(
          child: _pages.elementAt(_selectedIndex), //New
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: _barItems));
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        home: scaffold
        // const matches.Page(title: 'FRC Scout'),
        );
  }
}
