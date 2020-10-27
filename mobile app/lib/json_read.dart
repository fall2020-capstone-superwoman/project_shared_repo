import './chart_input.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

List<Recipe> chartData = []; // list for storing the last parsed Json data
List<List<NutrientData>> nutritionData = [];
List<NutrientData> nutritionPerRecipe = [];


Future<String> _loadRecipeAsset() async {
  return await rootBundle.loadString('assets/recipes.json');
}

Future loadRecipes() async {
  String jsonString = await _loadRecipeAsset();
  final jsonResponse = json.decode(jsonString);
    for(Map i in jsonResponse) {
      chartData.add(Recipe.fromJson(i)); // Deserialization step 3
    }
  for (int i = 0; i < chartData.length; i++) {
    nutritionPerRecipe = [];
    for (int j = chartData[i].nutrition_info.length-1; j >= 0; j--) {
      nutritionPerRecipe.add(NutrientData(chartData[i].nutrition_info[j].nutrient, chartData[i].nutrition_info[j].pct_daily));
    }
    nutritionData.add(nutritionPerRecipe);
  }
  return nutritionData;
}
