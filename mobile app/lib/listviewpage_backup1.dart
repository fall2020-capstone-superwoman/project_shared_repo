import 'dart:convert';
import 'package:flutter/material.dart';
import './chart_input.dart';
import 'dart:async';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'chartviewpage.dart';


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
  Set<int> data = Set<int>();

  Future<String> _loadRecipeAsset() async {
    return await rootBundle.loadString('assets/recipes.json');
  }

  Future loadRecipes() async {
    String jsonString = await _loadRecipeAsset();
    final jsonResponse = json.decode(jsonString);
    setState(() {
      for (Map i in jsonResponse) {
        chartData.add(Recipe.fromJson(i)); // Deserialization step
      }
    });
  }

  var f = NumberFormat("#%");

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Recipes'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.compare_arrows), onPressed: _pushSaved)
          ],
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 15.0, bottom: 15.0, left: 16.0, right: 16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        title: Text(chartData[index].recipe_title),
                        trailing: Icon(_savedRecipes.contains(
                            chartData[index].recipe_title)
                            ? Icons.check_box
                            : Icons.check_box_outline_blank),
                        onTap: () {
                          setState(() {
                            if (_savedRecipes.contains(
                                chartData[index].recipe_title)) {
                              _savedRecipes.remove(
                                  chartData[index].recipe_title);
                              data.remove(index);
                            } else {
                              _savedRecipes.add(chartData[index].recipe_title);
                              data.add(index);
                            }
                          }
                          );
                        },
                      ),
                    ]
                ),
              ),
            );
          },
          itemCount: chartData.length,
        )
    );
  }

  void _pushData() {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) =>
            new MyHomePage(
                data: data
            )
        ));
  }

  //
  // void _loadSavedRecipes(){
  //
  // }
  // }


  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) {
            final Iterable<ListTile> tiles = _savedRecipes.map((
                String recipe_title) {
              return ListTile(
                title: Text(recipe_title, style: TextStyle(fontSize: 16.0)),
                // subtitle: Text("two cups of flour"),
              );
            });
            final List<Widget> divided = ListTile.divideTiles(
                context: context,
                tiles: tiles
            ).toList();
            return Scaffold(
              appBar: AppBar(
                title: Text("Saved Recipes"),
              ),

              body: ChartViewPage(),
              // body: ListView(children: divided)
            );
          }
      ),
    );
  }
}
