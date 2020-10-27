import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

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
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var data;
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
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
                initialValue: {
                  'date': DateTime.now(),
                  'accept_terms': false,
                },
                autovalidate: true,
                child: Column(
                  children: <Widget>[
                    FormBuilderDropdown(
                      attribute: "status",
                      decoration: InputDecoration(labelText: "Status"),
                      // initialValue: 'Male',
                      hint: Text('Select Status'),
                      validators: [FormBuilderValidators.required()],
                      items: ['Pregnant', 'Lactating']
                          .map((gender) => DropdownMenuItem(
                          value: gender, child: Text("$gender")))
                          .toList(),
                    ),FormBuilderDateTimePicker(
                      attribute: "date",
                      inputType: InputType.date,
                      validators: [FormBuilderValidators.required()],
                      format: DateFormat("dd-MM-yyyy"),
                      decoration: InputDecoration(labelText: "Estimated Due Date"),
                    ),

                    FormBuilderTextField(
                      attribute: "age",
                      decoration: InputDecoration(labelText: "Age"),
                      keyboardType: TextInputType.number,
                      validators: [
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(70),
                      ],
                    ),

                    FormBuilderCheckboxGroup(
                      decoration:
                      InputDecoration(labelText: "What Nutrients Do You Want to Focus on?"),
                      attribute: "nutrients",
                      initialValue: ["Protein"],
                      options: [
                        FormBuilderFieldOption(value: "Protein"),
                        FormBuilderFieldOption(value: "Calcium"),
                        FormBuilderFieldOption(value: "Vitamin C"),
                        FormBuilderFieldOption(value: "Iron")
                      ],
                    ),
                  ],
                ),
              ),
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
      ),
    );
  }
}