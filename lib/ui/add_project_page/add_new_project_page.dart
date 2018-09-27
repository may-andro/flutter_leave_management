import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/text_label_widget.dart';
import 'package:flutter_mm_hrmangement/model/ProjectModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/ui/signin_page/components/reveal_progress_button_painter.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';

class AddNewProjectPage extends StatefulWidget {

  final List<User> teamList;

  AddNewProjectPage({Key key, @required this.teamList}) : super(key: key);

  @override
  _AddNewProjectPageState createState() => _AddNewProjectPageState();
}

class _AddNewProjectPageState extends State<AddNewProjectPage> with TickerProviderStateMixin {

  Animation<double> _animationReval, _animationShrink;
  AnimationController _controllerReveal, _controllerShrink;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _projectName;

  double _fraction = 0.0;
  double _width = double.infinity;
  int _state = 0;
  var _isPressed = false, _animatingReveal = false;


  @override
  void deactivate() {
    reset();
    super.deactivate();
  }

  @override
  dispose() {
    _controllerReveal.dispose();
    _controllerShrink.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controllerReveal = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _controllerShrink = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  Widget buildButtonChild() {
    if (_state == 0) {
      return Text(
        'Add Project',
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      );
    } else if (_state == 1) {
      return SizedBox(
        height: 36.0,
        width: 36.0,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Icon(Icons.check, color: Colors.white);
    }
  }

  double calculateElevation() {
    if (_animatingReveal) {
      return 0.0;
    } else {
      return _isPressed ? 6.0 : 4.0;
    }
  }

  void reset() {
    _width = double.infinity;
    _animatingReveal = false;
    _state = 0;
  }

  void reveal() {
    _animationReval = Tween(begin: 0.0, end: 1.0).animate(_controllerReveal)
      ..addListener(() {
        setState(() {
          _fraction = _animationReval.value;
        });
      })
      ..addStatusListener((AnimationStatus state) {
        if (state == AnimationStatus.completed) {
          print("Animation completd");
          Navigation.navigateTo(context, 'project_management',  replace: true, transition: TransitionType.inFromRight);
        }
      });
    _controllerReveal.forward();
  }

  void animateButton() {
    double initialWidth = _scaffoldKey.currentContext.size.width;

    _animationShrink = Tween(begin: 0.0, end: 1.0).animate(_controllerShrink)
      ..addListener(() {
        setState(() {
          _width =
              initialWidth - ((initialWidth - 48.0) * _animationShrink.value);
        });
      });
    _controllerShrink.forward();

    setState(() {
      _state = 1;
    });

    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('projectCollection');
      var team = widget.teamList.map((user) {
        Map<String,dynamic> projectUserMap = new Map<String,dynamic>();
        projectUserMap["mmid"] = user.mmid;
        projectUserMap["name"] = user.name;
        projectUserMap["isManager"] = (user.role.id == 0 || user.role.id == 1 || user.role.id == 4 || user.role.id == 5 || user.role.id == 6) ? true: false;
        print(projectUserMap);
        return projectUserMap;
      }).toList();

      await reference.document(_projectName).setData({
        "name": "$_projectName",
        "team": team,
      });

      setState(() {
        _state = 2;
      });

      _animatingReveal = true;
      reveal();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar:AppBar(
          elevation: 0.0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: new Text(
            "Create Project",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                TextLabelWidget('Project Name', Colors.white, Colors.deepPurple, () {}),
                                TextLabelWidget('Dummy', Colors.white, Colors.white, () {}),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 4.0, left: 16.0, right: 16.0),
                              child: TextFormField(
                                validator: (val) =>
                                val.length == 0 ? 'project name is empty' : null,
                                onSaved: (String val) {
                                  _projectName = val;
                                },
                                keyboardType: TextInputType.text,
                                decoration: new InputDecoration(
                                  labelText: 'Project name',
                                  border: OutlineInputBorder(),
                                  hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
                                ),
                              ),
                            ),


                            Padding(
                              padding: const EdgeInsets.all(20.0),
                            ),

                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                TextLabelWidget('Team Members', Colors.white, Colors.deepPurple, () {}),
                                TextLabelWidget('Dummy', Colors.white, Colors.white, () {}),
                              ],
                            ),

                            new Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    child: Padding(
                                      child: Wrap(
                                          children: getFilterChips().map((Widget chip) {
                                            return new Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: chip,
                                            );
                                          }).toList()),
                                      padding: const EdgeInsets.only(
                                          top: 4.0, left: 16.0),
                                    ),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),

                            new Padding(padding: new EdgeInsets.all(20.0)),

                            Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Center(
                                child: CustomPaint(
                                  painter: RevealProgressButtonPainter(_fraction, MediaQuery.of(context).size),
                                  child: Container(
                                    height: 48.0,
                                    width: _width,
                                    child: RaisedButton(
                                      elevation: calculateElevation(),
                                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                      padding: EdgeInsets.all(0.0),
                                      color: _state == 2 ? Colors.deepPurple : Colors.black,
                                      child: buildButtonChild(),
                                      onPressed: () {
                                        debugPrint('${_formKey.currentState.validate()}');
                                        if (_formKey.currentState.validate()) {
                                          _formKey.currentState.save();
                                          _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("mmid : $_projectName")));
                                          setState(() {
                                            _isPressed = !_isPressed;
                                            if (_state == 0) {
                                              animateButton();
                                            }
                                          });
                                        }
                                      },
                                      onHighlightChanged: (isPressed) {},
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ]
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }




  List<Widget> getFilterChips() {
    List<Widget> filterChips = widget.teamList.map<Widget>((User user) {
      return new FilterChip(
        key: new ValueKey<String>(user.name),
        label: new Text((user.name)),
        selected: true,
        onSelected: (selected) {
          debugPrint('$selected');
        },
        selectedColor: Colors.blue,
      );
    }).toList();

    return filterChips;
  }
}
