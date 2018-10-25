import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(fit: StackFit.expand, children: <Widget>[
              Container(
                color: Colors.transparent,
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Container(
                            height: 100.0,
                            width: 100.0,
                            alignment: Alignment.center,
                            child: Image.asset('assets/logo.jpg'))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                        child: Text("Leave Management",
                            style: TextStyle(fontSize: 32.0))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Center(
                        child: Text("for Mutual Mobile",
                            style: TextStyle(fontSize: 16.0))),
                  ),
                ], mainAxisAlignment: MainAxisAlignment.center),
              ),
            ])),
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          canvasColor: Colors.transparent,
        ));
  }
}
