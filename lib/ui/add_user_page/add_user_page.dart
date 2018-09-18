import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/ui/signin_page/components/reveal_progress_button_painter.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage>
    with TickerProviderStateMixin {
  //Animation
  Animation<double> _animationReval, _animationShrink;
  AnimationController _controllerReveal, _controllerShrink;

  //Keys
  final formKey = GlobalKey<FormState>();
  final _globalKey = GlobalKey();

  String _authLevel;
  String _mmid;
  String _password;
  String _name;
  int _numberOfHoliday;
  String _department;

  double _fraction = 0.0;
  var _isPressed = false, _animatingReveal = false;
  int _state = 0;
  double _width = double.infinity;

  List<DropdownMenuItem<String>> _dropDownMenuItemsForAuthLevel;
  List<DropdownMenuItem<String>> _dropDownMenuItemsForDepartment;
  List<DropdownMenuItem<int>> _dropDownMenuItemsForNumberOfHoliday;

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

    _dropDownMenuItemsForAuthLevel = getDropDownMenuItemsForAuthLevel();
    _authLevel = _dropDownMenuItemsForAuthLevel[0].value;

    _dropDownMenuItemsForDepartment = getDropDownMenuItemsForDepartment();
    _department = _dropDownMenuItemsForDepartment[0].value;

    _dropDownMenuItemsForNumberOfHoliday =
        getDropDownMenuItemsForNumberOfHoliday();
    _numberOfHoliday = _dropDownMenuItemsForNumberOfHoliday[0].value;
  }

  void reset() {
    _width = double.infinity;
    _animatingReveal = false;
    _state = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalKey,
        appBar: new AppBar(
          title: new Text("MM employee"),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              color: Colors.white70,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    createScreenTitleText(),
                    Form(
                        key: formKey,
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            createTextFormFieldName(),
                            createTextFormFieldMmid(),
                            createTextFormFieldPin(),
                            createAuthLevelDropDown(),
                            createDepartmentDropDown(),
                            createLeaveDropDown(),
                            Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Center(
                                child: CustomPaint(
                                  painter: RevealProgressButtonPainter(
                                      _fraction, MediaQuery.of(context).size),
                                  child: Container(
                                    height: 48.0,
                                    width: _width,
                                    child: RaisedButton(
                                      elevation: calculateElevation(),
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0)),
                                      padding: EdgeInsets.all(0.0),
                                      color: _state == 2
                                          ? Colors.green
                                          : Colors.blue,
                                      child: buildButtonChild(),
                                      onPressed: () {
                                        //do the login
                                        if (formKey.currentState.validate()) {
                                          formKey.currentState.save();

                                          setState(() {
                                            _isPressed = !_isPressed;
                                            if (_state == 0) {
                                              animateButton();
                                            }
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget createScreenTitleText() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: new Text(
        "Add new employee",
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Colors.black38,
            fontSize: 18.0),
      ),
    );
  }

  Widget createTextFormFieldName() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
      child: TextFormField(
        validator: (val) => val.length == 0 ? 'Name  is empty' : null,
        onSaved: (String val) {
          _name = val;
        },
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          labelText: 'Name',
          border: OutlineInputBorder(),
          hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
        ),
      ),
    );
  }

  Widget createTextFormFieldMmid() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
      child: TextFormField(
        validator: (val) => val.isEmpty ? 'Invalid mmid' : null,
        keyboardType: TextInputType.text,
        onSaved: (String val) {
          _mmid = val;
        },
        decoration: new InputDecoration(
          labelText: 'MMID',
          border: OutlineInputBorder(),
          hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
        ),
      ),
    );
  }

  Widget createTextFormFieldPin() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
      child: TextFormField(
        validator: (val) => val.length == 0 ? 'Password is invalid' : null,
        onSaved: (String val) {
          _password = val;
        },
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          labelText: 'Pin',
          border: OutlineInputBorder(),
          hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsForAuthLevel() {
    List<DropdownMenuItem<String>> items = new List();
    for (String authLevel in AUTHORITY_LEVEL_LIST) {
      items.add(
          new DropdownMenuItem(value: authLevel, child: new Text(authLevel)));
    }
    return items;
  }

  Widget createAuthLevelDropDown() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Authority Level',
          border: OutlineInputBorder(),
        ),
        isEmpty: _authLevel == '',
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _authLevel,
            isDense: true,
            onChanged: (String newValue) {
              setState(() {
                _authLevel = newValue;
              });
            },
            items: getDropDownMenuItemsForAuthLevel(),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsForDepartment() {
    List<DropdownMenuItem<String>> items = new List();
    for (String item in DEPARTMENT_LIST) {
      items.add(new DropdownMenuItem(value: item, child: new Text(item)));
    }
    return items;
  }

  createDepartmentDropDown() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Department',
          border: OutlineInputBorder(),
        ),
        isEmpty: _department == '',
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _department,
            isDense: true,
            onChanged: (String newValue) {
              setState(() {
                _department = newValue;
              });
            },
            items: getDropDownMenuItemsForDepartment(),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<int>> getDropDownMenuItemsForNumberOfHoliday() {
    List<DropdownMenuItem<int>> items = new List();
    for (int i = 0; i < 27; i++) {
      items.add(DropdownMenuItem(value: i, child: new Text('$i')));
    }
    return items;
  }

  Widget createLeaveDropDown() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Number of Holidays',
          border: OutlineInputBorder(),
        ),
        isEmpty: _numberOfHoliday == 21,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: _numberOfHoliday,
            isDense: true,
            onChanged: (int newValue) {
              setState(() {
                _numberOfHoliday = newValue;
              });
            },
            items: getDropDownMenuItemsForNumberOfHoliday(),
          ),
        ),
      ),
    );
  }

  void animateButton() {
    double initialWidth = _globalKey.currentContext.size.width;

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

    debugPrint("$_mmid $_name $_password");
    Firestore.instance
        .collection('userCollection')
        .document('$_mmid')
        .setData({
      "mmid": "$_mmid",
      "name": "$_name",
      "avatar": "",
      "authLevel": "$_authLevel",
      "department": "$_department",
      "currentProject": "",
      "remainingLeaves": _numberOfHoliday,
      "totalLeaves": _numberOfHoliday,
    }).then((string) {
      Firestore.instance
          .collection('pinCollection')
          .document('$_mmid')
          .setData({
        "mmid": "$_mmid",
        "pin": "$_password",
      }).then((string) {
        setState(() {
          _state = 2;
        });
      });
      _animatingReveal = true;
      reveal();
    });
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
          Navigation.navigateTo(context, 'user_management',
              transition: TransitionType.fadeIn);
        }
      });
    _controllerReveal.forward();
  }

  Widget buildButtonChild() {
    if (_state == 0) {
      return Text(
        'Add',
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
}
