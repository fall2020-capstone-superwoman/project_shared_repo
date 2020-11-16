import 'package:flutter/material.dart';
import './jsonstructure.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:easy_rich_text/easy_rich_text.dart';

class DetailPage extends StatelessWidget {
  final Recipe selectedRecipe;
  DetailPage({Key key, this.selectedRecipe}) : super(key: key);
  var f = NumberFormat("#%");
  List<int> nutritionFactIndex = [];
  List<SuggestionData> suggestionDataList = [];

  List<NutrientData> loadNutritionData(recipe) {
    List<String> nutrients = [
      "Folate",
      "Calcium",
      "Iron",
      "Cholesterol",
      "Protein",
      "Vitamin A - IU",
      "Vitamin C"
    ];
    List<NutrientData> nutritionDataChart = [];

    for (int i = 0; i < recipe.recipe_nutritionfacts.length; i++) {
      if (nutrients.contains(recipe.recipe_nutritionfacts[i].name)) {
        nutritionDataChart.add(NutrientData(
            recipe.recipe_nutritionfacts[i].name,
            recipe.recipe_nutritionfacts[i].benchmark_percentage));
      }
    }
    return nutritionDataChart;
  }

  void loadSuggestionData() {
    List<String> nutrients = [
      "Folate",
      "Calcium",
      "Iron",
      "Cholesterol",
      "Protein",
      "Vitamin A - IU",
      "Vitamin C"
    ];


    for (int i = 0; i < selectedRecipe.recipe_nutritionfacts.length; i++) {
      if (nutrients.contains(selectedRecipe.recipe_nutritionfacts[i].name)) {
        if (selectedRecipe.recipe_nutritionfacts[i].benchmark_flag == "deficiency") {
          suggestionDataList.add(SuggestionData(
              selectedRecipe.recipe_nutritionfacts[i].name,
              selectedRecipe.recipe_nutritionfacts[i].benchmark,
              selectedRecipe.recipe_nutritionfacts[i].benchmark_percentage,
              selectedRecipe.recipe_nutritionfacts[i].cooccurrence_top_list,
              selectedRecipe.recipe_nutritionfacts[i].raw_nutrition_top_list));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    loadSuggestionData();
    // final levelIndicator = Container(
    //   child: Container(
    //     child: LinearProgressIndicator(
    //         backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
    //         value: lesson.indicatorValue,
    //         valueColor: AlwaysStoppedAnimation(Colors.green)),
    //   ),
    // );


    final nutritionGraph = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("\nNutritional Facts", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 20.0),),
        SizedBox(height: 10.0),
        Container(
              padding: const EdgeInsets.all(7.0),
              child:
              SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(numberFormat: NumberFormat.percentPattern()),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  zoomPanBehavior: ZoomPanBehavior(
                      enablePanning: true
                  ),
                  series: <CartesianSeries>[
                    BarSeries<NutrientData, String>(
                        dataSource: loadNutritionData(selectedRecipe),
                        xValueMapper: (NutrientData row, _) => row.nutrient,
                        yValueMapper: (NutrientData row, _) => row.datapoint,
                        color: Color(0xFFF37280),
                        dataLabelSettings: DataLabelSettings(
                          // Renders the data label
                          isVisible: true,
                          labelAlignment: ChartDataLabelAlignment.outer,

                        )
                    ),
                  ]
            )
        ),
      ],

    );
    final saveButton = FloatingActionButton.extended(
      onPressed: () {

      },
      label: Text('Save Recipe', style: TextStyle(
          fontSize: 20
      )),
      icon: Icon(Icons.arrow_forward_ios),
      backgroundColor: Colors.pink,
    );
    final graphContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            // decoration: new BoxDecoration(
            //   image: new DecorationImage(
            //     // image: new AssetImage("drive-steering-wheel.jpg"),
            //     fit: BoxFit.cover,
            //   ),
            ),
        Container(
          // height: MediaQuery.of(context).size.height * 0.5,
          // // padding: EdgeInsets.all(40.0),
          // width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.white),
          child: Center(
            child: Column(
            children: <Widget> [nutritionGraph]
          ),
          ),
        ),
      ],
    );

    final recipeIngredients = RichText(
      text: TextSpan(
      text: selectedRecipe.recipe_name+ "\n\n",
      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF37280), fontSize: 20,),
      children: <TextSpan>[
      TextSpan(
        text: "Ingredients: ",
        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF37280), fontSize: 15),),
        TextSpan(
          text: selectedRecipe.recipe_ingredients.join(", "),
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 15)
        ),
      ],
    ),
    );

    List <String> directions = selectedRecipe.recipe_directions.split("\n");
    int j = directions.length;
    for (int i = directions.length-1; i >= 0; i--) {
      if(i > 5){
       directions.insert(i, "\n\nStep "+(i-5).toString()+": ");
      }
      else {
        if(i % 2 == 0) {
          directions.insert(i, "\n");
        }
        else{
          directions.insert(i, ": ");
        }
      }
    }
    // directions.insert(12, "\n");
      final recipeInstructions = EasyRichText(directions.join(""),
      patternList: [
        EasyRichTextPattern(targetString: "Step [0-9]:",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF37280)),),
        EasyRichTextPattern(targetString: "Prep:",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF37280)),),
        EasyRichTextPattern(targetString: "Cook:",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF37280)),),
        EasyRichTextPattern(targetString: "Ready In:",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF37280)),)
      ]);

      final recipeContent = Container(
        // height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // color: Theme.of(context).primaryColor,
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: <Widget>[recipeIngredients,
              SizedBox(height: 10.0),
              recipeInstructions],
          ),
        ),
      );

    final suggestionsContent =
      Container(
        child: new ListView.builder(
          shrinkWrap: true,
      itemBuilder: (context, index) {
              return ListTile(
                        title: Text(suggestionDataList[index].name),
                        subtitle: Text(suggestionDataList[index].cooccurrencetoplist.join(", ")),
                      );
      },
      itemCount: suggestionDataList.length,
    ),
    );


      return Scaffold(
        appBar: AppBar(
            title: Text('Recipe Detail'),
            backgroundColor: Color(0xFFF37280)
        ),
        resizeToAvoidBottomPadding: false,

        body: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[recipeContent, graphContent, suggestionsContent, SizedBox(height:10.0), saveButton, SizedBox(height:25.0)],
              ),
            ),
          ),
        ),
      );
    }
  }




// class HorizontalBarChart extends StatelessWidget {
//   final List<charts.Series> seriesList;
//   final bool animate;
//
//   HorizontalBarChart(this.seriesList, {this.animate});
//
//   /// Creates a [BarChart] with sample data and no transition.
//   factory HorizontalBarChart.withSampleData() {
//     return new HorizontalBarChart(
//       _chartData(),
//       // Disable animations for image tests.
//       animate: false,
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     // For horizontal bar charts, set the [vertical] flag to false.
//     return new charts.BarChart(
//       seriesList,
//       animate: animate,
//       vertical: false,
//     );
//   }
//
//   /// Create one series with sample hard coded data.
//   static List<charts.Series<NutrientData, String>> _chartData() {
//     return [
//       new charts.Series<NutrientData, String>(
//         id: 'Nutrition',
//         domainFn: (NutrientData row, _) => row.nutrient,
//         measureFn: (NutrientData row, _) => row.percentDailyValue,
//         data: loadNutritionData(selectedRecipe),
//       )
//     ];
//   }
// }

