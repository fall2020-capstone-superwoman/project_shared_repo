import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import './chart_input.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;



class ChartViewPage extends StatelessWidget {
  final recipeList = fetchData();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Passing Data',
      home:
      recipeScreen(
          recipes: Recipe('recipeList[0]', recipeList)
        // List.generate(
        //   20,
        //       (i) =>
        //       Recipe(
        //         'Recipe $i',
        //         'A description of what needs to be done for Recipe $i',
        //       ),
        // ),
      ),
    );
  }
}

class recipeScreen extends StatelessWidget {
  final List<Recipe> recipes;

  recipeScreen({Key key, @required this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recipes[index].title),
            // When a user taps the ListTile, navigate to the DetailScreen.
            // Notice that you're not only creating a DetailScreen, you're
            // also passing the current recipe through to it.
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(recipe: recipes[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  // Declare a field that holds the Recipe.
  final Recipe recipe;

  // In the constructor, require a Recipe.
  DetailScreen({Key key, @required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Recipe to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(recipe.description),
      ),
    );
  }
}

Future<List<Model>> fetchData() async {
  final response = jsonDecode(await rootBundle.loadString('assets/recipes.json'));
  List<Model>.from(
      json.decode(response.body)
          .map((data) => Model.fromJson(data))
  );
}

