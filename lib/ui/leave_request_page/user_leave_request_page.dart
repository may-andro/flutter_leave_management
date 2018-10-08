import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/date_time_picker_widget.dart';
import 'package:flutter_mm_hrmangement/components/loading_widget.dart';
import 'package:flutter_mm_hrmangement/components/text_label_widget.dart';
import 'package:flutter_mm_hrmangement/model/ProjectModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/leave_request_page/components/label_widget.dart';
import 'package:flutter_mm_hrmangement/ui/signin_page/components/reveal_progress_button_painter.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveRequestPage extends StatefulWidget {
  @override
  _LeaveRequestPageState createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage>
    with TickerProviderStateMixin {
  //Animation
  Animation<double> _animationReval, _animationShrink;
  AnimationController _controllerReveal, _controllerShrink;

  final _globalKey = GlobalKey();

  String _typeOfLeave;
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  List<User> senderList;

  double _fraction = 0.0;
  var _isPressed = false, _animatingReveal = false;
  int _state = 0;
  double _width = double.infinity;

  var leaveId = '';
  bool isSingleDaySelected = true;

  List<DropdownMenuItem<String>> _dropDownMenuItemsForTypeOfLeavel;

  final TextEditingController textEditingController = TextEditingController();

  final AsyncMemoizer _memoizer = AsyncMemoizer();
  List<ProjectUser> teamList = [];
  List<String> fcmTokenList = [];

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

    _dropDownMenuItemsForTypeOfLeavel = getDropDownMenuItemsForLeaveType();
    _typeOfLeave = _dropDownMenuItemsForTypeOfLeavel[0].value;
  }

  void reset() {
    _width = double.infinity;
    _animatingReveal = false;
    _state = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: new Text(
          "Leave Request",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: createUi(context),
    );
  }

  Future _fetchData(User user) {
    return this._memoizer.runOnce(() async {
      Map<String, dynamic> projectUserMap = {};
      projectUserMap["mmid"] = '${user.mmid}';
      projectUserMap["name"] = '${user.name}';
      projectUserMap["isManager"] = (user.role.id == 0 ||
              user.role.id == 1 ||
              user.role.id == 4 ||
              user.role.id == 5 ||
              user.role.id == 6)
          ? true
          : false;
      print('projectUserMap data: $projectUserMap');

      var data1 = await Firestore.instance
          .collection("projectCollection")
          .getDocuments();
      print('projectUserMap data: ${data1.documents.length}');

      var data = await Firestore.instance
          .collection("projectCollection")
          .where('team', arrayContains: projectUserMap)
          .getDocuments();
      print('projectUserMap data: ${data.documents.length}');
      data.documents.map<Widget>((DocumentSnapshot documentSnapshot) {
        Project project = Project.fromJson(documentSnapshot.data);
        project.team.forEach((projectUser) {
          if (!teamList.contains(projectUser) &&
              projectUser.isManager &&
              projectUser.mmid != user.mmid) {
            teamList.add(projectUser);
            print('projectUser data: ${projectUser}');
          }
        });
      }).toList();

      teamList.forEach((projectUser) {
        Firestore.instance
            .collection("fcmCollection")
            .document(projectUser.mmid)
            .get()
            .then((snapshot) {
          fcmTokenList.add(snapshot['token']);
        });
      });

      print('teamList data: ${teamList.length}');
      print('fcmTokenList data: ${fcmTokenList.length}');
      return teamList;
    });
  }

  Widget createUi(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.fromStore(store),
        builder: (BuildContext context, _ViewModel viewModel) {
          return FutureBuilder(
            future: _fetchData(viewModel.user),
            builder: (context, AsyncSnapshot snapShot) {
              if (!snapShot.hasData) {
                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                        color: Colors.pinkAccent,
                        child: LoadingWidget("Fetching data..."))
                  ],
                );
              } else {
                return Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                LabelWidget(
                                    'Single day',
                                    isSingleDaySelected
                                        ? Colors.deepPurple
                                        : Colors.white,
                                    isSingleDaySelected
                                        ? Colors.white
                                        : Colors.grey,
                                    'Multiple Day',
                                    !isSingleDaySelected
                                        ? Colors.deepPurple
                                        : Colors.white,
                                    !isSingleDaySelected
                                        ? Colors.white
                                        : Colors.grey, () {
                                  setState(() {
                                    isSingleDaySelected = true;
                                  });
                                }, () {
                                  setState(() {
                                    isSingleDaySelected = false;
                                  });
                                }),

                                createDatePickerDependingOnLeaveDays(),

                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                ),

                                LabelWidget(
                                    'Leave type',
                                    Colors.deepPurple,
                                    Colors.white,
                                    'Dummy',
                                    Colors.white,
                                    Colors.white, () {}, () {}
                                    ),

                                createLeaveTypeDropDown(context, viewModel.user),

                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                ),

                                LabelWidget(
                                    'Request to',
                                    Colors.deepPurple,
                                    Colors.white,
                                    'Dummy',
                                    Colors.white,
                                    Colors.white, () {}, () {}
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
                                              children: getFilterChips(
                                                      snapShot.data,
                                                      viewModel.user)
                                                  .map((Widget chip) {
                                            return new Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
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

                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                ),

                                LabelWidget(
                                    'Your message',
                                    Colors.deepPurple,
                                    Colors.white,
                                    'Dummy',
                                    Colors.white,
                                    Colors.white, () {}, () {}
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(getLeaveMessage(_toDate.compareTo(_fromDate), _toDate, _fromDate, textEditingController.text, _typeOfLeave, viewModel.user.name)),
                                ),

                                new Padding(padding: new EdgeInsets.all(20.0)),

                                Padding(
                                  padding: EdgeInsets.all(24.0),
                                  child: Center(
                                    child: CustomPaint(
                                      painter: RevealProgressButtonPainter(
                                          _fraction,
                                          MediaQuery.of(context).size),
                                      child: Container(
                                        key: _globalKey,
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
                                            print("Cliked");
                                            setState(() {
                                              _isPressed = !_isPressed;
                                              if (_state == 0) {
                                                animateButton(viewModel.user);
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          );
        });
  }

  List<DropdownMenuItem<String>> getDropDownMenuItemsForLeaveType() {
    List<DropdownMenuItem<String>> items = new List();
    for (String authLevel in LEAVE_TYPE) {
      items.add(
          new DropdownMenuItem(value: authLevel, child: new Text(authLevel)));
    }
    return items;
  }

  Widget createLeaveTypeDropDown(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Select Leave Type',
          border: OutlineInputBorder(),
        ),
        isEmpty: _typeOfLeave == '',
        child: DropdownButtonHideUnderline(
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.white,
            ),
            child: DropdownButton<String>(
              value: _typeOfLeave,
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  _typeOfLeave = newValue;
                  _showDialog(context);
                });
              },
              items: getDropDownMenuItemsForLeaveType(),
            ),
          ),
        ),
      ),
    );
  }


  void _showDialog(
      BuildContext context) {
    var alert = AlertDialog(
      title: Text("Generate your message"),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Here is an example',
            style: Theme.of(context).textTheme.subhead,),
            Text('I have to an appointment with doctor at 2pm.',
              style: Theme.of(context).textTheme.body2,),

            Padding(
              padding: EdgeInsets.all(6.0),
            ),

            Text('Tip',
              style: Theme.of(context).textTheme.subhead),
            Text('Keep it short and to the point, we will generate you a message',
                style: Theme.of(context).textTheme.caption),

            Padding(
              padding: EdgeInsets.all(16.0),
            ),

            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: textEditingController,
              keyboardType: TextInputType.text,
              onSaved: (String val) {
              },
              decoration: InputDecoration(
                labelText: 'Your reason',
                hintText: 'Enter your reason',
                errorMaxLines: 1,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          color: Colors.transparent,
          child: Text("Done"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );

    showDialog(context: context, builder: (context) => alert);
  }

  void animateButton(User user) async {
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

    print("dates are $_fromDate  $_toDate ${fcmTokenList.length}");
    fcmTokenList.forEach((token) {
      sendNotification(token, user);
    });

    leaveId = '${user.mmid}_${DateTime.now()}';

    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference =
          Firestore.instance.collection('leaveCollection');
      await reference.document(leaveId).setData({
        "mmid": "${user.mmid}",
        "typeOfLeave": "$_typeOfLeave",
        "startDate": _fromDate,
        "endDate": _toDate,
        "isSingleDayLeave": isSingleDaySelected,
        "numberOfDays": _fromDate.compareTo(_toDate),
        "message": "To be  add",
        "status": 0,
      });

      setState(() {
        _state = 2;
      });

      _animatingReveal = true;
      reveal();
    });
  }

  void sendNotification(String sendingToken, User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var fcm_token = prefs.getString(FIREBASE_FCM_TOKEN);
    var base = 'https://us-central1-mm-leavemanagement.cloudfunctions.net/';
    String dataURL = '$base/sendNotification?'
        'to=${sendingToken}'
        '&fromPushId=$fcm_token'
        '&fromId=$leaveId'
        '&fromName=${user.name}'
        '&fromMessage=${getLeaveMessage(_toDate.compareTo(_fromDate), _toDate, _fromDate, textEditingController.text, _typeOfLeave, user.name)}'
        '&isApproved=false'
        '&type=leave_request';
    print(dataURL);
    await http.get(dataURL).then((response) {});
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
          Router().printTree();

          Navigation.navigateTo(context, 'home',
              replace: true, transition: TransitionType.fadeIn);
        }
      });
    _controllerReveal.forward();
  }

  Widget buildButtonChild() {
    if (_state == 0) {
      return Text(
        'Request Leave',
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

  List<Widget> getStringFilterChips(List<ProjectUser> managerList) {
    List<Widget> filterChips =
        managerList.map<Widget>((ProjectUser projectUser) {
      return new InputChip(
        avatar: Container(
            child: new CircleAvatar(
              child: const Text('CA'),
              foregroundColor: Colors.white,
            ),
            padding: const EdgeInsets.all(2.0), // borde width
            decoration: new BoxDecoration(
              color: const Color(0xFFFFFFFF), // border color
              shape: BoxShape.circle,
            )),
        key: new ValueKey<ProjectUser>(projectUser),
        label: new Text(
          (projectUser.name),
          style: Theme.of(context).textTheme.subhead,
        ),
      );
    }).toList();
    return filterChips;
  }

  List<Widget> getFilterChips(List<ProjectUser> documents, User user) {
    print('senders are ${documents.length}');
    print('tokens are ${fcmTokenList.length}');
    List<Widget> filterChips = [];
    filterChips.addAll(getStringFilterChips(documents));
    return filterChips;
  }

  Widget createDatePickerDependingOnLeaveDays() {
    if (isSingleDaySelected) {
      return createTextFormFieldForDate(_fromDate, "On ", (DateTime date) {
        setState(() {
          _fromDate = date;
          _toDate = date;
        });
      });
    } else {
      return Column(
        children: <Widget>[
          createTextFormFieldForDate(_fromDate, "From ", (DateTime date) {
            setState(() {
              _fromDate = date;
            });
          }),
          createTextFormFieldForDate(_toDate, "To ", (DateTime date) {
            setState(() {
              _toDate = date;
            });
          }),
        ],
      );
    }
  }

  Widget createTextFormFieldForDate(
      DateTime date, String label, Function onSelect) {
    return Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 16.0),
        child: DateTimePicker(
          labelText: label,
          selectedDate: date,
          selectDate: onSelect,
        ));
  }
}

class _ViewModel {
  final User user;

  _ViewModel({
    @required this.user,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(user: store.state.loginState.user);
  }
}


String getLeaveMessage(int dayCount, DateTime _fromDate, DateTime _toDate,
    String reason, String typeOfLeave, String name) {

  print(DateFormat.yMMMMd().format(DateTime.fromMicrosecondsSinceEpoch(_fromDate.millisecondsSinceEpoch * 1000)));
  print(DateFormat.yMMMMd().format(DateTime.fromMicrosecondsSinceEpoch(_toDate.millisecondsSinceEpoch * 1000)));
  print(_toDate.difference(_fromDate).inDays);

  String vocationalMessage = 'Hi Team!'
      '\n\n'
      'I would like to reuest for ${dayCount} ${dayCount > 1 ? 'days' : 'day '}'
      ' leave to spend time with my family and friends '
      '${dayCount > 1 ? 'from ${DateFormat.yMMMMd().format(DateTime.fromMicrosecondsSinceEpoch(_fromDate.millisecondsSinceEpoch * 1000))} to ${DateFormat.yMMMMd().format(DateTime.fromMicrosecondsSinceEpoch(_toDate.millisecondsSinceEpoch * 1000))}.'
      : 'on ${DateFormat.yMMMMd().format(DateTime.fromMicrosecondsSinceEpoch(_fromDate.millisecondsSinceEpoch * 1000))} '} '
      'I will available on phone and email in case of any need/assiatance.'
      '\n'
      'I request you to grant me the requested leaves'
      '\n\n'
      'Your truly'
      '\n'
      '$name';

  String sickLeaveMessage = 'Hi Team!'
      '\n\n'
      'I would like to reuest for ${dayCount} ${dayCount > 1 ? 'days' : 'day '} sick leave ${dayCount > 1 ? 'from ${DateFormat.yMMMMd().format(DateTime.fromMicrosecondsSinceEpoch(_fromDate.millisecondsSinceEpoch * 1000))} to ${DateFormat.yMMMMd().format(DateTime.fromMicrosecondsSinceEpoch(_toDate.millisecondsSinceEpoch * 1000))}.'
      : 'on ${DateFormat.yMMMMd().format(DateTime.fromMicrosecondsSinceEpoch(_fromDate.millisecondsSinceEpoch * 1000))} '} '
      '. $reason'
      '\n'
      'I request you to grant me the requested sick leaves'
      '\n\n'
      'Your truly'
      '\n'
      '$name';
  String workFromHomeMessage = 'Hi Team!'
      '\n\n'
      'I would like to reuest for work from home on ${DateFormat.yMMMMd().format(DateTime.fromMicrosecondsSinceEpoch(_fromDate.millisecondsSinceEpoch * 1000))} as $reason.'
      'I will available on phone, Slack, Hangout and email to collaborate with the team mates and fullfill my duities for the day.'
      '\n'
      'I request you to grant me the work from home for ${DateFormat.yMMMMd().format(DateTime.fromMicrosecondsSinceEpoch(_fromDate.millisecondsSinceEpoch * 1000))}'
      '\n\n'
      'Your truly'
      '\n'
      '$name';
  switch (typeOfLeave) {
    case "Vacation and Family":
      return vocationalMessage;
    case "Sick Leave/ Emergency Leave":
      return sickLeaveMessage;
    case "Work from home":
      return workFromHomeMessage;
  }
}

