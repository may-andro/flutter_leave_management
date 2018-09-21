import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/date_time_picker_widget.dart';
import 'package:flutter_mm_hrmangement/components/loading_widget.dart';
import 'package:flutter_mm_hrmangement/model/ProjectModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/components/text_label_widget.dart';
import 'package:flutter_mm_hrmangement/ui/signin_page/components/reveal_progress_button_painter.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

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

  bool isSingleDaySelected = true;

  List<DropdownMenuItem<String>> _dropDownMenuItemsForTypeOfLeavel;

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

  Widget createUi(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel.fromStore(store),
        builder: (BuildContext context, _ViewModel viewModel) {
          return StreamBuilder(
            stream: Firestore.instance
                .collection("projectCollection")
                .where('team', arrayContains: '${viewModel.user.mmid}')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
              if (!snapShot.hasData) {
                return Stack(
                  fit: StackFit.expand,
                    children: <Widget>[
                      LoadingWidget("Fetching data"),
                    ],);
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
                              child: Column(children: <Widget>[
                                new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[

                                    TextLabelWidget('Single day',
                                        isSingleDaySelected ? Colors.white : Colors.grey,
                                        isSingleDaySelected ? Colors.deepPurple : Colors.white, () {
                                          setState(() {
                                            isSingleDaySelected = true;
                                          });
                                        }),

                                    TextLabelWidget('Multiple Day',
                                        !isSingleDaySelected ? Colors.white : Colors.grey,
                                        !isSingleDaySelected ? Colors.deepPurple : Colors.white, () {
                                      setState(() {
                                        isSingleDaySelected = false;
                                      });
                                    }),
                                  ],
                                ),
                                createDatePickerDependingOnLeaveDays(),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    TextLabelWidget('Request To', Colors.white, Colors.deepPurple, () {}),
                                    TextLabelWidget('Dummy', Colors.white, Colors.white, () {}),
                                  ],
                                ),
                                createLeaveTypeDropDown(),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                ),
                                new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    TextLabelWidget('Leave Type', Colors.white, Colors.deepPurple, () {}),
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
                                              children: getFilterChips(
                                                      snapShot.data.documents)
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
                                                animateButton(
                                                    viewModel.user.mmid);
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

  Widget createLeaveTypeDropDown() {
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
                });
              },
              items: getDropDownMenuItemsForLeaveType(),
            ),
          ),
        ),
      ),
    );
  }

  void animateButton(String mmid) {
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

    print("dates are $_fromDate  $_toDate");
    Firestore.instance.collection('leaveCollection').document().setData({
      "mmid": "$mmid",
      "typeOfLeave": "$_typeOfLeave",
      "startDate": _fromDate,
      "endDate": _toDate,
      "isSingleDayLeave": isSingleDaySelected,
      "numberOfDays": _fromDate.compareTo(_toDate),
      "message": "To be  add",
      "status": 0,
    }).then((string) {
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
          Router().printTree();

          Navigation.navigateTo(context, 'home', replace: true,
              transition: TransitionType.fadeIn);
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

  List<Widget> getStringFilterChips(List<String> managerList) {
    List<Widget> filterChips = managerList.map<Widget>((String mmid) {
      return new InputChip(
        avatar: Container(
            child: new CircleAvatar(
              child: const Text('C'),
              foregroundColor: Colors.white,
            ),
            padding: const EdgeInsets.all(2.0), // borde width
            decoration: new BoxDecoration(
              color: const Color(0xFFFFFFFF), // border color
              shape: BoxShape.circle,
            )),
        key: new ValueKey<String>(mmid),
        label: new Text(
          (mmid),
          style: Theme.of(context).textTheme.subhead,
        ),
      );
    }).toList();

    return filterChips;
  }

  List<Widget> getFilterChips(List<DocumentSnapshot> documents) {
    List<Widget> filterChips = [];

    documents.map<Widget>((DocumentSnapshot documentSnapshot) {
      Project project = Project.fromJson(documentSnapshot);
      filterChips.addAll(getStringFilterChips(project.manager));
      filterChips.addAll(getStringFilterChips(project.lead));
    }).toList();

    filterChips.addAll(getStringFilterChips(["hyd-pto_planing"]));
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

  Widget createTextFormFieldForDate(DateTime date, String label, Function onSelect) {
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
    return new _ViewModel(user: store.state.user);
  }
}
