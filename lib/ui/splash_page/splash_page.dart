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
                        child:
                            new FlutterLogo(colors: Colors.pink, size: 80.0)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                        child: new Text("Leave Management",
                            style: new TextStyle(fontSize: 32.0))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Center(
                        child: new Text("for Mutual Mobile",
                            style: new TextStyle(fontSize: 16.0))),
                  ),
                ], mainAxisAlignment: MainAxisAlignment.center),
              ),
            ])),
        theme: new ThemeData(
          primarySwatch: Colors.deepPurple,
          canvasColor: Colors.transparent,
        ));
  }
}
