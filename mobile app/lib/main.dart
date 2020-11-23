import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './recipeinputsearch.dart';
import './recipeslist.dart';
import './biopage2.dart';
import './detailpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
       brightness: Brightness.light,
        primaryColor: Color(0xFFF37280),
        accentColor: Colors.deepOrange[600],
        appBarTheme: AppBarTheme(
          color: Color(0xFFF37280)
        ),

        // fontFamily: 'Georgia',

      ),
      home: new MyTabs()
    );
  }
}

class MyTabs extends StatefulWidget {
  @override
  MyTabsState createState() => new MyTabsState();
}

class MyTabsState extends State<MyTabs>{
    // with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    BioPage(),
    RecipeInputPage(),
  ];

  // TabController controller;

  // @override
  // void initState() {
  //   super.initState();
  //   controller = new TabController(vsync: this, length:2);
  // }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      backgroundColor: Color(0xFFF37280),
      bottomNavigationBar:
        BottomNavigationBar(
          backgroundColor:  Color(0xFFF37280),
          currentIndex: _selectedIndex,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.face,
                color: Colors.white,
              ),
                label: 'My Details',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_box,
                  color: Colors.white,
                ),
                label: 'Search Recipes',
              ),
            ],
            onTap: (index) {
              setState(() {
              _selectedIndex = index;
              });
            },
          ),
    body: Stack(
        children: [
          _buildOffstageNavigator(0),
          _buildOffstageNavigator(1),
         ],
        ),
    );
    }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          BioPage(),
          RecipeInputPage(),
        ].elementAt(index);
      },
    };
  }
  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        },
      ),
    );
  }
}


