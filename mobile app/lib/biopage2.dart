import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:smart_select/smart_select.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
  String selectedNutrient;

  @override
  void initState() {
    super.initState();
    SharedPreferences.setMockInitialValues ({});
    _load();

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
    setState((){
      selectedVegValue = prefs.getString('veg') ?? '';
      if (prefs.getStringList('noIngredients')!=null){
        selectedItems = prefs.getStringList('noIngredients').map((i)=>int.parse(i)).toList();
      } else {
        selectedItems = [];
      }
      selectedNutrient = prefs.getString('priorities') ?? 'Overall';
      selectedStatus = prefs.getString('status') ?? '';
    });
  }

  void _save() async {
    prefs = await SharedPreferences.getInstance();
    print(selectedStatus);
    print(selectedNutrient);
    setState(() {
      prefs.setString('status', selectedStatus);
      prefs.setString('priorities', selectedNutrient);
      prefs.setString('veg', selectedVegValue);
      List<String> stringsList=  selectedItems.map((i)=>i.toString()).toList();
      prefs.setStringList('noIngredients', stringsList);
    });
  }
  List<S2Choice<String>> statusOptions = [
    S2Choice<String>(value: 'Pregnant - First Trimester', title: 'Pregnant - First Trimester'),
    S2Choice<String>(value: 'Pregnant - Second Trimester', title: 'Pregnant - Second Trimester'),
    S2Choice<String>(value: 'Pregnant - Third Trimester', title: 'Pregnant - Third Trimester'),
    S2Choice<String>(value: 'Lactating', title: 'Lactating'),
  ];
  List<S2Choice<String>> vegOptions = [
    S2Choice<String>(value: 'veg', title: 'Veg'),
    S2Choice<String>(value: 'nonveg', title: 'Nonveg'),
    S2Choice<String>(value: 'none', title: 'No preference'),
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
              FormBuilder(
                // key: _fbKey,
                // initialValue: {
                //   'date': DateTime.now(),
                //   'accept_terms': false,
                // },
                child: Column(
                  children: <Widget>[
                    SmartSelect<String>.single(
                        title: 'Status',
                        value: selectedStatus,
                        choiceItems: statusOptions,
                        onChange: (state) => setState(() => selectedStatus = state.value)
                    ),
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
                    margin: EdgeInsets.all(10),
                    child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [
                      Text("Ingredients You Want to Exclude:", style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 15
                      )),
                      SearchableDropdown.multiple(
                      items: items,
                      selectedItems: selectedItems,
                      hint: Text("Select items"),
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
                    children: <Widget>[
                      SmartSelect<String>.single(
                        title: 'Preferences',
                        value: selectedVegValue,
                        choiceItems: vegOptions,
                        onChange: (state) => setState(() => selectedVegValue = state.value)
                    ),
                      SmartSelect<String>.single(
                      title: 'Priorities',
                      value: selectedNutrient,
                      choiceItems: priorityOptions,
                      onChange: (state) => setState(() => selectedNutrient = state.value)
                  ),

              Row(
                children: <Widget>[
                  MaterialButton(
                    child: Text("Submit"),
                    onPressed: () {
                      _save();
                    },
                  ),
                  MaterialButton(
                    child: Text("Reset"),
                    onPressed: () {
                      _load();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    ),
    ),
    ],
    ),
    ),
    ),
    );
  }
}