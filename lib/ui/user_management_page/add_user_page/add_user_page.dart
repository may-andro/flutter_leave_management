import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/app_bar_widget.dart';
import 'package:flutter_mm_hrmangement/components/app_button_widget.dart';
import 'package:flutter_mm_hrmangement/components/loading_widget.dart';
import 'package:flutter_mm_hrmangement/components/no_data_found_widget.dart';
import 'package:flutter_mm_hrmangement/model/RoleModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/employee_management_redux/employee_management_action.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage>
    with TickerProviderStateMixin {

  //Keys
  final formKey = GlobalKey<FormState>();
  final _globalKey = GlobalKey();

  String _mmid;
  String _password;
  String _name;
  int _numberOfHoliday;
  Role _userRole;

  List<DropdownMenuItem<Role>> _dropDownMenuItemsForRole;
  List<DropdownMenuItem<int>> _dropDownMenuItemsForNumberOfHoliday;

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  void initState() {
    super.initState();
    _dropDownMenuItemsForNumberOfHoliday =
        getDropDownMenuItemsForNumberOfHoliday();
    _numberOfHoliday = _dropDownMenuItemsForNumberOfHoliday[0].value;
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
      appBar: AppBarWidget("Add New Member"),
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

                          AppButtonWidget(
                                  () {
                                    if (formKey.currentState.validate()) {
                                      formKey.currentState.save();

                                      var role = Role(
                                        id : _userRole.id,
                                        title : "${_userRole.title}",
                                        shortcut : "${_userRole.shortcut}",
                                      );

                                      User user = User(
                                        mmid: _mmid,
                                        name: _name,
                                        avatar: '',
                                        role: role,
                                        remainingLeaves: _numberOfHoliday,
                                        totalLeaves: _numberOfHoliday
                                      );

                                      var store = StoreProvider.of<AppState>(context);
                                      store.dispatch(AddEmployeeAction(user: user, password: _password));
                                      Navigator.pop(context);
                                    }
                              }, 'Add'
                          )
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
}