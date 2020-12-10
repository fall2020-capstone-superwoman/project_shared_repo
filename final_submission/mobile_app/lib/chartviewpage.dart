import './jsonstructure.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import './json_read.dart';
import 'dart:core';
import './recipeslist.dart';

class ChartViewPage extends StatefulWidget {
  ChartViewPage({Key key, this.data, this.nutritionDataChart}) : super(key: key);
  final List<Recipe> data;
  final List<List<NutrientData>> nutritionDataChart;


  @override
  _ChartViewPageState createState() => new _ChartViewPageState();
}

var f = NumberFormat("#%");


class _ChartViewPageState extends State<ChartViewPage> {

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
              title: ChartTitle(text: widget.data.first.recipe_name + " vs. " + widget.data.last.recipe_name),
              tooltipBehavior: TooltipBehavior(enable: true),
              zoomPanBehavior: ZoomPanBehavior(
                  enablePanning: true
              ),
              series: <CartesianSeries>[
                BarSeries<NutrientData, String>(
                    dataSource: widget.nutritionDataChart[1],
                    //widget.data.first
                    xValueMapper: (NutrientData row, _) => row.nutrient,
                    yValueMapper: (NutrientData row, _) => row.datapoint,
                    name: widget.data.last.recipe_name,
                    dataLabelSettings: DataLabelSettings(
                    // Renders the data label
                    isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.top,
                    )
                ),
                // BarSeries<NutrientData, String>(
                //     dataSource: widget.nutritionDataChart[0],
                //     xValueMapper: (NutrientData row, _) => row.nutrient,
                //     yValueMapper: (NutrientData row, _) => row.percentDailyValue,
                //     name: widget.data.first.recipe_name,
                //     dataLabelSettings: DataLabelSettings(
                //       // Renders the data label
                //       isVisible: true,
                //       labelAlignment: ChartDataLabelAlignment.top,
                //     )
                // )
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

