import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:war_machines/api/api.dart';
import 'package:war_machines/routes/home/home_screen.dart';
import 'package:war_machines/routes/tank/tank_screen.dart';

class Application {
  Application._internal()
      : router = Router(),
        api = WarmachinesApi("https://warmachinespython.appspot.com/graphql") {
    _buildRoutes();
  }

  static Application _instance;

  static Application get instance {
    if (_instance == null) {
      _instance = Application._internal();
    }
    return _instance;
  }

  final Router router;
  final WarmachinesApi api;

  void _buildRoutes() {
    WarmachinesRoute route = HomeRoute();
    router.define(route.routePath,
        handler: route.handler, transitionType: route.transitionType);
    WarmachinesRoute tankRoute = TankRoute();
    router.define(tankRoute.routePath,
        handler: tankRoute.handler, transitionType: tankRoute.transitionType);
  }
}

abstract class WarmachinesRoute {
  WarmachinesRoute(
    this.routePath, {
    this.transitionType,
  }) {
    this.handler = Handler(handlerFunc: this.build);
  }

  Handler handler;
  String routePath;
  TransitionType transitionType;

  Widget build(BuildContext context, Map<String, List<String>> parameters);
}
