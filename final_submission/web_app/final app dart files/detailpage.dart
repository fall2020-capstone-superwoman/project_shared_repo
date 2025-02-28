// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './jsonstructure.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import './recipeinputsearch.dart';

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
        if (selectedRecipe.recipe_nutritionfacts[i].benchmark_flag == 1) {
          suggestionDataList.add(SuggestionData(
              selectedRecipe.recipe_nutritionfacts[i].name,
              selectedRecipe.recipe_nutritionfacts[i].benchmark_percentage,
              selectedRecipe.recipe_nutritionfacts[i].cooccurrence_top_list,
              selectedRecipe.recipe_nutritionfacts[i].raw_nutrition_top_list));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _scrollController = ScrollController();
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
                  primaryXAxis: CategoryAxis(isInversed: true),
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
      textAlign: TextAlign.center,
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

    final suggestionsText =
    Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Color(0xFFF37280),
            border: Border.all(width:2, color: Colors.white)),
        child: Center(
            child: RichText(
      text: TextSpan(
        text: "Did You Enjoy the Recipe?\n",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20,),
        children: <TextSpan>[
          TextSpan(
            text: "Do you want tips to make this recipe even better?",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),),
          // TextSpan(
          //     text: selectedRecipe.recipe_ingredients.join(", "),
          //     style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 15)
          // ),
        ],
      ),
    )));


    final suggestionsContent =
      Container(
        height: 600,
        child: new ListView.builder(
          // scrollDirection: Axis.vertical,
          // physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
      itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    // color: Color(0xFFF37280),
                    border: Border.all(width:2, color: Colors.white)),
                child: Center(child:  ListTile(
                  // leading: Icon(Icons.warning, color: Colors.white, size: 50.0),
                  title: Text("This recipe is low in "+suggestionDataList[index].name, style: TextStyle(color: Color(0xFFF37280), fontSize: 15.0,  fontWeight: FontWeight.bold)),
                  subtitle: Text("Consider adding or using "+suggestionDataList[index].cooccurrencetoplist.join(", ")+". \nIn general, try eating more "+suggestionDataList[index].rawnutritiontoplist.join(", ")+".", style: TextStyle(color: Colors.black,fontSize: 12.0)
                  ))));
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
            // child: Scrollbar(
              // controller:_scrollController,
            // child: SingleChildScrollView(
              child: DraggableScrollbar.arrows(
              controller: _scrollController,
              alwaysVisibleScrollThumb: true,
              backgroundColor: Colors.pink,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                      children: <Widget>[recipeContent, graphContent,
                  SizedBox(height: 20), suggestionsText, suggestionsContent],
                  );
                },),
            ),
            // ),
          ),

      ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.pop(context);
              },
              label: Text('Back to List', style: TextStyle(
                  fontSize: 15
              )),
              icon: Icon(Icons.article_outlined),
              backgroundColor: Colors.black26,
              hoverColor: Colors.pink,
            ),
            SizedBox(height:5),
            FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
              return RecipeInputPage();
            }));
            //     context, MaterialPageRoute(builder: (context) => ListViewPage()));
          },
          label: Text('New Search', style: TextStyle(
              fontSize: 15
          )),
          icon: Icon(Icons.arrow_back),
          backgroundColor: Colors.black26,
              hoverColor: Colors.pink,
        ),
      ]
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

