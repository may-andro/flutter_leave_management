import 'package:flutter/material.dart';

class NoDataFoundWidget extends StatelessWidget {
  final String message;

  NoDataFoundWidget(this.message);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "$message",
        style: TextStyle(color: Colors.deepOrange),
      ),
    );
  }
}
