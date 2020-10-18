import 'dart:convert';
import 'package:flutter/material.dart';
import './chart_input.dart';
import 'dart:async';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;


class ChartViewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Recipe> chartData = []; // list for storing the last parsed Json data
  List<NutrientData> nutritionData = [];

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
  Future loadNutrientData() async{
  loadRecipes();
  for (int i = 0; i < chartData.length; i++) {
  for (int j=0; j < chartData[i].nutrition_info.length; j++) {
  nutritionData.add(NutrientData(chartData[i].recipe_title, chartData[i].nutrition_info[j].nutrient, chartData[i].nutrition_info[j].pct_daily));
  }
  }
  return nutritionData;
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
          title: Text('Flutter listview with json'),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        chartData[index].recipe_title,
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: chartData[index].nutrition_info.length,
                          itemBuilder: (BuildContext ctxt, int i) {
                            return Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(chartData[index].nutrition_info[i].nutrient),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(chartData[index].nutrition_info[i].amount.toString()+chartData[index].nutrition_info[i].unit),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(f.format(chartData[index].nutrition_info[i].pct_daily)),
                                  )
                                ]);
                          })
                    ]),
              ),
            );
          },
          itemCount: chartData.length,
        )
    );
  }
}
class NutrientData{
  NutrientData(this.recipe_title, this.nutrient, this.pct_daily);
  final String recipe_title;
  final String nutrient;
  final double pct_daily;
}
