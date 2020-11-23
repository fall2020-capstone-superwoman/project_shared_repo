import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:smart_select/smart_select.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class BioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

  String selectedStatus;
  String selectedVegValue;
  List<int> selectedItems = [];
  List<String> stringsList = [];
  String selectedList;
  String selectedNutrient;
  String dropdownString;
  List<String> ingredients = [];

  @override
  void initState() {
    super.initState();
    selectedStatus = "";
    selectedVegValue = "";
    stringsList= [];
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

  Future<void> _load() async{
    prefs = await SharedPreferences.getInstance();
    dropdownString = await _loadIngredients();
    setState(() {
      selectedVegValue = prefs.getString('veg');
      stringsList = prefs.getStringList('noIngredients');
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
      prefs.setString('veg', selectedVegValue);
      stringsList=  selectedItems.map((i)=>items[i].value.toString()).toList();
      prefs.setStringList('noIngredients', stringsList);
      selectedList = stringsList.join(",");
      // print(stringsList[0]);

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
                    SizedBox(height:20),
                    Text("Select Status:", textAlign: TextAlign.left,
                        style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    )),
                    SmartSelect<String>.single(
                        title: selectedStatus??'Select Status',
                        value: selectedStatus,
                        choiceItems: statusOptions,
                        onChange: (state) => setState(() => selectedStatus = state.value)
                    ),
                SizedBox(height: 20),
                    Text("Ingredients You Want to Exclude:", style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    )),
                Container(
                  // padding: EdgeInsets.all(5),
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
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [
                      // Text("Ingredients You Want to Exclude:", style: TextStyle(
                      //     color: Colors.grey[600],
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 15
                      // )),
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
                        return (((selectedItems.length>1)&(selectedItems.length<6))
                            ? "Save ${selectedItems.length == 1 ? '"' + items[selectedItems.first].value.toString() + '"' : '(' + selectedItems.length.toString() + ')'}"
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
                      Text("Select Dietary Preferences:", textAlign: TextAlign.left,
                          style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      )),

                      SmartSelect<String>.single(
                        title: selectedVegValue??'Veg/Nonveg Preferences',
                        value: selectedVegValue,
                        choiceItems: vegOptions,
                        onChange: (state) => setState(() => selectedVegValue = state.value)
                    ),
                  //     SmartSelect<String>.single(
                  //     title: 'Priorities',
                  //     value: selectedNutrient,
                  //     choiceItems: priorityOptions,
                  //     onChange: (state) => setState(() => selectedNutrient = state.value)
                  // ),
                      SizedBox(height: 20),

              // Row(
              //   children: <Widget>[
              //     //
              //     MaterialButton(
              //       child: Text("Submit"),
              //       onPressed: () {
              //         _save();
              //       },
              //     ),
              //     MaterialButton(
              //       child: Text("Reset"),
              //       onPressed: () {
              //         _remove();
              //       },
              //     ),
              //   ],
              // )
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
          // Navigator.pop(context);
          _save();
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => ListViewPage()));
        },
        label: Text('Save Details', style: TextStyle(
            fontSize: 20
        )),
        icon: Icon(Icons.save),
        backgroundColor: Colors.pink,
      ),
    );
  }
}