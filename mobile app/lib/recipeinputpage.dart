import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class RecipeInputPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RecipeInputPageState();
  }
}

class RecipeInputPageState extends State<RecipeInputPage> {
  String _recipe_title;
  String _protein;
  int _proteinquantity;
  String _proteinunit;
  String _vegetables;
  int _vegetablesquantity;
  String _vegetablesunit;
  String _grains;
  int _grainsquantity;
  String _grainsunit;
  String _fruit;
  int _fruitquantity;
  String _fruitunit;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitle() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Recipe Title'),
      maxLength: 40,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Title is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _recipe_title = value;
      },
    );
  }


  Widget _buildProtein() {
    return Row(
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
            onSaved: (String value) {
              _protein = value;
            },
          ),
        ),
        SizedBox(width:10),
        Flexible(
          flex: 3,
          child: TextFormField(
            decoration: InputDecoration(labelText: "Quantity", hintText: "Quantity", contentPadding: EdgeInsets.all(0.0)),
            keyboardType: TextInputType.number,
            validator: FormBuilderValidators.numeric(),
            onSaved: (String value) {
              _proteinquantity = int.parse(value);
            },
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
            onSaved: (String value) {
              _proteinunit = value;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVegetables() {
    return Row(
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
            items: ['Broccoli', 'Cabbage', 'Leek']
                .map((vegetables) => DropdownMenuItem(
                value: vegetables, child: Text("$vegetables")))
                .toList(),
            onSaved: (String value) {
              _vegetables = value;
            },
          ),
        ),
        SizedBox(width:10),
        Flexible(
          flex: 3,
          child: TextFormField(
            decoration: InputDecoration(labelText: "Quantity", hintText: "Quantity", contentPadding: EdgeInsets.all(0.0)),
            keyboardType: TextInputType.number,
            validator: FormBuilderValidators.numeric(),
            onSaved: (String value) {
              _vegetablesquantity = int.parse(value);
            },
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
            onSaved: (String value) {
              _vegetablesunit = value;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGrains() {
    return Row(
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
            items: ['White Rice', 'Brown Rice', 'Rye Pasta']
                .map((grains) => DropdownMenuItem(
                value: grains, child: Text("$grains")))
                .toList(),
            onSaved: (String value) {
              _grains = value;
            },
          ),
        ),
        SizedBox(width:10),
        Flexible(
          flex: 3,
          child: TextFormField(
            decoration: InputDecoration(labelText: "Quantity", hintText: "Quantity", contentPadding: EdgeInsets.all(0.0)),
            keyboardType: TextInputType.number,
            validator: FormBuilderValidators.numeric(),
            onSaved: (String value) {
              _grainsquantity = int.parse(value);
            },
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
            onSaved: (String value) {
              _grainsunit = value;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFruit() {
    return Row(
      mainAxisSize: MainAxisSize.min,  // see 3
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          flex:5,
          child: FormBuilderDropdown(
            attribute: "fruit",
            decoration: InputDecoration(labelText: "Fruit", contentPadding: EdgeInsets.all(0.0)),
            // initialValue: 'Male',
            hint: Text('Select Fruits'),
            // validators: [FormBuilderValidators.required()],
            items: ['Strawberries', 'Banana', 'Apple']
                .map((fruit) => DropdownMenuItem(
                value: fruit, child: Text("$fruit")))
                .toList(),
            onSaved: (String value) {
              _fruit = value;
            },
          ),
        ),
        SizedBox(width:10),
        Flexible(
          flex: 3,
          child: TextFormField(
            decoration: InputDecoration(labelText: "Quantity", hintText: "Quantity", contentPadding: EdgeInsets.all(0.0)),
            keyboardType: TextInputType.number,
            validator: FormBuilderValidators.numeric(),
            onSaved: (String value) {
              _fruitquantity = int.parse(value);
            },
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
            onSaved: (String value) {
              _fruitunit = value;
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding:false,
      appBar: AppBar(title: Text("Recipe Input")),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildTitle(),
              SizedBox(height: 20),
              _buildProtein(),
              SizedBox(height: 20),
              _buildVegetables(),
              SizedBox(height: 20),
              _buildGrains(),
              SizedBox(height: 20),
              _buildFruit(),
              SizedBox(height: 50),
              Row(
                children: <Widget>[
              RaisedButton(
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    print("Error");
                  }

                  _formKey.currentState.save();

                  print(_recipe_title);
                  print(_protein+" "+_proteinquantity.toString()+_proteinunit);
                  print(_vegetables+" "+_vegetablesquantity.toString()+_vegetablesunit);
                  print(_grains+" "+_grainsquantity.toString()+_grainsunit);
                  print(_fruit+" "+_fruitquantity.toString()+_fruitunit);

                  //Send to API
                },
              ),
              RaisedButton(
                child: Text("Reset"),
                onPressed: () {
                  _formKey.currentState.reset();
                },
              ),
                  ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
