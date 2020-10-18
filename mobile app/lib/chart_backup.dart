import './chart_backup2_redexample.dart';
import 'package:flutter/material.dart';


class ChartPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(24, 24, 24, 1.0),
        canvasColor: Color.fromRGBO(46, 49, 49, 1.0),
        brightness: Brightness.dark,
      ),
      home: ChartListView(
        items: List<ListItem>.generate(5,
              (i) => HeadingItem("Recipe $i"),
        ),
      ),
    );
  }
}