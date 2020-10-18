class Recipe {
  final int user_ID;
  final int request_ID;
  final String request_time;
  final String recipe_title;
  final List<Nutrition_info> nutrition_info;


  Recipe(
      {this.user_ID, this.request_ID, this.request_time, this.recipe_title, this.nutrition_info});


  factory Recipe.fromJson(Map<String, dynamic> parsedJson) {

    var list = parsedJson['Nutrition_Info'] as List<dynamic>;
    print(list.runtimeType);
    List<Nutrition_info> nutritionlist = list.map((i) => Nutrition_info.fromJson(i)).toList();

    return Recipe(
        user_ID: parsedJson['User_ID'],
        request_ID: parsedJson['Request_ID'],
        request_time: parsedJson['Request_time'],
        recipe_title: parsedJson['Recipe_title'],
        nutrition_info: nutritionlist
    );
  }
}

class Nutrition_info{
  final String nutrient;
  final int amount;
  final String unit;
  final double pct_daily;

  Nutrition_info({
    this.nutrient,
    this.amount,
    this.unit,
    this.pct_daily,
  });

  factory Nutrition_info.fromJson(Map<String, dynamic> parsedJson){
    return Nutrition_info(
      nutrient: parsedJson['Nutrient'],
      amount: parsedJson['Amount'],
      unit: parsedJson['Unit'],
      pct_daily: parsedJson['Pct_Daily'],
    );
  }
}