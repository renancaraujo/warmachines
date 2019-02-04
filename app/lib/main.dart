import 'package:flutter/material.dart';
import 'package:war_machines/application.dart';

void main() => runApp(MyApp(Application.instance));

class MyApp extends StatelessWidget {
  MyApp(this.application);

  final Application application;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: application.router.generator,
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primarySwatch: Colors.orange, brightness: Brightness.dark),
    );
  }
}
