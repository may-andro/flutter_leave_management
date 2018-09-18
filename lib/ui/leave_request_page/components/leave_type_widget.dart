import 'package:flutter/material.dart';

class LeaveTypeWidget extends StatefulWidget {
  @override
  _LeaveTypeWidgetState createState() => _LeaveTypeWidgetState();
}

class _LeaveTypeWidgetState extends State<LeaveTypeWidget> {

  int radioValue = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _createContent(),
    );
  }

  void handleRadioButtonValueChange(int value) {
    setState(() {
      radioValue = value;
    });
  }

  Widget _createContent() {
    return Container(
      child: Column(
        children: <Widget>[
          new Text(
            "Select the dates for your leaves",
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: new TextStyle(
                fontWeight: FontWeight.w300,
                letterSpacing: 0.5,
                color: Colors.black38,
                fontSize: 18.0),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
          ),

          new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              new Column(
                children: <Widget>[
                  new Radio<int>(
                    value: 0,
                    groupValue: radioValue,
                    onChanged: handleRadioButtonValueChange,
                    activeColor: Colors.brown,
                  ),
                  new Text("Vocation and Family",
                    style: TextStyle(
                        color: Colors.blueGrey
                    ),
                  ),
                ],
              ),

              new Padding(padding: new EdgeInsets.all(8.0)),

              new Column(
                children: <Widget>[
                  new Radio<int>(
                    value: 2,
                    groupValue: radioValue,
                    onChanged: handleRadioButtonValueChange,
                    activeColor: Colors.redAccent,
                  ),

                  new Text("Sick Leave/ Emergency Leave",
                    style: TextStyle(
                        color: Colors.blueGrey
                    ),
                  ),

                ],
              ),

              new Padding(padding: new EdgeInsets.all(8.0)),

              new Column(
                children: <Widget>[
                  new Radio<int>(
                    value: 1,
                    groupValue: radioValue,
                    onChanged: handleRadioButtonValueChange,
                    activeColor: Colors.redAccent,
                  ),

                  new Text("Work from home",
                    style: TextStyle(
                        color: Colors.blueGrey
                    ),
                  ),

                ],
              ),

              new Padding(padding: new EdgeInsets.all(16.0)),
            ],
          ),
        ],
      ),
    );
  }
}
