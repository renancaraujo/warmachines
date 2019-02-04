import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:war_machines/application.dart';
import 'package:war_machines/schema/schema.dart';

class HomeRoute extends WarmachinesRoute {
  HomeRoute() : super("/", transitionType: TransitionType.fadeIn);

  @override
  Widget build(BuildContext context, Map<String, List<String>> parameters) =>
      _HomeScreen();
}

class _HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  Future<AllNationsResponse> queryResponse;

  @override
  void initState() {
    queryResponse = Application.instance.api.queryAllNations();
    super.initState();
  }

  Future handleRefresh() {
    setState(() {
      queryResponse = Application.instance.api.queryAllNations();
    });
    return queryResponse;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("War machines"),
      ),
      body: Container(
          child: FutureBuilder(
              future: queryResponse,
              builder: (BuildContext context,
                  AsyncSnapshot<AllNationsResponse> snapshot) {
                if (snapshot.hasData) {
                  AllNationsResponse nationsResponse = snapshot.data;
                  return buildSuccess(context, nationsResponse);
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })),
    );
  }

  Widget buildSuccess(
      BuildContext context, AllNationsResponse nationsResponse) {
    List<Nation> nations = nationsResponse.nations;
    return RefreshIndicator(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 36.0),
          itemBuilder: (BuildContext context, int index) {
            return _NationCard(nations[index]);
          },
          itemCount: nations.length,
        ),
        onRefresh: handleRefresh);
  }
}

class _NationCard extends StatelessWidget {
  const _NationCard(this.nation, {Key key}) : super(key: key);

  final Nation nation;

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          _NationCardTitle(nation),
          _NationCardTanks(nation.tanks)
        ],
      );
}

class _NationCardTitle extends StatelessWidget {
  _NationCardTitle(final Nation nation, {Key key})
      : title = nation.name,
        imageUrl = nation.flag,
        super(key: key);

  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.only(top: 30.0, bottom: 20.0, left: 16.0),
      child: Row(
        children: <Widget>[
          Container(
            child: Image.network(imageUrl, width: 45.0),
            margin: EdgeInsets.only(right: 10.0),
          ),
          Flexible(
            flex: 1,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
            ),
          )
        ],
      ));
}

class _NationCardTanks extends StatelessWidget {
  const _NationCardTanks(this.tanks);

  final List<Tank> tanks;

  @override
  Widget build(BuildContext context) => Container(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tanks.length,
          itemBuilder: (BuildContext context, int index) {
            return buildTank(context, tanks[index], index);
          },
        ),
        padding: EdgeInsets.only(left: 16.0),
        height: 400.0,
      );

  Widget buildTank(BuildContext context, Tank tank, int index) =>
      GestureDetector(
        onTap: () {
          Application.instance.router.navigateTo(context,
              "/tank?photo=${Uri.encodeComponent(tank.photos[0])}&id=${tank.id}");
        },
        child: Container(
          width: 250.0,
          padding: EdgeInsets.only(right: 15.0),
          child: Hero(
            tag: tank.id,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(tank.photos[0]), fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
            ),
          ),
        ),
      );
}
