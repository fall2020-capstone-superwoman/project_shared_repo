import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';
import './chart_input.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;

class AssessmentRecord {


  String assessmentTitle;
  List<String> names;
  List<int> marks;
}


class Assessment{

  final String name;
  final int marks;

  Assessment(this.name, this.marks);


}
List<charts.Series<Assessment, String>> _createSampleData() {
  List<Recipe> chartData = []; // list for storing the last parsed Json data

  Future<String> _loadRecipeAsset() async {
    return await rootBundle.loadString('assets/recipes.json');
  }

  Future loadRecipes() async {
    String jsonString = await _loadRecipeAsset();
    final jsonResponse = json.decode(jsonString);
    for(Map i in jsonResponse) {
      chartData.add(Recipe.fromJson(i)); // Deserialization step
    }
  }

  final List<dynamic> assessmentData = [];
  for(var i=0; i < chartData.length; i++){
    for(var j=0; i < chartData[i].nutrition_info.length; j++){
      assessmentData.add(new Assessment(chartData[i].recipe_title, (chartData[i].nutrition_info[j].pct_daily*100).toInt()));
    }
  }

  return[

    new charts.Series(
      id: 'Assessment Marks',
      data: assessmentData,
      domainFn: (Assessment assessment, _) => assessment.name,
      measureFn: (Assessment assessment, _) => assessment.marks,
      colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
    )
  ];


}

class ChartListView extends StatefulWidget {
  @override
  _ChartListViewState createState() => _ChartListViewState();
  final List<ListItem> items;
  ChartListView({Key key, @required this.items}) : super(key: key);
}

class _ChartListViewState extends State<ChartListView> {
  // final databaseReference = FirebaseDatabase.instance.reference();




  var f = NumberFormat("#%");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: new ThemeData(
        primaryColor: Color.fromRGBO(24, 24, 24, 1.0),
        canvasColor: Color.fromRGBO(46, 49, 49, 1.0),
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: new AppBar(
          title: Text('Charts in List View'),
        ),
        body: _buildList(context),
      ),
    );
  }


  Widget _buildList(BuildContext context) {
    return ListView.separated(
      itemCount: widget.items.length,
      separatorBuilder: (BuildContext context, int index) => Divider(
        thickness: 2.0,
      ),
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return ListTile(
          title: item.buildTitle(context),
          subtitle: item.buildChartTitle(context),
        );
      },
    );
  }
}



abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildChartTitle(BuildContext context);
}


class HeadingItem implements ListItem{

  final String heading;
  static final _random = new Random();

  List<charts.Series<AssessmentRecord, String >> _seriesList;
  HeadingItem(this.heading);



  @override
  Widget buildChartTitle(BuildContext context) {
    // TODO: implement buildChartTitle
    return Container(
      height: 300.0,
      padding: EdgeInsets.all(8.0),
      child:Card(
        child: Column(
          children: <Widget>[
            Expanded(
              child: _displayChart(_createSampleData(), true),
            )
          ],
        ),
      ),
    );

  }

  static int _next(int min, int max) => min + _random.nextInt(max - min);



  @override
  Widget buildTitle(BuildContext context) {
    // TODO: implement buildTitle
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        heading,
        style: Theme.of(context).textTheme.headline,
      ),
    );
  }



  charts.BarChart _displayChart(List<charts.Series> seriesList, bool animate){

    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,



      primaryMeasureAxis:
      new charts.NumericAxisSpec(
        showAxisLine: true,
        renderSpec: charts.GridlineRendererSpec(
            labelStyle: new charts.TextStyleSpec(
              fontSize: 10,
              color: charts.MaterialPalette.white,

            ),
            lineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.gray.shadeDefault,
            )),

      ),

      /// This is an OrdinalAxisSpec to match up with BarChart's default
      /// ordinal domain axis (use NumericAxisSpec or DateTimeAxisSpec for
      /// other charts).
      domainAxis: new charts.OrdinalAxisSpec(

        renderSpec: charts.GridlineRendererSpec(
            labelStyle: new charts.TextStyleSpec(
              fontSize: 10,
              color: charts.MaterialPalette.white,
            ),
            lineStyle: charts.LineStyleSpec(
              color: charts.MaterialPalette.gray.shadeDefault,
            )),
      ),


    );
  }

}
