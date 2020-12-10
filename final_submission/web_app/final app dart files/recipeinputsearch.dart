import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import './recipeslist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './jsonstructure.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:smart_select/smart_select.dart';

class RecipeInputPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<RecipeInputPage> {
  bool asTabs = false;
  // String selectedValue;
  List<int> selectedItems = [];
  List<String> allergies = [];
  String selectedNutrient;
  SharedPreferences prefs;
  String selectedStatus;
  List<String> noIngredientsstringsList = [];
  String dropdownString;
  List<String> ingredients = [];
  bool _loading = false;
  bool milk = false;
  bool eggs = false;
  bool fish = false;
  bool shellfish = false;
  bool treenuts = false;
  bool peanuts = false;
  bool wheat = false;
  bool soybean = false;
  bool nonspicy = false;


  Future<http.Response> createList() {
    List<String> selectedItemList = selectedItems.map((i)=>items[i].value.toString()).toList();
    print(selectedItemList[0]);
    Preferences preferences =  Preferences(selectedStatus, milk, eggs, fish, shellfish, treenuts, peanuts, wheat, soybean, nonspicy, noIngredientsstringsList, selectedItemList, selectedNutrient);
    String jsonPreferences = jsonEncode(preferences);
    print(jsonPreferences);
    return http.post(
        // https://cors-anywhere.herokuapp.com/
      'https://bbg5tf4j2d.execute-api.us-east-1.amazonaws.com/Test/ingredientstorecipes',
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        // "content-Type": "application/json",
        // "accept" : "application/json",
      },
      body: jsonPreferences
    );
  }

  _print(){
    List<String> selectedItemList = selectedItems.map((i)=>items[i].value.toString()).toList();
    Preferences preferences = Preferences(selectedStatus, milk, eggs, fish, shellfish, treenuts, peanuts, wheat, soybean, nonspicy, noIngredientsstringsList, selectedItemList, selectedNutrient);
    String jsonPreferences = jsonEncode(preferences);
    print(jsonPreferences);
  }
  List<DropdownMenuItem> items = [];



  List<S2Choice<String>> nutrients = [
    S2Choice<String>(value: 'Overall', title: 'Overall'),
    S2Choice<String>(value: 'Protein', title: 'Protein'),
    S2Choice<String>(value: 'Iron', title: 'Iron'),
    S2Choice<String>(value: 'Calcium', title: 'Calcium'),
  ];

  Future<String> _loadIngredients() async {
    return await rootBundle.loadString('assets/ingredients.txt');
  }

  @override
  void initState() {
    super.initState();
    selectedStatus = "";
    milk = false;
    eggs = false;
    fish = false;
    shellfish = false;
    treenuts = false;
    peanuts = false;
    wheat = false;
    soybean = false;
    nonspicy = false;
    noIngredientsstringsList= [];
    selectedNutrient = "Overall";
    _load();
    SharedPreferences.getInstance().then((sharedPrefs) {
      setState(() => prefs = sharedPrefs);
    });
  }


  _reload_preferences() async{
    // prefs = await SharedPreferences.getInstance();
    // if (mounted) {
    setState(() {
      noIngredientsstringsList = prefs.getStringList('noIngredients');
      selectedStatus = prefs.getString('status');
      milk = prefs.getBool('milk');
      eggs = prefs.getBool('eggs');
      fish = prefs.getBool('fish');
      shellfish = prefs.getBool('shellfish');
      treenuts = prefs.getBool('treenuts');
      peanuts = prefs.getBool('peanuts');
      wheat = prefs.getBool('wheat');
      soybean = prefs.getBool('soybean');
      nonspicy = prefs.getBool('nonspicy');
    });
  }

  _load() async{
    dropdownString = await _loadIngredients();
        ingredients = dropdownString.split('\n');
        for (String i in ingredients) {
          items.add(DropdownMenuItem(
            child: Text(i),
            value: i,
          ));
        }
        _loading = true;
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
          if (selectedItemsForValidator.length != 3) {
            return ("Must select 3 items");
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

      "Nutrients Focus":
      SmartSelect<String>.single(
          title: "Select Nutrient",
          value: selectedNutrient,
          choiceItems: nutrients,
          onChange: (state) => setState(() => selectedNutrient = state.value)
      ),
    };

    return _loading != true
        ? new Scaffold(body: new Center(child: new CircularProgressIndicator()))
        : new MaterialApp(
      home: asTabs
          ? DefaultTabController(
        length: widgets.length,
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.add_box_rounded),
            titleSpacing: -7.0,
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
          leading: Icon(Icons.add_box_rounded),
          titleSpacing: -7.0,
          title: Text("Search Recipes"),
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
            // Navigator.pop(context);
            // selectedItems.map((i)=>i.toString()).toList();
            _reload_preferences();
            createList();
            // _print();
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ListViewPage()));
          },
          label: Text('Search Recipes', style: TextStyle(
            fontSize: 20
          )),
          icon: Icon(Icons.arrow_forward_ios),
          backgroundColor: Colors.black26,
          hoverColor: Colors.pink,
      ),
    ),
    );
  }
}