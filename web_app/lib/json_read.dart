import './jsonstructure.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:core';
import 'package:http/http.dart' as http;


List<Recipe> chartData = []; // list for storing the last parsed Json data
List<List<NutrientData>> nutritionData = [];
List<NutrientData> nutritionPerRecipe = [];



Future<String> _loadRecipeAsset() async {
  return await rootBundle.loadString('assets/b_recipelist_heatmap_recommendation_horizontal.json');
}


// Future loadRecipes() async {
//   String jsonString = await _loadRecipeAsset();
//   final jsonResponse = json.decode(jsonString);
//     for(Map i in jsonResponse) {
//       chartData.add(Recipe.fromJson(i)); // Deserialization step 3
//     }
//   for (int i = 0; i < chartData.length; i++) {
//     nutritionPerRecipe = [];
//     for (int j = chartData[i].recipe_nutritionfacts.length-1; j >= 0; j--) {
//       print(chartData[i].recipe_nutritionfacts[j].name);
//       nutritionPerRecipe.add(NutrientData(chartData[i].recipe_nutritionfacts[j].name,
//           chartData[i].recipe_nutritionfacts[j].benchmark_percentage));
//     }
//     nutritionData.add(nutritionPerRecipe);
//   }
//   return nutritionData;
// }

Future loadRecipes() async {
  final response = await http.post(
      'https://bbg5tf4j2d.execute-api.us-east-1.amazonaws.com/Test/ingredientstorecipes');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final jsonResponse = json.decode(response.body);
    for (Map i in jsonResponse) {
      chartData.add(Recipe.fromJson(i)); // Deserialization step 3
    }
    for (int i = 0; i < chartData.length; i++) {
      nutritionPerRecipe = [];
      for (int j = chartData[i].recipe_nutritionfacts.length - 1; j >= 0; j--) {
        nutritionPerRecipe.add(NutrientData(
            chartData[i].recipe_nutritionfacts[j].name,
            double.parse(chartData[i].recipe_nutritionfacts[j].percentDailyValue)));
      }
      nutritionData.add(nutritionPerRecipe);
    }
    return nutritionData;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load recipes - json_read.dart');
  }
}