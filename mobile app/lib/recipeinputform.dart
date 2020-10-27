import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class RecipeInputPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipe Input"),
      ),
      body: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var data;
  // bool autoValidate = true;
  // bool readOnly = false;
  // bool showSegmentedControl = true;
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FormBuilder(
                key: _fbKey,
                // initialValue: {
                //   'date': DateTime.now(),
                //   'accept_terms': false,
                //   'quantity': null,
                // },
                autovalidate: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FormBuilderTextField(
                      attribute: 'text',
                      validators: [FormBuilderValidators.required()],
                      decoration: InputDecoration(labelText: "Recipe Title"),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,  // see 3
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          flex:5,
                          child: FormBuilderDropdown(
                            attribute: "protein",
                            decoration: InputDecoration(labelText: "Protein", contentPadding: EdgeInsets.all(0.0)),
                            // initialValue: 'Male',
                            hint: Text('Select Protein'),
                            // validators: [FormBuilderValidators.required()],
                            items: ['Chicken', 'Beef', 'Pork']
                                .map((protein) => DropdownMenuItem(
                                value: protein, child: Text("$protein")))
                                .toList(),
                          ),
                        ),
                        SizedBox(width:10),
                        Flexible(
                          flex: 3,
                          child: FormBuilderTextField(
                            attribute: "quantity",
                            decoration: InputDecoration(labelText: "Quantity", hintText: "Quantity", contentPadding: EdgeInsets.all(0.0)),
                            keyboardType: TextInputType.number,
                            validators: [
                              FormBuilderValidators.numeric(),
                            ],
                          ),
                          ),
                        SizedBox(width:10),
                        Flexible(
                          flex: 2,
                          child:  FormBuilderDropdown(
                            attribute: "unit",
                            decoration: InputDecoration(labelText: "Unit",contentPadding: EdgeInsets.all(0.0)),
                            // initialValue: 'Male',
                            hint: Text('Unit'),
                            // validators: [FormBuilderValidators.required()],
                            items: ['g', 'kg', 'lb']
                                .map((unit) => DropdownMenuItem(
                                value: unit, child: Text("$unit")))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,  // see 3
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          flex:5,
                          child: FormBuilderDropdown(
                            attribute: "vegetables",
                            decoration: InputDecoration(labelText: "Vegetables", contentPadding: EdgeInsets.all(0.0)),
                            // initialValue: 'Male',
                            hint: Text('Select Vegetables'),
                            // validators: [FormBuilderValidators.required()],
                            items: ['broccoli', 'spinach', 'carrot']
                                .map((protein) => DropdownMenuItem(
                                value: protein, child: Text("$protein")))
                                .toList(),
                          ),
                        ),
                        SizedBox(width:10),
                        Flexible(
                          flex: 3,
                          child: FormBuilderTextField(
                            attribute: "quantity",
                            decoration: InputDecoration(labelText: "Quantity", contentPadding: EdgeInsets.all(0.0)),
                            keyboardType: TextInputType.number,
                            validators: [
                              FormBuilderValidators.numeric(),
                            ],
                          ),
                        ),
                        SizedBox(width:10),
                        Flexible(
                          flex: 2,
                          child:  FormBuilderDropdown(
                            attribute: "unit",
                            decoration: InputDecoration(labelText: "Unit",contentPadding: EdgeInsets.all(0.0)),
                            // initialValue: 'Male',
                            hint: Text('Unit'),
                            // validators: [FormBuilderValidators.required()],
                            items: ['g', 'kg', 'lb']
                                .map((unit) => DropdownMenuItem(
                                value: unit, child: Text("$unit")))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,  // see 3
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          flex:5,
                          child: FormBuilderDropdown(
                            attribute: "grains",
                            decoration: InputDecoration(labelText: "Grains", contentPadding: EdgeInsets.all(0.0)),
                            // initialValue: 'Male',
                            hint: Text('Select Grains'),
                            // validators: [FormBuilderValidators.required()],
                            items: ['brown rice', 'white rice', 'barley']
                                .map((protein) => DropdownMenuItem(
                                value: protein, child: Text("$protein")))
                                .toList(),
                          ),
                        ),
                        SizedBox(width:10),
                        Flexible(
                          flex: 3,
                          child: FormBuilderTextField(
                            attribute: "quantity",
                            decoration: InputDecoration(labelText: "Quantity", contentPadding: EdgeInsets.all(0.0)),
                            keyboardType: TextInputType.number,
                            validators: [
                              FormBuilderValidators.numeric(),
                            ],
                          ),
                        ),
                        SizedBox(width:10),
                        Flexible(
                          flex: 2,
                          child:  FormBuilderDropdown(
                            attribute: "unit",
                            decoration: InputDecoration(labelText: "Unit",contentPadding: EdgeInsets.all(0.0)),
                            // initialValue: 'Male',
                            hint: Text('Unit'),
                            // validators: [FormBuilderValidators.required()],

                            items: ['g', 'kg', 'lb']
                                .map((unit) => DropdownMenuItem(
                                value: unit, child: Text("$unit")))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,  // see 3
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          flex:5,
                          child: FormBuilderDropdown(
                            attribute: "fruit",
                            decoration: InputDecoration(labelText: "Fruit", contentPadding: EdgeInsets.all(0.0)),
                            // initialValue: 'Male',
                            hint: Text('Select Fruit'),
                            // validators: [FormBuilderValidators.required()],
                            items: ['Apple', 'Banana', 'Blueberries']
                                .map((protein) => DropdownMenuItem(
                                value: protein, child: Text("$protein")))
                                .toList(),
                          ),
                        ),
                        SizedBox(width:10),
                        Flexible(
                          flex: 3,
                          child: FormBuilderTextField(
                            attribute: "quantity",
                            decoration: InputDecoration(labelText: "Quantity", contentPadding: EdgeInsets.all(0.0)),
                            keyboardType: TextInputType.number,
                            validators: [
                              FormBuilderValidators.numeric(),
                            ],
                          ),
                        ),
                        SizedBox(width:10),
                        Flexible(
                          flex: 2,
                          child:  FormBuilderDropdown(
                            attribute: "unit",
                            decoration: InputDecoration(labelText: "Unit",contentPadding: EdgeInsets.all(0.0)),
                            // initialValue: 'Male',
                            hint: Text('Unit'),
                            // validators: [FormBuilderValidators.required()],
                            items: ['g', 'kg', 'lb']
                                .map((unit) => DropdownMenuItem(
                                value: unit, child: Text("$unit")))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        MaterialButton(
                          child: Text("Submit"),
                          onPressed: () {
                            _fbKey.currentState.save();
                            if (_fbKey.currentState.validate()) {
                              print(_fbKey.currentState.value);
                            }
                          },
                        ),
                        MaterialButton(
                          child: Text("Reset"),
                          onPressed: () {
                            _fbKey.currentState.reset();
                          },
                        ),
                      ],
                    )
                  ],
          ),
        ),
      ],
    ),
    ),),
    );
  }
}