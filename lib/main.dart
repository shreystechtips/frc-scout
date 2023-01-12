import 'package:flutter/material.dart';
import 'pages/matches.dart' as matches;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'helper/appdata.dart' as appdata;
import 'helper/constants.dart' as constants;
import 'helper/bluealliance.dart' as bluealliance;
import 'pages/teamselection.dart' as teamselection;

Future main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  appdata.AppData prefs = await appdata.AppData.create();
  if (prefs.getString(constants.TEAM_KEY) == '') {
    bluealliance.TBARequest.getTeams(
        save: true, prefs: prefs, key: constants.TEAM_KEY);
  }

  runApp(MyApp(
    prefs: prefs,
  ));
}

class MyApp extends StatefulWidget {
  appdata.AppData prefs;
  @override
  State<MyApp> createState() => _PageState();

  MyApp({super.key, required this.prefs});
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

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      matches.Page(
        prefs: widget.prefs,
      ),
      teamselection.Page(prefs: widget.prefs),
      const Icon(
        Icons.chat,
        size: 150,
      ),
    ];
    Scaffold scaffold = Scaffold(
        appBar: AppBar(
          title: const Text('FRC Scout'),
        ),
        body: Center(
          child: pages.elementAt(_selectedIndex), //New
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
