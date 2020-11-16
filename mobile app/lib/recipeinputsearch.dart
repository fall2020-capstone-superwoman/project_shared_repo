import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './recipeslist.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './jsonstructure.dart';
import 'package:http_middleware/http_middleware.dart';
import 'package:http_logger/http_logger.dart';
import 'dart:io';



class RecipeInputPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<RecipeInputPage> {
  bool asTabs = false;
  // String selectedValue;
  List<int> selectedItems = [];
  String selectedNutrient;
  SharedPreferences prefs;
  String selectedStatus;
  String selectedVegValue;
  List<String> noIngredientsstringsList = [];

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/test.txt');
  }

  Future<File> writeTest(int counter) async {
    final file = await _localFile;

    // Write the file.
    return file.writeAsString('$counter');
  }

  Future<int> readTest() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }
  Future<http.Response> createList() {
    List<String> selectedItemList = selectedItems.map((i)=>items[i].value.toString()).toList();
    Preferences preferences = Preferences(selectedStatus, noIngredientsstringsList, selectedVegValue, selectedItemList, selectedNutrient);
    String jsonPreferences = jsonEncode(preferences);

    return http.post(
      'https://bbg5tf4j2d.execute-api.us-east-1.amazonaws.com/Test/ingredientstorecipes',
      headers: <String, String>{
        "content-Type": "application/json",
        "accept" : "application/json",
      },
      body: jsonPreferences
    );
  }

  _print(){
    List<String> selectedItemList = selectedItems.map((i)=>items[i].value.toString()).toList();
    Preferences preferences = Preferences(selectedStatus, noIngredientsstringsList, selectedVegValue, selectedItemList, selectedNutrient);
    String jsonPreferences = jsonEncode(preferences);
    print(jsonPreferences);
  }

  final List<DropdownMenuItem> items = [DropdownMenuItem(
  child: Text("chicken"),
  value: "chicken",
  ), DropdownMenuItem(
  child: Text("beef"),
  value: "beef",
  ), DropdownMenuItem(
  child: Text("tomato"),
  value: "tomato",
  ), DropdownMenuItem(
  child: Text("potato"),
  value: "potato",
  )];
  final List<DropdownMenuItem> nutrients = [DropdownMenuItem(
  child: Text("protein"),
  value: "protein",
  ), DropdownMenuItem(
    child: Text("calcium"),
    value: "calcium",
  ), DropdownMenuItem(
    child: Text("vitamin C"),
    value: "vitamin C",
  ),DropdownMenuItem(
    child: Text("iron"),
    value: "iron",
  )];

  @override
  void initState() {
    super.initState();
    selectedStatus = "";
    selectedVegValue = "";
    noIngredientsstringsList= [];
    _load();
  }
  Future<void> _load() async{
    prefs = await SharedPreferences.getInstance();
    setState((){
      selectedVegValue = prefs.getString('veg');
      noIngredientsstringsList = prefs.getStringList('noIngredients');
      selectedStatus = prefs.getString('status');
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Widget> widgets;
    widgets = {
      "Select Ingredients": SearchableDropdown.multiple(
        items: items,
        selectedItems: selectedItems,
        hint: Text("Select items"),
        searchHint: "Select items",
        validator: (selectedItemsForValidator) {
          if ((selectedItemsForValidator.length > 5)|(selectedItemsForValidator.length<2)) {
            return ("Must select 2~5 items");
          }
          return (null);
        },
        onChanged: (value) {
          setState(() {
            selectedItems = value;
          });
        },
        closeButton: (selectedItems) {
          return (((selectedItems.length>1)&(selectedItems.length<6))
              ? "Save ${selectedItems.length == 1 ? '"' + items[selectedItems.first].value.toString() + '"' : '(' + selectedItems.length.toString() + ')'}"
              : "Save without selection");
        },
        isExpanded: true,
      ),
      "Nutrients Focus": SearchableDropdown.single(
        items: nutrients,
        value: selectedNutrient,
        hint: "Select one",
        searchHint: "Select one",
        validator: (selectedNutrient) {
          if (selectedNutrient== null) {
            return ("Must select one");
          }
          return (null);
        },
        onChanged: (value) {
          setState(() {
            selectedNutrient = value;
          });
        },
        isExpanded: true,
      ),
    };

    return MaterialApp(
      home: asTabs
          ? DefaultTabController(
        length: widgets.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Recipe Input"),
            backgroundColor: Color(0xFFF37280),
            // actions: appBarActions,
            bottom: TabBar(
              isScrollable: true,
              tabs: Iterable<int>.generate(widgets.length)
                  .toList()
                  .map((i) {
                return (Tab(
                  text: (i + 1).toString(),
                ));
              }).toList(), //widgets.keys.toList().map((k){return(Tab(text: k));}).toList(),
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(20),
            child: TabBarView(
              children: widgets
                  .map((k, v) {
                return (MapEntry(
                    k,
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(children: [
                        Text(k),
                        SizedBox(
                          height: 20,
                        ),
                        v,
                      ]),
                    )));
              })
                  .values
                  .toList(),
            ),
          ),
        ),
      )
          : Scaffold(
        appBar: AppBar(
          title: Text("Recipe Input"),
          backgroundColor: Color(0xFFF37280),
          // actions: appBarActions,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: widgets
                .map((k, v) {
              return (MapEntry(
                  k,
                  Center(
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          margin: EdgeInsets.all(20),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Text("$k:", style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                                )),
                                v,
                              ],
                            ),
                          )))));
            })
                .values
                .toList(),
          ),

        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pop(context);
            // selectedItems.map((i)=>i.toString()).toList(),
            _print();
            createList();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          label: Text('Search Recipes', style: TextStyle(
            fontSize: 20
          )),
          icon: Icon(Icons.arrow_forward_ios),
          backgroundColor: Colors.pink,
      ),
    ),
    );
  }
}