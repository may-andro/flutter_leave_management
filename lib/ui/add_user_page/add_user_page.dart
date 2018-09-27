import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/loading_widget.dart';
import 'package:flutter_mm_hrmangement/components/no_data_found_widget.dart';
import 'package:flutter_mm_hrmangement/model/ProjectModel.dart';
import 'package:flutter_mm_hrmangement/model/RoleModel.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/signin_page/components/reveal_progress_button_painter.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'dart:convert';

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
  Role _userRole;

  double _fraction = 0.0;
  var _isPressed = false, _animatingReveal = false;
  int _state = 0;
  double _width = double.infinity;

  List<DropdownMenuItem<Role>> _dropDownMenuItemsForRole;
  List<DropdownMenuItem<int>> _dropDownMenuItemsForNumberOfHoliday;

  final AsyncMemoizer _memoizer = AsyncMemoizer();

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

    _dropDownMenuItemsForNumberOfHoliday =
        getDropDownMenuItemsForNumberOfHoliday();
    _numberOfHoliday = _dropDownMenuItemsForNumberOfHoliday[0].value;
  }

  void reset() {
    _width = double.infinity;
    _animatingReveal = false;
    _state = 0;
  }

  Future _fetchData() {
    return this._memoizer.runOnce(() async {
      print("How many times");
      var data = await Firestore.instance.collection("roleCollection").getDocuments();

      _dropDownMenuItemsForRole = getDropDownMenuItemsForRole(data);
      _userRole = _dropDownMenuItemsForRole[0].value;

      return data;


    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: new Text(
          "Add New Member",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return FutureBuilder(
        future: _fetchData(),
        builder: (context, AsyncSnapshot snapShot) {
          if (!snapShot.hasData) {
            return LoadingWidget("Fetching data from server");
          } else {
            if (snapShot.data.documents.length == 0) {
              return NoDataFoundWidget("You have not applied for leaves yet");
            } else {
              print(snapShot.data.documents.length);
              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Form(
                              key: formKey,
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  createTextFormFieldName(),
                                  createTextFormFieldMmid(),
                                  createTextFormFieldPin(),
                                  createRoleDropDown(),
                                  createLeaveDropDown(),
                                ],
                              )
                          ),

                          Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Center(
                              child: CustomPaint(
                                painter: RevealProgressButtonPainter(
                                    _fraction,
                                    MediaQuery.of(context).size),
                                child: Container(
                                  height: 48.0,
                                  width: _width,
                                  child: RaisedButton(
                                    elevation: calculateElevation(),
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                        new BorderRadius.circular(
                                            30.0)),
                                    padding: EdgeInsets.all(0.0),
                                    color: _state == 2
                                        ? Colors.deepPurple
                                        : Colors.black,
                                    child: buildButtonChild(),
                                    onPressed: () {
                                      //do the login
                                      if (formKey.currentState
                                          .validate()) {
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
                      ),
                    ),
                  )
                ],
              );
            }
          }
        });
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

  List<DropdownMenuItem<int>> getDropDownMenuItemsForNumberOfHoliday() {
    List<DropdownMenuItem<int>> items = new List();
    for (int i = 0; i < 27; i++) {
      items.add(DropdownMenuItem(
          value: i, child: Container(color: Colors.white, child: Text('$i'))));
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
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
            ),
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
      ),
    );
  }

  Widget createRoleDropDown() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Authentication Level',
          border: OutlineInputBorder(),
        ),
        child: DropdownButtonHideUnderline(
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
            ),
            child: DropdownButton<Role>(
              value: _userRole,
              isDense: true,
              onChanged: (Role newValue) {
                print(newValue);
                setState(() {
                  _userRole = newValue;
                });
              },
              items: _dropDownMenuItemsForRole,
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<Role>> getDropDownMenuItemsForRole(QuerySnapshot snapShot) {
    List<DropdownMenuItem<Role>> _dropdownMenuItem = [];

    snapShot.documents.forEach((snapshot) {
      Role role = Role.fromJson(snapshot);
      _dropdownMenuItem.add(DropdownMenuItem(
          value: role,
          child: Container(color: Colors.white, child: Text('${role.title}'))));
    });

    return _dropdownMenuItem;
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

    Firestore.instance.runTransaction((Transaction transaction) async {
      var role = {
        "id" : _userRole.id,
        "title" : "${_userRole.title}",
        "shortcut" : "${_userRole.shortcut}",
      };

      CollectionReference reference = Firestore.instance.collection('userCollection');
      await reference.document(_mmid).setData({
        "mmid": "$_mmid",
        "name": "$_name",
        "avatar": "",
        "role": role,
        "remainingLeaves": _numberOfHoliday,
        "totalLeaves": _numberOfHoliday,
      });
    });

    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('pinCollection');
      await reference.document(_mmid).setData({
        "mmid": "$_mmid",
        "pin": "$_password",
      });
    });


    Firestore.instance.runTransaction((transaction) async {
      var snapshot = await Firestore.instance.collection('projectCollection').document('hyd_pto_planning').get();
      Project project = Project.fromJson(snapshot.data);
      print(json.encode(project.team));
      project.team.add(ProjectUser(
          name: '$_name',
          mmid: '$_mmid',
          isManager: (_userRole.id == 0 || _userRole.id == 1 || _userRole.id == 4 || _userRole.id == 5 || _userRole.id == 6) ? true: false));
      print(json.encode(project));
      var updatedTeam = project.team.map((projectUser) {
        Map<String,dynamic> projectUserMap = new Map<String,dynamic>();
        projectUserMap["mmid"] = projectUser.mmid;
        projectUserMap["name"] = projectUser.name;
        projectUserMap["isManager"] = projectUser.isManager;
        print(projectUserMap);
        return projectUserMap;
      }).toList();
      await transaction.update(snapshot.reference, {"team": updatedTeam});
      setState(() {
        _state = 2;
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
              replace: true, transition: TransitionType.fadeIn);
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