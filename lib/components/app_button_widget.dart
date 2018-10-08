import 'package:flutter/material.dart';

class AppButtonWidget extends StatelessWidget {
  final Function onPressed;
  final String label;

  AppButtonWidget(this.onPressed, this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(24.0),
        child: Container(
          height: 48.0,
          width: double.infinity,
          child: RaisedButton(
            elevation: 6.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            padding: EdgeInsets.all(0.0),
            color: Colors.black,
            onPressed: onPressed,
            child: Text(label,
                style: TextStyle(color: Colors.white, fontSize: 16.0)),
          ),
        ));
  }
}
