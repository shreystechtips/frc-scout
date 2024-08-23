import 'package:flutter/material.dart';
import 'screens/home/matches.dart' as matches;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'helper/appdata.dart' as appdata;
import 'helper/constants.dart' as constants;
import 'helper/bluealliance.dart' as bluealliance;
import 'screens/teamselection.dart' as teamselection;
import 'widgets/bottombarnav.dart' as bottombarnav;

Future main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  appdata.AppData prefs = await appdata.AppData.create();
  if (prefs.getString(constants.TEAM_KEY) == '') {
    bluealliance.TBARequest.getTeams(
        save: true, prefs: prefs, key: constants.TEAM_KEY);
  }

  final screendata = appdata.ScreenData(prefs: prefs);

  runApp(MyApp(
    screendata: screendata,
  ));
}

class MyApp extends StatefulWidget {
  final appdata.ScreenData screendata;
  @override
  State<MyApp> createState() => _PageState();

  const MyApp({super.key, required this.screendata});
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
    // BottomNavigationBarItem(
    //   icon: Icon(Icons.edit_note),
    //   label: 'Pit Notes',
    // )
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      matches.Page(
        screendata: widget.screendata,
      ),
      teamselection.Page(screendata: widget.screendata),
      const Icon(
        Icons.chat,
        size: 150,
      ),
    ];

    // Scaffold scaffold = Scaffold(
    //     appBar: AppBar(
    //       title: const Text('FRC Scout'),
    //     ),
    //     body: Center(
    //       child: pages.elementAt(_selectedIndex), //New
    //     ),
    //     bottomNavigationBar: BottomNavigationBar(
    //         currentIndex: _selectedIndex,
    //         onTap: _onItemTapped,
    //         items: _barItems));

    // bottombarnav.BottomBarNav nav = bottombarnav.BottomBarNav(
    //   pages: pages,
    //   barItems: _barItems,
    //   onItemTapped: _onItemTapped,
    //   selectedIndex: _selectedIndex,
    //   title: "FRC Scout");

    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        initialRoute: '/',
        // home: nav.build(context),
        routes: {
          '/': (BuildContext context) => Scaffold(
                appBar: AppBar(
                  title: const Text('FRC Scout'),
                ),
                body: Center(
                  child: pages.elementAt(_selectedIndex), //New
                ),
                bottomNavigationBar: BottomNavigationBar(
                    currentIndex: _selectedIndex,
                    onTap: _onItemTapped,
                    items: _barItems),
              ),
          '/teams': (BuildContext context) => Scaffold(
                appBar: AppBar(
                  title: const Text('FRC Scout'),
                ),
                body: teamselection.Page(screendata: widget.screendata),
              )
        }
        // routes: <String, WidgetBuilder>{
        //   '/': (BuildContext context) =>
        //       teamselection.Page(screendata: widget.screendata),
        //   // (BuildContext context) => nav.build(context),
        //   '/teams': (BuildContext context) =>
        //       teamselection.Page(screendata: widget.screendata),
        // },
        // home: nav.build(context),
        );
  }
}
