import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:war_machines/application.dart';
import 'package:war_machines/schema/schema.dart';

class TankRoute extends WarmachinesRoute {
  TankRoute() : super("/tank", transitionType: TransitionType.fadeIn);

  @override
  Widget build(BuildContext context, Map<String, List<String>> parameters) =>
      _TankScreen(photo: parameters["photo"][0], id: parameters["id"][0]);
}

class _TankScreen extends StatefulWidget {
  final String photo;
  final String id;

  const _TankScreen({Key key, this.photo, this.id}) : super(key: key);

  @override
  _TankScreenState createState() {
    return _TankScreenState();
  }
}

class _TankScreenState extends State<_TankScreen>
    with TickerProviderStateMixin<_TankScreen> {
  Future<TankByIdResponse> queryTankById;
  ScrollController scrollController;
  double scrolled;
  final double magnitude = 700;

  @override
  void initState() {
    queryTankById = Application.instance.api.queryTankById(widget.id);
    scrollController = ScrollController()..addListener(handleScroll);
    scrolled = 0;
    super.initState();
  }

  void handleScroll() {
    setState(() {
      scrolled = scrollController.offset / 1;
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double alignment = scrolled.clamp(-100, magnitude) / magnitude;
    double opacity =
        (1 - (scrolled.clamp(0, magnitude * 1.1) / magnitude * 1.1))
                .clamp(0, 1) /
            1;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
              child: Container(
            decoration: BoxDecoration(color: Colors.black),
          )),
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            double maxHeight = constraints.maxHeight;
            double actualHeight = maxHeight * (1 - (alignment * 0.5));
            return Opacity(
              opacity: opacity,
              child: Hero(
                  tag: widget.id,
                  child: Container(
                    height: actualHeight,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(widget.photo),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  )),
            );
          }),
          Container(
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder(
              future: queryTankById,
              builder: (BuildContext context,
                  AsyncSnapshot<TankByIdResponse> snapshot) {
                if (snapshot.hasData) {
                  Tank tank = snapshot.data.tank;
                  return _TankInfo(
                      tank: tank, scrollController: scrollController);
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TankInfo extends StatefulWidget {
  final Tank tank;
  ScrollController scrollController;

  _TankInfo({Key key, this.tank, this.scrollController}) : super(key: key);

  @override
  _TankInfoState createState() {
    return _TankInfoState();
  }
}

class _TankInfoState extends State<_TankInfo>
    with TickerProviderStateMixin, AfterLayoutMixin<_TankInfo> {
  AnimationController yOffsetAnimationController;
  Animation<double> yOffsetAnimation;

  AnimationController xOffsetAnimationController;
  Animation<double> xOffsetAnimation;

  double yOffset;
  double xOffset;

  double xOffsetStart;

  final double initial = 50;

  void handleYOffsetAnimation() {
    setState(() {
      yOffset = yOffsetAnimation.value;
    });
  }

  void handleXOffsetAnimation() {
    setState(() {
      xOffset = xOffsetAnimation.value;
    });
  }

  @override
  void initState() {
    super.initState();
    xOffset = 0;
    yOffset = initial;
    yOffsetAnimationController = AnimationController(vsync: this)
      ..addListener(handleYOffsetAnimation);
    xOffsetAnimationController = AnimationController(vsync: this)
      ..addListener(handleXOffsetAnimation);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    yOffsetAnimation = Tween<double>(begin: initial, end: 0).animate(
        CurvedAnimation(
            parent: yOffsetAnimationController, curve: Curves.easeOutExpo));
    yOffsetAnimationController
      ..value = 0.0
      ..duration = Duration(milliseconds: 1350)
      ..forward();
  }

  TickerFuture animateX(double to){
    xOffsetAnimation = Tween<double>(begin: xOffset, end: to).animate(
        CurvedAnimation(
            parent: xOffsetAnimationController, curve: Curves.easeOutSine));
    xOffsetAnimationController
      ..value = 0.0
      ..duration = Duration(milliseconds: 350);
    return xOffsetAnimationController.forward();
  }

  @override
  void dispose() {
    yOffsetAnimationController.dispose();
    xOffsetAnimationController.dispose();
    super.dispose();
  }

  void onHorizontalDragStart(DragStartDetails details){
    xOffsetAnimationController.stop();
    xOffsetStart = xOffset;
  }

  void onHorizontalDragUpdate(DragUpdateDetails details){
    double nextX = xOffset + details.delta.dx;
    if(nextX < 0){
      return;
    }
    setState(() {
      xOffset = nextX;
    });
  }

  void onHorizontalDragEnd(DragEndDetails details) async{
    final double halfScreen = MediaQuery.of(context).size.width * 0.35;
    if(xOffset < halfScreen){
      animateX(0);
      return;
    }
    Application.instance.router.pop(context);
  }
  void onHorizontalDragCancel(){
    animateX(0);
  }

  @override
  Widget build(BuildContext context) {

    final double swipeFactor = (1.0 - (xOffset / (MediaQuery.of(context).size.width * 0.65))).clamp(0.0, 1.0);
    Matrix4 innerMatrix = Matrix4.identity()..translate(xOffset, yOffset);
    double innerOpacity = swipeFactor;

    Matrix4 outerMatrix = Matrix4.identity()..translate(0.0, yOffset + ( swipeFactor * 20.0 )) ;
    double outerOpacity = ((yOffset - initial).abs() / initial).clamp(0.0, innerOpacity*1.5).clamp(0.0, 1.0);


    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return GestureDetector(
        onHorizontalDragStart: onHorizontalDragStart,
        onHorizontalDragUpdate: onHorizontalDragUpdate,
        onHorizontalDragEnd: onHorizontalDragEnd,
        onHorizontalDragCancel: onHorizontalDragCancel,
        child: Transform(
            transform: outerMatrix,
            child: Opacity(
              opacity: outerOpacity,
              child: Container(
                  width: constraints.maxWidth,
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [
                            0.0,
                            0.9
                          ],
                          colors: [
                            Colors.black.withAlpha(0),
                            Colors.black,
                          ])),
                  child: Transform(
                    transform: innerMatrix,
                    child: Opacity(
                      opacity: innerOpacity,
                      child: ListView(
                        controller: widget.scrollController,
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height - 250),
                        physics: BouncingScrollPhysics(),
                        children: <Widget>[
                          Text(
                            widget.tank.name,
                            style: TextStyle(
                                fontSize: 72.0,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2.0),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(widget.tank.nation.name),
                                Text("${widget.tank.period.name}")
                              ],
                            ),
                          ),
                          Container(
                            height: 1.0,
                            decoration: BoxDecoration(color: Colors.white),
                            margin: EdgeInsets.only(top: 20, bottom: 50),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 400),
                            child: Text(
                              widget.tank.description,
                              style: TextStyle(
                                  letterSpacing: 1.0, fontSize: 19.0, height: 1.2),
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
            )),
      );
    });
  }
}
