import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../helper/bluealliance.dart' as bluealliance;
import 'package:frc_scout/helper/appdata.dart' as appdata;
import 'package:frc_scout/helper/constants.dart' as constants;
import 'package:frc_scout/widgets/confirmdialog.dart' as confirmdialog;

class Page extends StatefulWidget {
  final appdata.ScreenData screendata;

  const Page({super.key, required this.screendata});

  @override
  PageState createState() => PageState();
}

class PageState extends State<Page> {
  final TextEditingController txtQuery = TextEditingController();
  final GlobalKey<RefreshIndicatorState> indicator =
      GlobalKey<RefreshIndicatorState>();
  Map<int, Map<String, dynamic>> items = {};
  Map<int, Map<String, dynamic>> showItems = {};

  @override
  void initState() {
    super.initState();
    items = getItems();
    showItems = items;
  }

  Map<int, Map<String, dynamic>> getItems([bool forceReload = true]) {
    return bluealliance.TBARequest.getTeamsFromPrefs(
        widget.screendata.prefs, true);
  }

  Map<int, Map<String, dynamic>> searchItems(
      Map<int, Map<String, dynamic>> items, String query) {
    query = query.trim().toLowerCase();
    if (query.isEmpty) {
      return items;
    }

    return Map.from(items)
      ..removeWhere((k, v) {
        return !v['team_number'].toString().toLowerCase().contains(query) &&
            !v['nickname'].toLowerCase().contains(query);
      });
  }

  Future<void> onRefresh(BuildContext context) async {
    bool response = await confirmdialog.acceptAction(
        context, 'Do you really want to refresh, this may take a bit');
    if (response) {
      await bluealliance.TBARequest.getTeams(
          save: true,
          prefs: widget.screendata.prefs,
          key: constants.TEAM_DATA_KEY);
      setState(() {
        items = getItems();
        showItems = items;
      });
      indicator.currentState?.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    final GoRouterState state = GoRouterState.of(context);
    final Map<String, dynamic> arguments = state.extra as Map<String, dynamic>;

    return Scaffold(
      body: Column(children: <Widget>[
        TextFormField(
          controller: txtQuery,
          onChanged: (query) {
            setState(() {
              showItems = searchItems(items, query);
            });
          },
          decoration: InputDecoration(
            hintText: "Search",
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  txtQuery.text = '';
                  showItems = items;
                });
              },
            ),
          ),
        ),
        Expanded(
            child: RefreshIndicator(
                key: indicator,
                onRefresh: () => onRefresh(context),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: showItems.length,
                  prototypeItem: const ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Text("948 - Newport Robotics Group 948"),
                  ),
                  itemBuilder: (context, index) {
                    var keys = showItems.keys.toList();
                    Map<String, dynamic> val = showItems[keys[index]]!;
                    return ListTile(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        title:
                            Text('${val['team_number']}: ${val['nickname']}'),
                        onTap: () {
                          context.push(arguments['nextPath'] ?? '/', extra: {
                            'team_data': val,
                            'senderPath': '/team-selection',
                          });
                        });
                  },
                )))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => indicator.currentState?.show()),
        tooltip: 'Refresh',
        heroTag: null,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
