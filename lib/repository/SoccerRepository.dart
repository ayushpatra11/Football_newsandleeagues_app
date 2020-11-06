import 'dart:async';

import 'package:pltracker/models/CompetitionList.dart';
import 'package:pltracker/models/CompetitionTeams.dart';
import 'package:pltracker/models/Team.dart';
import 'package:pltracker/networking/SoccerApiProvider.dart';

class SoccerRepository {
  SoccerApiProvider _provider = SoccerApiProvider();

  Future<CompetitionList> fetchCompetitions() async {
    final response = await _provider.get("competitions?plan=TIER_ONE");
    return CompetitionList.fromJson(response);
  }

  Future<CompetitionTeams> fetchCompetitionTeams(int competitionId) async {
    final response = await _provider
        .get("competitions/" + competitionId.toString() + "/teams");
    return CompetitionTeams.fromJson(response);
  }

  Future<Team> fetchTeam(int id) async {
    final response = await _provider.get("teams/" + id.toString());
    return Team.fromJson(response);
  }
}
