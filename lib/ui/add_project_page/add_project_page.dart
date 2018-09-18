import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/ui/add_project_page/components/user_item_widget.dart';
import 'package:flutter_mm_hrmangement/ui/signin_page/components/reveal_progress_button_painter.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';

class AddProjectPage extends StatefulWidget {
  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  List<User> userList = List();
  List<User> selectedUserList = List();
  String _projectName;
  List _team;
  int _currentStep = 0;

  List<Step> _buildStepperSteps(BuildContext context) {
    List<Step> steps = [
      Step(
          title: const Text('Step 1'),
          isActive: (_currentStep == 0),
          state: getCurrentState(0),
          content: _createProjectNameWidget()),
      new Step(
          title: const Text('Step 2'),
          isActive: (_currentStep == 1),
          state: getCurrentState(1),
          content: _createSelectTeamWidget()),
      new Step(
          title: const Text('Step 3'),
          isActive: (_currentStep == 2),
          state: getCurrentState(2),
          content: _createAddNewProjectWidget()),
    ];

    return steps;
  }

  StepState getCurrentState(int i) {
    if (_currentStep < i) {
      return StepState.disabled;
    } else if (_currentStep == i) {
      return StepState.editing;
    } else {
      return StepState.complete;
    }
  }

  @override
  Widget build(BuildContext context) {

    void showSnackBarMessage(String message,
        [MaterialColor color = Colors.red]) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(message)));
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text("MM project"),
        ),
        body:
        StreamBuilder(
          stream: Firestore.instance.collection("userCollection").snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot> snapShot) {
            if(!snapShot.hasData) {
              return Center(
                child: Text(
                  "Getting data",
                  style: TextStyle(color: Colors.deepOrange),
                ),
              );
            } else {
              setTheUserList(snapShot.data.documents);
              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Stepper(
                    currentStep: this._currentStep,
                    steps: _buildStepperSteps(context),
                    type: StepperType.horizontal,
                    onStepTapped: (step) {
                      handleStepTapped(step);
                    },
                    onStepCancel: () {
                      setState(() {
                        if (_currentStep > 0) {
                          _currentStep = _currentStep - 1;
                        } else {
                          _currentStep = 0;
                        }
                      });
                    },
                    onStepContinue: () {

                      switch(_currentStep) {
                        case 0:
                          final FormState formState = _formKey.currentState;

                          if (!formState.validate()) {
                            showSnackBarMessage('Please enter correct data');
                          } else {
                            formState.save();
                            if(_projectName != null ) {
                              setState(() {
                                _currentStep = 1;
                              });
                            } else {
                              showSnackBarMessage('Empty name');
                            }
                          }
                          break;
                        case 1:
                          if( _currentStep == 1 && selectedUserList.isEmpty) {
                            debugPrint('Select team');
                          } else {
                            setState(() {
                              _currentStep = 2;
                            });
                          }
                          break;
                        case 2:
                          if(_currentStep == 2 && _projectName != null && selectedUserList.isEmpty) {
                            debugPrint('Call server');
                          } else {

                          }
                          break;
                      }
                    },
                  )
                ],
              );
            }
          },
        )
    );
  }

  void handleStepTapped(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  Widget _createAddNewProjectWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          new Text(
            "Add new project?",
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: new TextStyle(
                fontWeight: FontWeight.w300,
                letterSpacing: 0.5,
                color: Colors.black38,
                fontSize: 18.0),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
          ),
          Text("aaaa"),
          new Padding(padding: new EdgeInsets.all(16.0)),
          Wrap(
              children: getSelectedChips().map((Widget chip) {
                return new Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: chip,
                );
              }).toList()),
          new Padding(padding: new EdgeInsets.all(16.0)),
        ],
      ),
    );
  }

  Widget _createProjectNameWidget() {
    return Container(
      child: Column(
        children: <Widget>[
          new Text(
            "Enter project name",
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: new TextStyle(
                fontWeight: FontWeight.w300,
                letterSpacing: 0.5,
                color: Colors.black38,
                fontSize: 18.0),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
          ),

          Form(
            key: _formKey,
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

          new Padding(padding: new EdgeInsets.all(16.0)),
        ],
      ),
    );
  }

  Widget _createSelectTeamWidget() {

    return Container(
      child: Column(
        children: <Widget>[
          new Text(
            "Select team",
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: new TextStyle(
                fontWeight: FontWeight.w300,
                letterSpacing: 0.5,
                color: Colors.black38,
                fontSize: 18.0),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
          ),
          Wrap(
              children: getFilterChips().map((Widget chip) {
                return new Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: chip,
                );
              }).toList()),
          new Padding(padding: new EdgeInsets.all(16.0)),
        ],
      ),
    );
  }

  List<Widget> getFilterChips() {
    List<Widget> filterChips = userList.map<Widget>((User user) {
      return new FilterChip(
        key: new ValueKey<String>(user.name),
        label: new Text((user.name)),
        selected: selectedUserList.contains(user.mmid),
        onSelected: (bool) {
          debugPrint('${selectedUserList.length}');
          if(selectedUserList.contains(user.mmid)) {
            setState(() {
              selectedUserList.remove(user);
            });
          } else {
            setState(() {
              selectedUserList.add(user);
            });
          }
        },
      );
    }).toList();

    return filterChips;
  }

  List<Widget> getSelectedChips() {
    List<Widget> filterChips = selectedUserList.map<Widget>((User user) {
      return new FilterChip(
        key: new ValueKey<String>(user.name),
        label: new Text((user.name)),
        onSelected: (value) {
          //do nothing
        },
      );
    }).toList();

    return filterChips;
  }


  void setTheUserList(List<DocumentSnapshot> documents) {
    debugPrint('${userList.length}');
    userList.clear();
    documents.forEach((item) {
      User user = User.fromJson(item);
      userList.add(user);
    });
  }
}

class StepperBody extends StatefulWidget {
  @override
  _StepperBodyState createState() => new _StepperBodyState();
}

class _StepperBodyState extends State<StepperBody> {
  int currStep = 0;
  static var _focusNode = new FocusNode();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  static String name;
  static String phone;
  static String email;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
      print('Has focus: $_focusNode.hasFocus');
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  List<Step> steps = [
    new Step(
        title: const Text('Name'),
        //subtitle: const Text('Enter your name'),
        isActive: true,
        //state: StepState.error,
        state: StepState.indexed,
        content: new TextFormField(
          focusNode: _focusNode,
          keyboardType: TextInputType.text,
          autocorrect: false,
          onSaved: (String value) {
            name = value;
          },
          maxLines: 1,
          //initialValue: 'Aseem Wangoo',
          validator: (value) {
            if (value.isEmpty || value.length < 1) {
              return 'Please enter name';
            }
          },
          decoration: new InputDecoration(
              labelText: 'Enter your name',
              hintText: 'Enter a name',
              //filled: true,
              icon: const Icon(Icons.person),
              labelStyle:
                  new TextStyle(decorationStyle: TextDecorationStyle.solid)),
        )),
    new Step(
        title: const Text('Phone'),
        //subtitle: const Text('Subtitle'),
        isActive: true,
        //state: StepState.editing,
        state: StepState.indexed,
        content: new TextFormField(
          keyboardType: TextInputType.phone,
          autocorrect: false,
          validator: (value) {
            if (value.isEmpty || value.length < 10) {
              return 'Please enter valid number';
            }
          },
          onSaved: (String value) {
            phone = value;
          },
          maxLines: 1,
          decoration: new InputDecoration(
              labelText: 'Enter your number',
              hintText: 'Enter a number',
              icon: const Icon(Icons.phone),
              labelStyle:
                  new TextStyle(decorationStyle: TextDecorationStyle.solid)),
        )),
    new Step(
        title: const Text('Email'),
        // subtitle: const Text('Subtitle'),
        isActive: true,
        state: StepState.indexed,
        // state: StepState.disabled,
        content: new TextFormField(
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          validator: (value) {
            if (value.isEmpty || !value.contains('@')) {
              return 'Please enter valid email';
            }
          },
          onSaved: (String value) {
            email = value;
          },
          maxLines: 1,
          decoration: new InputDecoration(
              labelText: 'Enter your email',
              hintText: 'Enter a email address',
              icon: const Icon(Icons.email),
              labelStyle:
                  new TextStyle(decorationStyle: TextDecorationStyle.solid)),
        )),
  ];

  @override
  Widget build(BuildContext context) {
    void showSnackBarMessage(String message,
        [MaterialColor color = Colors.red]) {
      Scaffold.of(context)
          .showSnackBar(new SnackBar(content: new Text(message)));
    }

    void _submitDetails() {
      final FormState formState = _formKey.currentState;

      if (!formState.validate()) {
        showSnackBarMessage('Please enter correct data');
      } else {
        formState.save();
        print("Name: $name");
        print("Phone: $phone");
        print("Email: $email");

        showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text("Details"),
              //content: new Text("Hello World"),
              content: new SingleChildScrollView(
                child: new ListBody(
                  children: <Widget>[
                    new Text("Name : " + name),
                    new Text("Phone : " + phone),
                    new Text("Email : " + email),
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
      }
    }

    return new Container(
        child: new Form(
      key: _formKey,
      child: new Column(children: <Widget>[
        new Stepper(
          steps: steps,
          type: StepperType.vertical,
          currentStep: this.currStep,
          onStepContinue: () {
            setState(() {
              if (currStep < steps.length - 1) {
                currStep = currStep + 1;
              } else {
                currStep = 0;
              }
            });
          },
          onStepCancel: () {
            setState(() {
              if (currStep > 0) {
                currStep = currStep - 1;
              } else {
                currStep = 0;
              }
            });
          },
          onStepTapped: (step) {
            setState(() {
              currStep = step;
            });
          },
        ),
        new RaisedButton(
          child: new Text(
            'Save details',
            style: new TextStyle(color: Colors.white),
          ),
          onPressed: _submitDetails,
          color: Colors.blue,
        ),
      ]),
    ));
  }
}
