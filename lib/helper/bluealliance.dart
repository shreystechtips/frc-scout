import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:sprintf/sprintf.dart';
import './appdata.dart' as appdata;

// ignore: constant_identifier_names
const String TBABaseURI = 'https://www.thebluealliance.com/api/v3';

class TBARequest {
  static final Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'X-TBA-Auth-Key': dotenv.env['TBA_KEY'].toString()
  };

  static Future<List<Map<String, dynamic>>> getTeams(
      {bool save = false, appdata.AppData? prefs, String? key}) async {
    List<Map<String, dynamic>> teams = [];
    int currPage = 0;
    String builder = '%s/teams/%d/simple';
    String res = await getRequest(sprintf(builder, [TBABaseURI, currPage]));
    List<dynamic> json = jsonDecode(res);
    while (json.isNotEmpty) {
      for (var team in json) {
        teams.add(
            {'team_number': team['team_number'], 'nickname': team['nickname']});
      }
      currPage++;
      res = await getRequest(sprintf(builder, [TBABaseURI, currPage]));
      json = jsonDecode(res);
      print(currPage);
    }

    if (save) {
      prefs!.setString(key!, jsonEncode(teams));
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
}

void test() {
  print(dotenv.env['TBA_KEY']);
}
