import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:sprintf/sprintf.dart';

// ignore: constant_identifier_names
const String TBABaseURI = 'https://www.thebluealliance.com/api/v3';

class Team {
  final int teamNum;
  final String nickname;

  const Team({required this.teamNum, required this.nickname});

  factory Team.fromJson(Map<String, dynamic> json) {
    // int.parse(json['key'].toString().characters.skip(3).toString())
    return Team(teamNum: json['team_number'], nickname: json['nickname']);
  }

  Map<String, dynamic> toJson() =>
      {'team_number': teamNum, 'nickname': nickname};
}

class TBARequest {
  static final Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'X-TBA-Auth-Key': dotenv.env['TBA_KEY'].toString()
  };

  static Future<List<Team>> getTeams() async {
    List<Team> teams = [];
    int currPage = 0;
    String builder = '%s/teams/%d/simple';
    String res = await getRequest(sprintf(builder, [TBABaseURI, currPage]));
    List<dynamic> json = jsonDecode(res);
    while (json.isNotEmpty) {
      for (var team in json) {
        teams.add(Team.fromJson(team));
      }
      currPage++;
      res = await getRequest(sprintf(builder, [TBABaseURI, currPage]));
      json = jsonDecode(res);
      print(currPage);
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
