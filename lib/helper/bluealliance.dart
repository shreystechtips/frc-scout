import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:sprintf/sprintf.dart';
import './appdata.dart' as appdata;
import 'package:frc_scout/helper/constants.dart' as constants;

// ignore: constant_identifier_names
const String TBABaseURI = 'https://www.thebluealliance.com/api/v3';

class TBARequest {
  static final Map<String, String> requestHeaders = {
    'Accept': 'application/json',
    'X-TBA-Auth-Key': dotenv.env['TBA_KEY'].toString(),
  };

  static Future<Map<int, Map<String, dynamic>>> getTeams(
      {bool save = false, appdata.AppData? prefs, String? key}) async {
    Map<int, Map<String, dynamic>> teams = {};
    int currPage = 0;
    String builder = '%s/teams/%d/simple';
    String res = await getRequest(sprintf(builder, [TBABaseURI, currPage]));
    List<dynamic> json = jsonDecode(res);
    while (json.isNotEmpty) {
      for (var team in json) {
        teams[team['team_number'] as int] = {
          'team_number': team['team_number'],
          'nickname': team['nickname']
        };
      }
      currPage++;
      res = await getRequest(sprintf(builder, [TBABaseURI, currPage]));
      json = jsonDecode(res);
    }
    Map<String, dynamic> teamData = Map.fromEntries(teams.entries
        .map((entry) => MapEntry(entry.key.toString(), entry.value)));

    if (save) {
      String encodedTeams = jsonEncode(
        teamData,
      );
      prefs!.setString(key!, encodedTeams);
    }

    return teams;
  }

  static Future<String> getRequest<Object>(String uri) async {
    Response res = await get(Uri.parse(uri), headers: requestHeaders);

    if (res.statusCode == 200) {
      return res.body;
    } else {
      throw "Unable to retrieve data.";
    }
  }

  static Map<int, Map<String, dynamic>> parsedTeamData = {};

  static Map<int, Map<String, dynamic>> getTeamsFromPrefs(appdata.AppData prefs,
      [bool forceReload = false]) {
    if (parsedTeamData.isEmpty || forceReload) {
      String teamData = prefs.getString(constants.TEAM_DATA_KEY, def: '{}');
      parsedTeamData = customDecoder(teamData);
    }
    return parsedTeamData;
  }

  static Map<int, Map<String, dynamic>> customDecoder(String json) {
    Map<String, dynamic> jsonData = jsonDecode(json);
    Map<int, Map<String, dynamic>> teams = {};
    for (var team in jsonData.entries) {
      teams[int.parse(team.key)] = {
        'team_number': team.value['team_number'],
        'nickname': team.value['nickname']
      };
    }
    return teams;
  }
}
