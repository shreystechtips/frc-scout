import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:frc_scout/screens/home/home_bottombar.dart' as home;
import 'package:frc_scout/screens/matchpage/match_bottombar.dart' as match;
import 'helper/appdata.dart' as appdata;
import 'helper/constants.dart' as constants;
import 'helper/bluealliance.dart' as bluealliance;
import 'screens/teamselection.dart' as teamselection;

Future main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  appdata.AppData prefs = await appdata.AppData.create();
  if (prefs.getString(constants.TEAM_DATA_KEY) == '') {
    bluealliance.TBARequest.getTeams(
        save: true, prefs: prefs, key: constants.TEAM_DATA_KEY);
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
  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              home.HomeNav(screendata: widget.screendata),
        ),
        GoRoute(
          path: '/team-selection',
          builder: (context, state) => Scaffold(
            appBar: AppBar(
              title: const Text('Team Selection'),
            ),
            body: teamselection.Page(screendata: widget.screendata),
          ),
        ),
        GoRoute(
            path: '/match-page',
            builder: (context, state) => PopScope(
                  canPop: false,
                  child: match.HomeNav(screendata: widget.screendata),
                ))
      ],
    );

    return MaterialApp.router(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
