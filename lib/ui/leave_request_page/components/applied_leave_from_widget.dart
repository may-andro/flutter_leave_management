import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/app_button_widget.dart';
import 'package:flutter_mm_hrmangement/components/date_time_picker_widget.dart';
import 'package:flutter_mm_hrmangement/components/loading_widget.dart';
import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import 'package:flutter_mm_hrmangement/model/ProjectModel.dart';
import 'package:flutter_mm_hrmangement/model/PublicHoliday.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/applied_leave_redux/applied_leave_action.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/leave_request_page/components/label_widget.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class AppliedLeaveFormWidget extends StatefulWidget {

  final List<PublicHoliday> publicHolidayList;

  AppliedLeaveFormWidget(this.publicHolidayList);

  @override
  _AppliedLeaveFormWidgetState createState() => _AppliedLeaveFormWidgetState();
}

class _AppliedLeaveFormWidgetState extends State<AppliedLeaveFormWidget> {

  final TextEditingController textEditingController = TextEditingController();

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  String _typeOfLeave;
  DateTime _fromDate ;
  DateTime _toDate ;
  DateTime _selectedFromDate ;
  DateTime _selectedToDate ;
  List<User> senderList;

  var leaveId = '';
  bool isSingleDaySelected = true;

  List<ProjectUser> teamList = [];
  List<String> fcmTokenList = [];

  List<DropdownMenuItem<String>> _dropDownMenuItemsForTypeOfLeavel;


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
      print('_fetchData projectUserMap data: $projectUserMap');

      var data1 = await Firestore.instance
          .collection("projectCollection")
          .getDocuments();
      print('_fetchData projectUserMap projectCollection: ${data1.documents.length}');

      var data = await Firestore.instance
          .collection("projectCollection")
          .where('team', arrayContains: projectUserMap)
          .getDocuments();
      data.documents.map<Widget>((DocumentSnapshot documentSnapshot) {
        Project project = Project.fromJson(documentSnapshot.data);
        project.team.forEach((projectUser) {
          if (!teamList.contains(projectUser) &&
              projectUser.isManager &&
              projectUser.mmid != user.mmid) {
            teamList.add(projectUser);
            print('projectUser data: ${projectUser.name}');
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

  @override
  void initState() {
    super.initState();
    _dropDownMenuItemsForTypeOfLeavel = getDropDownMenuItemsForLeaveType();
    _typeOfLeave = _dropDownMenuItemsForTypeOfLeavel[0].value;

    _fromDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    while(isPublicHoliday(_fromDate, widget.publicHolidayList) || isWeekend(_fromDate)) {
      _fromDate = _fromDate.add(Duration(days: 1, hours: 00, minutes: 00, seconds: 00, milliseconds: 00, microseconds: 00));
    }

    _toDate =  _fromDate.add(Duration(days: 1, hours: 00, minutes: 00, seconds: 00, milliseconds: 00, microseconds: 00));
    while(isPublicHoliday(_toDate, widget.publicHolidayList) || isWeekend(_toDate)) {
      _toDate = _toDate.add(Duration(days: 1, hours: 00, minutes: 00, seconds: 00, milliseconds: 00, microseconds: 00));
    }

    _selectedToDate  = _toDate;
    _selectedFromDate = _fromDate;

    if(isSingleDaySelected) _selectedToDate = _selectedFromDate;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: (Store<AppState> store) => AppliedLeaveViewModel.fromStore(store),
        builder: (BuildContext context, AppliedLeaveViewModel viewModel) {
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
                return SingleChildScrollView(
                  child: Padding(
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
                              _selectedToDate  = _selectedFromDate;
                            });
                          }, () {
                            setState(() {
                              isSingleDaySelected = false;
                              _selectedToDate = _selectedFromDate.add(Duration(days: 1, hours: 00, minutes: 00, seconds: 00, milliseconds: 00, microseconds: 00));
                              while(isPublicHoliday(_selectedToDate, widget.publicHolidayList) || isWeekend(_selectedToDate)) {
                                _selectedToDate = _selectedToDate.add(Duration(days: 1, hours: 00, minutes: 00, seconds: 00, milliseconds: 00, microseconds: 00));
                              }
                            });
                          }),

                          createDatePickerDependingOnLeaveDays(widget.publicHolidayList),

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
                            child: Text(getLeaveMessage(getNumberHolidayWithoutWeekends(widget.publicHolidayList), _selectedFromDate, _selectedToDate, textEditingController.text, _typeOfLeave, viewModel.user.name)),
                          ),


                          new Padding(padding: new EdgeInsets.all(20.0)),

                          AppButtonWidget(
                                  () {
                                    leaveId = '${viewModel.user.mmid}_${DateTime.now()}';
                                    Leave leave = Leave(
                                        mmid: viewModel.user.mmid,
                                        typeOfLeave: _typeOfLeave,
                                        startDate: _selectedFromDate,
                                        endDate: _selectedToDate,
                                        isSingleDayLeave: isSingleDaySelected,
                                        numberOfDays: getNumberHolidayWithoutWeekends(widget.publicHolidayList),
                                        status: 0,
                                        message: getLeaveMessage(getNumberHolidayWithoutWeekends(widget.publicHolidayList), _selectedFromDate, _selectedToDate, textEditingController.text, _typeOfLeave, viewModel.user.name)
                                    );

                                    var store = StoreProvider.of<AppState>(context);
                                    store.dispatch(AddLeaveAction(
                                      leave: leave,
                                      leaveId: leaveId,
                                      user: viewModel.user,
                                      fcmtokenIdList: fcmTokenList
                                    ));
                                    Navigator.pop(context);
                              }, 'Add'
                          )

                        ]
                    ),
                  ),
                );
                }
              });
        }
    );
  }

  int getNumberHolidayWithoutWeekends(List<PublicHoliday> publicHolidayList) {
    int totalCount = _selectedToDate.difference(_selectedFromDate).inDays;
    var count;
    if(_selectedFromDate.weekday == 6 ||  _selectedFromDate.weekday == 7) {
      count = 0;
    } else {
      count = 1;
    }
    var tempDate = _selectedFromDate.add(Duration(days: 1, hours: 00, minutes: 00, seconds: 00, milliseconds: 00, microseconds: 00));

    for(int i = 0; i < totalCount; i++) {
      if(tempDate.weekday == 6 ||  tempDate.weekday == 7 || isPublicHoliday(tempDate, publicHolidayList)) {
        //escape it
      } else {
        count = count + 1;
      }
      tempDate = tempDate.add(Duration(days: 1, hours: 00, minutes: 00, seconds: 00, milliseconds: 00, microseconds: 00));
    }
    return count;
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

  Widget createDatePickerDependingOnLeaveDays(List<PublicHoliday> publicHolidayList) {
    if (isSingleDaySelected) {
      return createTextFormFieldForDate(_fromDate, _selectedFromDate, "On ", (DateTime date) {
        setState(() {
          _selectedFromDate = date;
          _selectedToDate = date;
        });
      }, publicHolidayList);
    } else {
      return Column(
        children: <Widget>[
          createTextFormFieldForDate(_fromDate,_selectedFromDate, "From ", (DateTime date) {
            setState(() {
              _selectedFromDate = date;
              _selectedToDate = _selectedFromDate.add(Duration(days: 1, hours: 00, minutes: 00, seconds: 00, milliseconds: 00, microseconds: 00));
              while(isPublicHoliday(_selectedToDate, widget.publicHolidayList) || isWeekend(_selectedToDate)) {
                _selectedToDate = _selectedToDate.add(Duration(days: 1, hours: 00, minutes: 00, seconds: 00, milliseconds: 00, microseconds: 00));
              }
            });
          }, publicHolidayList),
          createTextFormFieldForDate(_toDate,_selectedToDate, "To ", (DateTime date) {
            setState(() {
              _selectedToDate = date;
            });
          }, publicHolidayList),
        ],
      );
    }
  }

  Widget createTextFormFieldForDate(
      DateTime firstDate,
      DateTime selectedDate,
      String label,
      Function onSelect,
      List<PublicHoliday> publicHolidayList) {
    return Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 16.0),
        child: DateTimePicker(
          labelText: label,
          selectedDate: selectedDate,
          selectDate: onSelect,
          firstDate: firstDate,
          lastDate: DateTime(DateTime.now().year,  12, 31),
          selectableDayPredicate: (DateTime val) => val.weekday == 7 || val.weekday == 6 || isPublicHoliday(val, publicHolidayList) ? false : true,
        ));
  }

  void _showDialog(BuildContext context) {
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

  bool isPublicHoliday(DateTime val, List<PublicHoliday> publicHolidayList) {
    bool isSame = false;
    publicHolidayList.forEach((date) {
        if(val.isAtSameMomentAs(date.date)){
          isSame =  true;
        }
    });
    return isSame;
  }

  bool isWeekend(DateTime val) {
    return val.weekday == 7 || val.weekday == 6;
  }

}



class AppliedLeaveViewModel {
  final User user;

  AppliedLeaveViewModel({
    @required this.user,
  });

  static AppliedLeaveViewModel fromStore(Store<AppState> store) {
    return new AppliedLeaveViewModel(user: store.state.loginState.user);
  }
}

