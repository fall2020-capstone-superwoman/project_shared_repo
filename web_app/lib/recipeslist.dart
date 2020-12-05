import 'dart:convert';
import 'package:flutter/material.dart';
import './jsonstructure.dart';
import 'dart:async';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;
import './json_read.dart';
import './detailpage.dart';
import 'package:http/http.dart' as http;
import './recipeinputsearch.dart';
import './biopage2.dart';

class ListViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Recipe> chartData = []; // list for storing the last parsed Json data
  final _savedRecipes = Set<String>();
  List<Recipe> data = List<Recipe>();
  Recipe selectedRecipe;
  bool loading = false;
  int _currentIndex = 0;
  final List<Widget> _children = [BioPage(), RecipeInputPage()];

  Future<String> _loadRecipeAsset() async {
    return await rootBundle.loadString('assets/b_recipelist_heatmap_recommendation_horizontal.json');
  }

  // Future loadChartData() async {
  //   String jsonString = await _loadRecipeAsset();
  //   final jsonResponse = json.decode(jsonString);
  //   setState(() {
  //     for (Map i in jsonResponse) {
  //       chartData.add(Recipe.fromJson(i)); // Deserialization step
  //       print(i);
  //     }
  //   });
  // }

  Future loadChartData() async {
    final response = await http.post(
        'https://cors-anywhere.herokuapp.com/https://bbg5tf4j2d.execute-api.us-east-1.amazonaws.com/Test/ingredientstorecipes');

    if (response.statusCode == 200) {

      // If the server did return a 200 OK response,
      // then parse the JSON.

      final jsonResponse = json.decode(response.body);
        setState(() {
          for (Map i in jsonResponse) {
            // print(i);
            chartData.add(Recipe.fromJson(i)); // Deserialization step
          }
        });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load recipes - listview for comparing recipes.dart');
    }
  }

  var f = NumberFormat("#%");

  @override
  void initState() {
    loading = true;
    // super.initState();
    loadChartData();
    loading = false;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Recipes'),
        ),
        body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          loading == true
          ? CircularProgressIndicator()
          : Expanded(
            flex:1,
            child: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, bottom: 10.0, right: 16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        contentPadding:EdgeInsets.all(0),
                        title: Row(
                          children: <Widget>[
                            SizedBox(width:7),
                            Image.asset("assets/chili.png", color: chartData[index].spicy == 1? Colors.red: Colors.white, height: 20),
                            SizedBox(width:10),
                            Text(chartData[index].recipe_name, style: TextStyle(fontSize: 16.0)),
                          ],
                        ),
                        onTap: ()
                         {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => DetailPage(selectedRecipe: chartData[index])));
                          },
                          ),
                    ]
                )));
            },
          itemCount: chartData.length,
        )),
        ],
    )),
    // bottomNavigationBar: BottomNavigationBar(
    //   type: BottomNavigationBarType.fixed,
    //   currentIndex: _currentIndex,
    //   // backgroundColor: colorScheme.surface,
    //   // selectedItemColor: colorScheme.onSurface,
    //   // unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
    //   // selectedLabelStyle: textTheme.caption,
    //   // unselectedLabelStyle: textTheme.caption,
    //   onTap: (value) {
    //     // Respond to item press.
    //     setState(() => _currentIndex = value);
    //   },
    //   items: [
    //     BottomNavigationBarItem(
    //       label: 'My Details',
    //       icon: Icon(Icons.face),
    //     ),
    //     BottomNavigationBarItem(
    //       label: 'Search Recipes',
    //       icon: Icon(Icons.add_box_rounded),
    //     ),
    //   ],
    // ),
    );
  }

  List<Recipe> _savedRecipeData() {
    List<Recipe> savedRecipes = [];
    var present = false;
    for (var i = 0; i < chartData.length; i++) {
      if ((chartData[i].recipe_name == _savedRecipes.first) | (chartData[i].recipe_name ==
          _savedRecipes.last)) {
        savedRecipes.add(chartData[i]);
      }
    }
  }

  //
  // void _pushData() {
  //   if (data.length == 2) {
  //     Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (context) =>
  //               ChartViewPage(
  //                 data: data, nutritionDataChart: loadNutritionData(data),),
  //         ));
  //   } else if (data.length < 2){
  //
  //   }
  //
  //   }

  List<List<NutrientData>> loadNutritionData(data) {
    List<List<NutrientData>> nutritionDataChart = [];
    for (int i = 0; i < data.length; i++) {
      nutritionPerRecipe = [];
      for (int j = data[i].recipe_nutritionfacts.length - 1; j >= 0; j--) {
        print(data[i].recipe_nutritionfacts[j].percentDailyValue);
      }
      nutritionDataChart.add(nutritionPerRecipe);
    }
    return nutritionDataChart;
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) {
            final Iterable<ListTile> tiles = _savedRecipes.map((
                String recipe_title) {
              return ListTile(
                title: Text(recipe_title, style: TextStyle(fontSize: 20.0)),
              );
            });
            final List<Widget> divided = ListTile.divideTiles(
                context: context,
                tiles: tiles
            ).toList();
            return Scaffold(
              body: ListView(children: divided)
            );
          }
      ),
    );
  }
}


//Bottom Navigation Bar
//
