import 'package:cupertino_radio_choice/cupertino_radio_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Details"),
      ),
      body: Bio(),
    );
  }
}

class Bio extends StatefulWidget {
  @override
  _BioState createState() => new _BioState();
}

class _BioState extends State<Bio> {
  static final Map<String, String> statusMap = {
    'pregnant': 'Pregnant',
    'lactating': 'Lactating',
    'other': 'Other',
  };

  String _selectedStatus = statusMap.keys.first;

  @override
  Widget build(BuildContext context) {
    final statusSelectionTile = new Material(
      color: Colors.transparent,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Select Status',
              style: TextStyle(
                color: CupertinoColors.systemBlue,
                fontSize: 15.0,
              )),
          const Padding(
            padding: EdgeInsets.only(bottom: 5.0),
          ),
          CupertinoRadioChoice(
              choices: statusMap,
              onChange: onStatusSelected,
              initialKeyValue: _selectedStatus)
        ],
      ),
    );

    return new Scaffold(
      body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 50),
          child: Column(children: <Widget>[statusSelectionTile])),
    );
  }

  void onStatusSelected(String statusKey) {
    setState(() {
      _selectedStatus = statusKey;
    });
  }
}