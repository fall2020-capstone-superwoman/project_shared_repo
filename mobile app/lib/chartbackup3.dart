import './jsonstructure.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import './json_read.dart';
import 'dart:core';
import './recipeslist.dart';

class ChartViewPage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Charts"),
    //   ),
    //   body:
    return MyHomePage();
  }
}

class MyHomePage extends StatefulWidget {
  Set<int> data = Set<int>();
  MyHomePage({Key key, Set<int> data}) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

var f = NumberFormat("#%");

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Charts"),
      ),
      body: Center(
        child: Container(
          child:
          SfCartesianChart(
              primaryXAxis: CategoryAxis(
              ),
              primaryYAxis: NumericAxis(numberFormat: NumberFormat.percentPattern()),
              title: ChartTitle(text: chartData[0].recipe_name + " vs. " + chartData[1].recipe_name),
              tooltipBehavior: TooltipBehavior(enable: true),
              zoomPanBehavior: ZoomPanBehavior(
                  enablePanning: true
              ),
              series: <CartesianSeries>[
                BarSeries<NutrientData, String>(
                    dataSource: nutritionData[0],
                    //widget.data.first
                    xValueMapper: (NutrientData row, _) => row.nutrient,
                    yValueMapper: (NutrientData row, _) => row.datapoint,
                    dataLabelSettings: DataLabelSettings(
                      // Renders the data label
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.top,
                    )
                ),
                BarSeries<NutrientData, String>(
                    dataSource: nutritionData[1],
                    xValueMapper: (NutrientData row, _) => row.nutrient,
                    yValueMapper: (NutrientData row, _) => row.datapoint,
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

// class NutrientData{
//   NutrientData(this.nutrient, this.pct_daily);
//   final String nutrient;
//   final double pct_daily;
// }

