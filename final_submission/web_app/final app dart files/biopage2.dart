import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:smart_select/smart_select.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import './recipeinputsearch.dart';

class BioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.face),
        titleSpacing: -7.0,
        title: Text("My Details"),
      ),
      body: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences prefs;
  var data;
  bool autoValidate = true;
  // Cache c = new SimpleCache(storage: new SimpleStorage(size: 20));


  String selectedStatus;
  List<int> selectedItems = [];
  List<String> stringsList = [];
  List<String> allergies = [];
  String selectedList;
  String selectedNutrient;
  String dropdownString;
  List<String> ingredients = [];
  bool milk = false;
  bool eggs = false;
  bool fish = false;
  bool shellfish = false;
  bool treenuts = false;
  bool peanuts = false;
  bool wheat = false;
  bool soybean = false;
  bool nonspicy = false;


  @override
  void initState() {
    super.initState();
    selectedStatus = "";
    stringsList= [];
    milk = false;
    eggs = false;
    fish = false;
    shellfish = false;
    treenuts = false;
    peanuts = false;
    wheat = false;
    soybean = false;
    nonspicy = false;
    _load();

  }

  Future<String> _loadIngredients() async {
    return await rootBundle.loadString('assets/ingredients.txt');
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/mydetails.txt');
  }

  _load() async{
    prefs = await SharedPreferences.getInstance();
    dropdownString = await _loadIngredients();
    setState(() {
      stringsList = prefs.getStringList('noIngredients');
      milk = prefs.getBool('milk');
      eggs = prefs.getBool('eggs');
      fish = prefs.getBool('fish');
      shellfish = prefs.getBool('shellfish');
      treenuts = prefs.getBool('treenuts');
      peanuts = prefs.getBool('peanuts');
      wheat = prefs.getBool('wheat');
      soybean = prefs.getBool('soybean');
      nonspicy = prefs.getBool('nonspicy');
      if (stringsList != null) {
        selectedList = stringsList.join(",");
      } else {
        selectedItems = [];
      }
      selectedStatus = prefs.getString('status');
      ingredients = dropdownString.split('\n');
      for (String i in ingredients) {
        items.add(DropdownMenuItem(
          child: Text(i),
          value: i,
        ));
      }
    });
  }
  void _remove() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  void _save() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('status', selectedStatus);
      prefs.setBool('milk', milk);
      prefs.setBool('eggs', eggs);
      prefs.setBool('fish', fish);
      prefs.setBool('shellfish', shellfish);
      prefs.setBool('treenuts', treenuts);
      prefs.setBool('peanuts', peanuts);
      prefs.setBool('wheat', wheat);
      prefs.setBool('soybean', soybean);
      prefs.setBool('nonspicy', nonspicy);
      stringsList=  selectedItems.map((i)=>items[i].value.toString()).toList();
      prefs.setStringList('noIngredients', stringsList);
      selectedList = stringsList.join(",");
      // print(prefs.get('status'));
    });
  }
  List<S2Choice<String>> statusOptions = [
    S2Choice<String>(value: 'Pregnant - First Trimester', title: 'Pregnant - First Trimester'),
    S2Choice<String>(value: 'Pregnant - Second Trimester', title: 'Pregnant - Second Trimester'),
    S2Choice<String>(value: 'Pregnant - Third Trimester', title: 'Pregnant - Third Trimester'),
    S2Choice<String>(value: 'Lactating', title: 'Lactating'),
  ];
  List<S2Choice<String>> vegOptions = [
    S2Choice<String>(value: 'Veg', title: 'Veg'),
    S2Choice<String>(value: 'Nonveg', title: 'Nonveg'),
    S2Choice<String>(value: 'No Preference', title: 'No Preference'),
  ];
  List<S2Choice<String>> priorityOptions = [
    S2Choice<String>(value: 'Overall', title: 'Overall'),
    S2Choice<String>(value: 'Protein', title: 'Protein'),
    S2Choice<String>(value: 'Folate', title: 'Folate'),
  ];
  // final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final List<DropdownMenuItem> items = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // key: _fbKey,
              // initialValue: {
              //   'date': DateTime.now(),
              //   'accept_terms': false,
              // },
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height:10),
                  Text("Select Status:", textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      )),
                  SmartSelect<String>.single(
                      title: 'Select Status',
                      value: selectedStatus,
                      choiceItems: statusOptions,
                      onChange: (state) => setState(() => selectedStatus = state.value)
                  ),
                  SizedBox(height: 10),
                  Text("Allergies:", style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  )),
                  Container(
                    // padding: EdgeInsets.all(5),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      margin: EdgeInsets.all(5),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget> [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: milk?? false,
                                      onChanged: (bool value) {
                                        setState(() {
                                          milk = value;
                                        });
                                      },
                                    ),
                                    Text("Milk\t\t\t\t\t"),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: eggs?? false,
                                      onChanged: (bool value) {
                                        setState(() {
                                          eggs = value;
                                        });
                                      },
                                    ),
                                    Text("Eggs\t\t\t"),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: fish?? false,
                                      onChanged: (bool value) {
                                        setState(() {
                                          fish = value;
                                        });
                                      },
                                    ),
                                    Text("Fish\t\t\t\t\t"),
                                  ],
                                ),
                                Row(
                                  children:<Widget>[
                                    Checkbox(
                                      value: shellfish?? false,
                                      onChanged: (bool value) {
                                        setState(() {
                                          shellfish = value;
                                        });
                                      },
                                    ),
                                    Text("Shellfish"),
                                  ],),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: treenuts?? false,
                                      onChanged: (bool value) {
                                        setState(() {
                                          treenuts = value;
                                        });
                                      },
                                    ),
                                    Text("Treenuts"),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: peanuts?? false,
                                      onChanged: (bool value) {
                                        setState(() {
                                          peanuts = value;
                                        });
                                      },
                                    ),
                                    Text("Peanuts"),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: wheat?? false,
                                      onChanged: (bool value) {
                                        setState(() {
                                          wheat = value;
                                        });
                                      },
                                    ),
                                    Text("Wheat\t"),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                      value: soybean?? false,
                                      onChanged: (bool value) {
                                        setState(() {
                                          soybean = value;
                                        });
                                      },
                                    ),
                                    Text("Soybean\t\t"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Other Foods to Exclude:", style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  )),
                  Container(
                    // padding: EdgeInsets.all(5),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      margin: EdgeInsets.all(5),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget> [
                            SearchableDropdown.multiple(
                              items: items,
                              selectedItems: selectedItems,
                              hint: selectedList??'Select Items',
                              searchHint: "Select items",
                              onChanged: (value) {
                                setState(() {
                                  selectedItems = value;
                                });
                              },
                              closeButton: (selectedItems) {
                                return (((selectedItems.length>0)&(selectedItems.length<6))
                                    ? "Save ${selectedItems.length == 1 ? items[selectedItems.first].value.toString() : '(' + selectedItems.length.toString() + ')'}"
                                    : "Save without selection");
                              },
                              isExpanded: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20),
                        Text("Other:", textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Checkbox(
                              value: nonspicy?? false,
                              onChanged: (bool value) {
                                setState(() {
                                  nonspicy = value;
                                });
                              },
                            ),
                            Text("Prefer non-spicy items"),
                          ],
                        ),

                        SizedBox(height: 20),
                    // MaterialButton(
                    //   textColor: Colors.black45,
                    //   padding: EdgeInsets.all(8.0),
                    //   // splashColor: Colors.blueAccent,
                    //   onPressed: () {_remove();},
                    //   child: Text(
                    //     "Clear Preferences",
                    //     style: TextStyle(fontSize: 15.0),
                    //   ),
                    // ),
                      ],
                    ),
                  ),

                ],
              ),

            ],
          ),
        ),
      ),
      floatingActionButton:
      FloatingActionButton.extended(
        onPressed: () {
          _save();
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (BuildContext context) {
          //   return RecipeInputPage();
          // }));
        },
        label: Text('Save Details', style: TextStyle(
            fontSize: 20
        )),
        icon: Icon(Icons.save),
        backgroundColor: Colors.black26,
        hoverColor: Colors.pink,
      ),
    );
  }
}

