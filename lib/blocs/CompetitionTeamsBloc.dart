import 'package:rxdart/rxdart.dart';
import 'package:pltracker/models/CompetitionTeams.dart';
import 'package:pltracker/networking/Response.dart';
import 'package:pltracker/repository/SoccerRepository.dart';

class CompetitionsTeamsBloc {
  SoccerRepository _soccerRepository;
  final BehaviorSubject<Response<CompetitionTeams>> _subject =
      BehaviorSubject<Response<CompetitionTeams>>();

  CompetitionsTeamsBloc() {
    _soccerRepository = SoccerRepository();
  }

  fetchTeams(int competitionId) async {
    _subject.sink.add(Response.loading('Getting Teams.'));
    try {
      CompetitionTeams teams =
          await _soccerRepository.fetchCompetitionTeams(competitionId);
      _subject.sink.add(Response.completed(teams));
    } catch (e) {
      _subject.sink.add(Response.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<Response<CompetitionTeams>> get subject => _subject;
}
