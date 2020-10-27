import 'dart:convert';
import 'package:flutter/material.dart';
import './chart_input.dart';
import 'dart:async';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;

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
  final List<Recipe> chartData = [];
  final _savedRecipes = Set<Recipe>();
   // list for storing the last parsed Json data


  Future<String> _loadRecipeAsset() async {
    return await rootBundle.loadString('assets/recipes.json');
  }

  Future loadRecipes() async {
    String jsonString = await _loadRecipeAsset();
    final jsonResponse = json.decode(jsonString);
    setState(() {
      for(Map i in jsonResponse) {
        chartData.add(Recipe.fromJson(i)); // Deserialization step
      }
    });
  }

  var f = NumberFormat("#%");


  Widget _buildList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        // return new Card(
        //     child: Padding(
        //         padding: const EdgeInsets.only(
        //             top: 15.0, bottom: 15.0, left: 16.0, right: 16.0),
        //         child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: <Widget>[
                      _buildRow(chartData[index]);
                    // ]
        //         ),
        //   ),
        // );
      },
      itemCount: chartData.length,
    );
  }

  Widget _buildRow(Recipe recipe) {
    final alreadySaved = _savedRecipes.contains(recipe.recipe_title);

    return ListTile(
      title: Text(recipe.recipe_title, style: TextStyle(fontSize: 16.0)),
      trailing: Icon(alreadySaved ? Icons.check_box: Icons.check_box_outline_blank),
      onTap: () {
        setState(() {
          if(alreadySaved) {
            _savedRecipes.remove(recipe);
          } else {
            _savedRecipes.add(recipe);
          }
        }
        );
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context) {
              final Iterable<ListTile> tiles = _savedRecipes.map((Recipe recipe) {
                return ListTile(
                  title: Text(recipe.recipe_title, style: TextStyle(fontSize: 16.0)),
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
                  body: ListView(children: divided)
              );
            }
        )
    );
  }

  Widget build(BuildContext context) {
    return Scaffold (
        appBar: AppBar(
          title: Text("Compare Recipes"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.compare_arrows), onPressed:
            _pushSaved)
          ],
        ),
        body: _buildList());

  }
}