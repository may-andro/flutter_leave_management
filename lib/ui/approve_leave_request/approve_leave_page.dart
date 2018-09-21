import 'package:flutter/material.dart';

class ApproveLeavePage extends StatelessWidget {

  final String message = "Hi Team,\n\n\n\I would like to "
      "request for leave from this date to that date to "
      "spend with family and friend.\n\n\nYours truely\n\nsender name";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: new Text(
          "Approve Leave",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: buildContent(),
    );
  }

  Widget buildContent() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Colors.black87,
                      letterSpacing: 1.2,
                      fontFamily: 'Poppins',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                ),


                Container(
                  height: 48.0,
                  width: double.infinity,
                  margin: EdgeInsets.all(20.0),
                  child: RaisedButton(
                    elevation: 6.0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    padding: EdgeInsets.all(0.0),
                    color: Colors.black,
                    child: Text(
                      'Approve Leave',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
