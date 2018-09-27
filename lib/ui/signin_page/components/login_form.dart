import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/actions/actions.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/signin_page/components/reveal_progress_button_painter.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginFormWidget extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginFormWidget>
    with TickerProviderStateMixin {

  OnLoginCallback callback;

  Animation<double> _animationReval, _animationShrink;
  AnimationController _controllerReveal, _controllerShrink;

  final containerKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  String _mmid = "MM0007";
  String _password = "1234";

  var _isPressed = false;
  var _animatingReveal = false;

  double _fraction = 0.0;
  double _width = double.infinity;

  int _state = 0;

  @override
  void initState() {
    super.initState();

    _controllerReveal = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);

    _controllerShrink = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
  }

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
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnLoginCallback>(
      converter: (Store<AppState> store) {
        return (user) => store.dispatch(LoginUserAction(user));
      },
        builder: (BuildContext context, OnLoginCallback callback) {
          return Padding(
            padding: EdgeInsets.all(24.0),
            child: Form(
                key: formKey,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    createUserIdInputField(),
                    createUserPinField(),
                    createForgotPinField(),
                    createLoginButton(callback),
                  ],
                )),
          );
        }
    );
  }

  Widget createUserIdInputField(){
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withOpacity(0.5),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin:
      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          new Padding(
            padding:
            EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Icon(
              Icons.person,
              color: Colors.grey,
            ),
          ),
          Container(
            height: 30.0,
            width: 1.0,
            color: Colors.grey.withOpacity(0.5),
            margin: const EdgeInsets.only(left: 00.0, right: 10.0),
          ),
          new Expanded(
            child:

            TextFormField(
              initialValue: _mmid,
              validator: (val) => val.isEmpty ? 'Invalid  mmid' : null,
              keyboardType: TextInputType.text,
              onSaved: (String val) {
                _mmid = val;
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enteryour mmid',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget createUserPinField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.withOpacity(0.5),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin:
        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Row(
          children: <Widget>[
            new Padding(
              padding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Icon(
                Icons.lock,
                color: Colors.grey,
              ),
            ),
            Container(
              height: 30.0,
              width: 1.0,
              color: Colors.grey.withOpacity(0.5),
              margin: const EdgeInsets.only(left: 00.0, right: 10.0),
            ),
            new Expanded(
              child:

              TextFormField(
                initialValue: _password,
                obscureText: true,
                validator: (val) =>
                val.length == 0 ? 'Password invalid' : null,
                onSaved: (String val) {
                  _password = val;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your pin',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  Widget createForgotPinField() {
    return
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: new FlatButton(
              child: new Text(
                "Forgot Password?",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                  fontSize: 15.0,
                ),
                textAlign: TextAlign.end,
              ),
              onPressed: () => {},
            ),
          ),
        ],
      );
  }

  Widget createLoginButton(OnLoginCallback callback){
    return Padding(
      padding: EdgeInsets.all(24.0),
      child: Center(
        child: CustomPaint(
          painter: RevealProgressButtonPainter(_fraction, MediaQuery.of(context).size),
          child: Container(
            key: containerKey,
            height: 48.0,
            width: _width,
            child: RaisedButton(
              elevation: calculateElevation(),
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              padding: EdgeInsets.all(0.0),
              color: _state == 2 ? Colors.deepPurple : Colors.black,
              child: buildButtonChild(),
              onPressed: () {
                //do the login
                if (formKey.currentState.validate()) {
                  formKey.currentState.save();
                  FocusScope.of(context).requestFocus(new FocusNode());
                  setState(() {
                    _isPressed = !_isPressed;
                    if (_state == 0) {
                      animateButton(callback);
                    }
                  });
                }
              },
            ),
          ),
        ),
      ),
    );
  }





  Future animateButton(OnLoginCallback callback) async {
    double initialWidth = containerKey.currentContext.size.width;

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

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('pinCollection')
        .where('mmid', isEqualTo: '$_mmid')
        .getDocuments();

    print(querySnapshot.documents.length);
    if( querySnapshot.documents.length > 0) {
      String fireStorePin = querySnapshot.documents[0]['pin'] as String;

      if(fireStorePin == _password) {


        QuerySnapshot userQuerySnapshot = await Firestore.instance
            .collection('userCollection')
            .where('mmid', isEqualTo: '$_mmid')
            .getDocuments();


        User user = User.fromJson(userQuerySnapshot.documents[0]);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(LOGGED_IN_USER_PASSWORD, _password);
        prefs.setString(LOGGED_IN_USER_MMID, _mmid);

        //login;
        callback(user);

        setState(() {
          _state = 2;
        });

        _animatingReveal = true;

        reveal();
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
                "pin is wrong")));
        _controllerShrink.reverse();
        reset();
      }

    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
              "User doesn't exists")));

      _controllerShrink.reverse();
      reset();
    }
  }

  Widget buildButtonChild() {
    if (_state == 0) {
      return Text(
        'Login',
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

  void  reset() {
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
          Navigation.navigateTo(context, 'home',  replace: true,
              transition: TransitionType.fadeIn);
        }
      });
    _controllerReveal.forward();
  }




}

typedef OnLoginCallback = Function(User user);

enum LoginStatusStatus {
  loading,
  error,
  success,
}

void _showDialog(
    BuildContext context, String message) {
  var alert = AlertDialog(
    title: Text("FCM DEMO"),
    content: Text(message),
    actions: <Widget>[
      FlatButton(
        color: Colors.transparent,
        child: Text("Delete"),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ],
  );

  showDialog(context: context, builder: (context) => alert);
}