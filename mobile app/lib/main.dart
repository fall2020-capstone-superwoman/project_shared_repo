import 'package:flutter/material.dart';
import './recipeinputpage.dart';
import './listviewpage_backup1.dart';
import './chartviewpage.dart';
import './biopage.dart';


void main() {
  runApp(MyApp());
      // new MaterialApp(
      // theme: ThemeData(
      //   primarySwatch: Colors.indigo,
      //   accentColor: Colors.indigoAccent,
      //   appBarTheme: AppBarTheme(
      //     color: Color.fromRGBO(90, 50, 142, 1),
      //   ),
      // ),
      // home: new MyTabs()
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: new MyTabs()
    );
  }
}

class MyTabs extends StatefulWidget {
  @override
  MyTabsState createState() => new MyTabsState();
}

class MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin {

  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length:4);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
        bottomNavigationBar: new Material(
            // color: Colors.indigoAccent,
            child: new TabBar(
                controller: controller,
                tabs: <Tab>[
                  new Tab(icon: new Icon(Icons.add_box), text: "Add Recipe",),
                  new Tab(icon: new Icon(Icons.compare_arrows), text: "Compare"),
                  new Tab(icon: new Icon(Icons.insert_chart), text: "Charts"),
                  new Tab(icon: new Icon(Icons.face), text: "My Details"),
                ]
            )

        ),
        body: new TabBarView(
            controller: controller,
            children: <Widget>[
              new RecipeInputPage(),
              new ListViewPage(),
              new ChartViewPage(),
              new BioPage(),
              // new recipe.main(),
            ]
        )
    );
  }
}
