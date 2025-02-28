class Recipe {
  final int recipe_id;
  final double aver_rate;
  final int review_nums;
  final int spicy;
  final String recipe_name;
  final String recipe_directions;
  final List<String> recipe_ingredients;
  final List<Nutrition_info> recipe_nutritionfacts;


  Recipe(
      {this.recipe_id, this.aver_rate, this.review_nums, this.spicy, this.recipe_name, this.recipe_directions, this.recipe_ingredients, this.recipe_nutritionfacts});


  factory Recipe.fromJson(Map<String, dynamic> parsedJson) {

    var list = parsedJson['recipe_nutrition_result'] as List<dynamic>;
    var ingredientsFromJson = parsedJson['recipe_ingredients'];
    List<String> ingredientlist = new List<String>.from(ingredientsFromJson);
    List<Nutrition_info> nutritionlist = list.map((i) => Nutrition_info.fromJson(i)).toList();

    return Recipe(
        recipe_id: parsedJson['recipe_id'],
        aver_rate: parsedJson ['aver_rate'],
        review_nums: parsedJson ['review_nums'],
        spicy: parsedJson['spicy'],
        recipe_name: parsedJson['recipe_name'],
        recipe_directions: parsedJson['recipe_directions'],
        recipe_ingredients: ingredientlist,
        recipe_nutritionfacts: nutritionlist
    );
  }
}

class Nutrition_info{
  final String name;
  final double amount;
  final double benchmark;
  // final String percentDailyValue;
  // final String displayValue;
  final String unit;
  final double benchmark_percentage;
  final int benchmark_flag;
  final List<String> cooccurrence_top_list;
  final List<String> raw_nutrition_top_list;

  Nutrition_info({
    this.name,
    this.amount,
    // this.percentDailyValue,
    // this.displayValue,
    this.unit,
    this.benchmark,
    this.benchmark_percentage,
    this.benchmark_flag,
    this.cooccurrence_top_list,
    this.raw_nutrition_top_list,
  });

  factory Nutrition_info.fromJson(Map<String, dynamic> parsedJson){
    var cooccurrenceFromJson = parsedJson['cooccurrence_top_list'] as List<dynamic>;
    var rawnutritionFromJson = parsedJson['raw_nutrition_top_list'] as List<dynamic>;
    List<String> cooccurrence_top_list = new List<String>.from(cooccurrenceFromJson);
    List<String> raw_nutrition_top_list = new List<String>.from(rawnutritionFromJson);

    return Nutrition_info(
      name: parsedJson['name'],
      amount: parsedJson['amount'],
      // percentDailyValue: parsedJson['percentDailyValue'],
      // displayValue: parsedJson['displayValue'],
      unit: parsedJson['unit'],
      benchmark: parsedJson['benchmark'],
      benchmark_percentage: parsedJson['benchmark_percentage'],
      benchmark_flag: parsedJson['benchmark_flag'],
      cooccurrence_top_list: cooccurrence_top_list,
      raw_nutrition_top_list: raw_nutrition_top_list,
    );
  }
}
//
class NutrientData{
  NutrientData(this.nutrient, this.datapoint);
  final String nutrient;
  final double datapoint;
}

class SuggestionData{
  SuggestionData(this.name, this.benchmark_percentage, this.cooccurrencetoplist, this.rawnutritiontoplist);
  final String name;
  final double benchmark_percentage;
  final List<String> cooccurrencetoplist;
  final List<String> rawnutritiontoplist;
}

class Preferences{
  String status;
  bool milk;
  bool eggs;
  bool fish;
  bool shellfish;
  bool treenuts;
  bool peanuts;
  bool wheat;
  bool soybean;
  bool nonspicy;
  List <String> excludeIngredients;
  List <String> includeIngredients;
  String nutritionPriority;

  Preferences(this.status, this.milk, this.eggs, this.fish, this.shellfish, this.treenuts, this.peanuts, this.wheat, this.soybean, this.nonspicy, this.excludeIngredients, this.includeIngredients, this.nutritionPriority);

  Map<String, dynamic> toJson() => {
  'status': status,
  'milk': milk,
  'eggs': eggs,
  'fish': fish,
  'shellfish': shellfish,
  'treenuts': treenuts,
  'peanuts': peanuts,
  'wheat': wheat,
  'soybean': soybean,
  'nonspicy': nonspicy,
  'excludeIngredients': excludeIngredients,
  'includeIngredients': includeIngredients,
  'nutritionPriority': nutritionPriority,
  };
}