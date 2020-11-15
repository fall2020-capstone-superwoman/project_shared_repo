import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import './recipeslist.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;



class RecipeInputPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<RecipeInputPage> {
  bool asTabs = false;
  // String selectedValue;
  List<int> selectedItems = [];
  String selectedNutrient;

  Future<http.Response> createList(List<String> ingredients, String selectedNutrient) {
    return http.post(
      'https://jsonplaceholder.typicode.com/albums',
      headers: <String, String>{
        "content-Type": "application/json",
        "accept" : "application/json",
      },
      body: jsonEncode(<String, dynamic>{
        'ingredients': ingredients,
        'preference': selectedNutrient,
      }),
    );
  }

  // final List<DropdownMenuItem> status = [DropdownMenuItem(
  //   child: Text("Pregnant - 1st Trimester"),
  //   value: "Pregnant - 1st Trimester",
  // ), DropdownMenuItem(
  //   child: Text("Pregnant - 2nd Trimester"),
  //   value: "Pregnant - 2nd Trimester",
  // ), DropdownMenuItem(
  //   child: Text("Pregnant - 3rd Trimester"),
  //   value: "Pregnant - 3rd Trimester",
  // ), DropdownMenuItem(
  //   child: Text("Lactating"),
  //   value: "Lactating",
  // )];
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ListViewPage()));
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