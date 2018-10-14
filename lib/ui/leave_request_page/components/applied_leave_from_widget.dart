import 'dart:async';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/app_button_widget.dart';
import 'package:flutter_mm_hrmangement/components/date_time_picker_widget.dart';
import 'package:flutter_mm_hrmangement/components/loading_widget.dart';
import 'package:flutter_mm_hrmangement/model/LeaveModel.dart';
import 'package:flutter_mm_hrmangement/model/ProjectModel.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';
import 'package:flutter_mm_hrmangement/redux/applied_leave_redux/applied_leave_action.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/leave_request_page/components/label_widget.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class AppliedLeaveFormWidget extends StatefulWidget {
  @override
  _AppliedLeaveFormWidgetState createState() => _AppliedLeaveFormWidgetState();
}

class _AppliedLeaveFormWidgetState extends State<AppliedLeaveFormWidget> {

  final TextEditingController textEditingController = TextEditingController();

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  String _typeOfLeave;
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
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
      print('projectUserMap projectCollection containg user: ${data.documents.length}');
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
          print('_AppliedLeaveFormWidgetState._fetchData ${snapshot['token']} ${projectUser.mmid}');
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

                          AppButtonWidget(
                                  () {
                                    leaveId = '${viewModel.user.mmid}_${DateTime.now()}';
                                    Leave leave = Leave(
                                        mmid: viewModel.user.mmid,
                                        typeOfLeave: _typeOfLeave,
                                        startDate: _fromDate,
                                        endDate: _toDate,
                                        isSingleDayLeave: isSingleDaySelected,
                                        numberOfDays: _fromDate.compareTo(_toDate),
                                        status: 0,
                                        message: getLeaveMessage(_toDate.compareTo(_fromDate), _toDate, _fromDate, textEditingController.text, _typeOfLeave, viewModel.user.name)
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

