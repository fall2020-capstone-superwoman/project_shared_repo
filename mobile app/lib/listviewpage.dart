import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class ListViewPage extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<ListViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Compare Recipes"),
      ),
      body: Container(
        child: Center(
          // Use future builder and DefaultAssetBundle to load the local JSON file
          child: FutureBuilder(
            future: DefaultAssetBundle
                .of(context)
                .loadString('assets/recipes.json'),
            builder: (context, snapshot) {
              // Decode the JSON
              var new_data = jsonDecode(snapshot.data.toString());

              return ListView.builder(
                // Build the ListView
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // Text("user_ID: " + new_data[index]['User_ID'].toString()),
                        // Text("request_ID: " + new_data[index]['Request_ID'].toString()),
                        // Text("request_time: " + new_data[index]['Request_time'].toString()),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                              "Recipe " + (index + 1).toString() + ": " + new_data[index]['Recipe_title'], style: TextStyle(fontSize: 20.0)),
                        ),
                        Text(
                            "nutrient: " + new_data[index]['Nutrition_Info'][0]['Nutrient'].toString()),
                        // Text(
                        //     "Amount: " + new_data[index]['Amount'].toString()),
                        // Text(
                        //     "Unit: " + new_data[index]['Unit']),
                        // Text("Pct_Daily: " + new_data[index]['Pct_Daily'].toString()),
                      ],
                    ),
                  );
                },
                itemCount: new_data == null ? 0 : new_data.length,
              );
            },
            // future: DefaultAssetBundle.of(context).loadString('assets/recipes.json'),),
          ),
        ),
      ),
    );
  }
}






class Recipe {
  final String user_ID;
  final String request_ID;
  final String request_time;
  final String recipe_title;
  final String nutrient;
  final String amount;
  final String unit;
  final String pct_daily;

  Recipe._({this.user_ID, this.request_ID, this.request_time, this.recipe_title, this.nutrient, this.amount, this.unit, this.pct_daily});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return new Recipe._(
      user_ID: json['user_ID'],
      request_ID: json['request_ID'],
      request_time: json['request_time'],
      recipe_title: json['recipe_title'],
      nutrient: json['nutrient'],
      amount: json['amount'],
      unit: json['unit'],
      pct_daily: json['pct_daily'],
    );
  }
}
