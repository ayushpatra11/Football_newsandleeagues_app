import 'package:flutter/material.dart';
import 'package:pltracker/Router.dart';
import 'package:pltracker/blocs/CompetitionListBloc.dart';
import 'package:pltracker/models/CompetitionList.dart';
import 'package:pltracker/networking/Response.dart';

class CompetitionListView extends StatefulWidget {
  @override
  _CompetitionListState createState() => _CompetitionListState();
}

class _CompetitionListState extends State<CompetitionListView> {
  @override
  void initState() {
    super.initState();
    bloc.fetchCompetition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          title: Text('Leagues',
              style: TextStyle(color: Colors.black54, fontSize: 28)),
          backgroundColor: Color(0xFFe0fa52)),
      backgroundColor: Color(0xFF333333),
      body: RefreshIndicator(
        onRefresh: () => bloc.fetchCompetition(),
        child: StreamBuilder<Response<CompetitionList>>(
          stream: bloc.subject.stream,
          builder:
              (context, AsyncSnapshot<Response<CompetitionList>> snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return Loading(loadingMessage: snapshot.data.message);
                  break;
                case Status.COMPLETED:
                  return CompetitionListWidget(competition: snapshot.data.data);
                  break;
                case Status.ERROR:
                  return Error(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () => bloc.fetchCompetition(),
                  );
                  break;
                case Status.LOADING_PROGRESS:
                  break;
              }
            }
            return Container();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

class CompetitionListWidget extends StatelessWidget {
  final CompetitionList competition;

  const CompetitionListWidget({Key key, this.competition}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black54,
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return Divider(thickness: 4, color: Colors.black);
        },
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                Router.navigator.pushNamed(Router.teamListView,
                    arguments: CompetitionTeamsViewArguments(
                        competitionName: competition.competitions[index].name,
                        selectedCompetition:
                            competition.competitions[index].id));
              },
              child: SizedBox(
                child: Container(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                      child: Container(
                        width: 400,
                        height: 125,
                        child: Card(
                          elevation: 0,
                          color: Colors.black12,
                          margin: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                competition.competitions[index].name +
                                    " - " +
                                    competition.competitions[index].area.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontFamily: 'Roboto'),
                              ),
                              Container(
                                height: 5,
                              ),
                              Text(
                                "From " +
                                    competition.competitions[index]
                                        .currentSeason.startDate +
                                    " to " +
                                    competition.competitions[index]
                                        .currentSeason.endDate,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Roboto'),
                              ),
                              Text(
                                "Last update from the API: " +
                                    competition.competitions[index].lastUpdated
                                        .split("T")
                                        .first,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Roboto'),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
              ));
        },
        itemCount: competition.competitions.length,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
      ),
    );
  }
}

class Error extends StatelessWidget {
  final String errorMessage;

  final Function onRetryPressed;

  const Error({Key key, this.errorMessage, this.onRetryPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8),
          RaisedButton(
            color: Colors.white,
            child: Text('Retry', style: TextStyle(color: Colors.black)),
            onPressed: onRetryPressed,
          )
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  final String loadingMessage;

  const Loading({Key key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            loadingMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 24),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }
}
