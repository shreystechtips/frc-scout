import 'package:flutter/material.dart';
import '../helper/bluealliance.dart' as bluealliance;
import '../helper/appdata.dart' as appdata;
import '../helper/constants.dart' as constants;
import 'dart:convert';

class Page extends StatelessWidget {
  final appdata.ScreenData screendata;
  final TextEditingController txtQuery = TextEditingController();
  final GlobalKey<RefreshIndicatorState> indicator =
      GlobalKey<RefreshIndicatorState>();

  Page({super.key, required this.screendata});

  List<dynamic> getItems() {
    return jsonDecode(
        screendata.prefs.getString(constants.TEAM_KEY, def: '[]'));
  }

  List<dynamic> searchItems(List<dynamic> items, String query) {
    query = query.trim().toLowerCase();
    if (query.isEmpty) {
      return items;
    }
    return items.where((element) {
      return element['team_number'].toString().toLowerCase().contains(query) ||
          element['nickname'].toLowerCase().contains(query);
    }).toList();
  }

  Future<void> onRefresh(BuildContext context) async {
    bool response = false;

    await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Notice'),
              content: const Text(
                  'Do you really want to refresh, this may take a bit'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    response = true;
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ));
    if (response) {
      await bluealliance.TBARequest.getTeams(
          save: true, prefs: screendata.prefs, key: constants.TEAM_KEY);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> items = getItems();
    List<dynamic> showItems = items;
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    return Scaffold(
      body: Column(children: <Widget>[
        TextFormField(
          controller: txtQuery,
          onChanged: (query) {
            showItems = searchItems(items, query);
          },
          decoration: InputDecoration(
            hintText: "Search",
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                txtQuery.text = '';
                showItems = items;
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
                    return ListTile(
                        visualDensity:
                            const VisualDensity(horizontal: 0, vertical: -4),
                        title: Text(
                            '${showItems[index]['team_number']}: ${showItems[index]['nickname']}'),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('Alert'),
                                    content: Text(
                                        'This is an alert $index,\n ${arguments["teamnum"]}'),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                    ],
                                  ));
                        });
                  },
                )))
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => indicator.currentState?.show()),
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
