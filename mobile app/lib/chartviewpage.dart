import './chart_input.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Charts"),
    ),
    body: MyHomePage(),
  );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

var f = NumberFormat("#%");

class _MyHomePageState extends State<MyHomePage> {

  List<Recipe> chartData = []; // list for storing the last parsed Json data
  List<List<NutrientData>> nutritionData = [];
  List<NutrientData> nutritionPerRecipe = [];

  Future<String> _loadRecipeAsset() async {
    return await rootBundle.loadString('assets/recipes.json');
  }

  Future loadRecipes() async {
    String jsonString = await _loadRecipeAsset();
    final jsonResponse = json.decode(jsonString);
    setState(() {
      for(Map i in jsonResponse) {
        chartData.add(Recipe.fromJson(i)); // Deserialization step 3
      }
    });
      for (int i = 0; i < chartData.length; i++) {
        nutritionPerRecipe = [];
        for (int j = chartData[i].nutrition_info.length-1; j >= 0; j--) {
          nutritionPerRecipe.add(NutrientData(chartData[i].nutrition_info[j].nutrient, chartData[i].nutrition_info[j].pct_daily));
        }
          nutritionData.add(nutritionPerRecipe);
        }
        return nutritionData;
      }




  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
              ),
              primaryYAxis: NumericAxis(numberFormat: NumberFormat.percentPattern()),
              title: ChartTitle(text: chartData[0].recipe_title),
              tooltipBehavior: TooltipBehavior(enable: true),
              zoomPanBehavior: ZoomPanBehavior(
                  enablePanning: true
              ),
              series: <CartesianSeries>[
                BarSeries<NutrientData, String>(
                    dataSource: nutritionData[0],
                    xValueMapper: (NutrientData row, _) => row.nutrient,
                    yValueMapper: (NutrientData row, _) => row.pct_daily,
                    dataLabelSettings: DataLabelSettings(
                    // Renders the data label
                    isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.top,
                    )
                )
              ]
          ),
        ),
      ),
    );
  }
}

class NutrientData{
  NutrientData(this.nutrient, this.pct_daily);
  final String nutrient;
  final double pct_daily;
}
