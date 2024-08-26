import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frc_scout/helper/appdata.dart' as appdata;
import 'package:frc_scout/widgets/confirmdialog.dart' as confirmdialog;

class MatchPage extends StatefulWidget {
  final appdata.ScreenData screendata;
  const MatchPage({Key? key, required this.screendata}) : super(key: key);

  @override
  MatchPageState createState() => MatchPageState();
}

class MatchPageState extends State<MatchPage> {
  void exitMatch(GoRouter router) async {
    bool repsonse = await confirmdialog.acceptAction(
        context, "Are you sure you want to discard any match changes?");
    if (repsonse) {
      router.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final GoRouterState state = GoRouterState.of(context);
    final Map<String, dynamic> arguments = state.extra as Map<String, dynamic>;

    final GoRouter router = GoRouter.of(context);

    final Map<String, dynamic> teamData = arguments['team_data'];

    final String appBarText =
        '${teamData['team_number']} - ${teamData['nickname']}';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => exitMatch(router),
        ),
        title: Text(appBarText),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Match Page'),
            Text('Arguments: $arguments'),
          ],
        ),
      ),
    );
    // return Container();
  }
}
