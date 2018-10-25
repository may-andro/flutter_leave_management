import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/app_button_widget.dart';
import 'package:flutter_mm_hrmangement/components/date_time_picker_widget.dart';
import 'package:flutter_mm_hrmangement/components/text_label_widget.dart';
import 'package:flutter_mm_hrmangement/model/PublicHoliday.dart';
import 'package:flutter_mm_hrmangement/redux/public_holiday/public_holiday_action.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class AddPublicHolidayWidget extends StatefulWidget {
  @override
  _AddPublicHolidayWidgetState createState() => _AddPublicHolidayWidgetState();
}

class _AddPublicHolidayWidgetState extends State<AddPublicHolidayWidget> {
  final formKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector(
        converter: (Store<AppState> store) => AddPublicHolidayLeaveViewModel.fromStore(store),
        builder: (BuildContext context, AddPublicHolidayLeaveViewModel viewModel) {
          return Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextLabelWidget('Holiday Name', Colors.white, Colors.deepPurple, () {}),
                        TextLabelWidget('Dummy', Colors.white, Colors.white, () {}),
                      ],
                    ),
                    createTextFormFieldName(),
                    Padding(padding: const EdgeInsets.all(20.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextLabelWidget(
                            'Holiday Date', Colors.white, Colors.deepPurple, () {}),
                        TextLabelWidget('Dummy', Colors.white, Colors.white, () {}),
                      ],
                    ),
                    createTextFormFieldDate(viewModel.publicHolidayList),
                    Padding(padding: const EdgeInsets.all(20.0)),
                    AppButtonWidget(
                            () {
                          var publicHoliday = PublicHoliday(
                            title: textEditingController.text,
                            date: _date,
                          );
                          var store = StoreProvider.of<AppState>(context);
                          store.dispatch(AddPublicHolidayAction(publicHoliday: publicHoliday));
                          Navigator.pop(context);
                        }, 'Add'
                    )
                  ],
                ),
              ) // We'll build this out in the next steps!
          );
        }
    );
  }

  Widget createTextFormFieldName() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
      child: TextFormField(
        controller: textEditingController,
        validator: (val) => val.length == 0 ? 'title  is empty' : null,
        onSaved: (String val) {},
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          labelText: 'Title',
          border: OutlineInputBorder(),
          hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
        ),
      ),
    );
  }

  Widget createTextFormFieldDate(List<PublicHoliday> publicHolidayList) {
    print('_AddPublicHolidayWidgetState.createTextFormFieldDate ${publicHolidayList.length}');
    return Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 16.0),
        child: DateTimePicker(
          labelText: 'Select date',
          selectedDate: _date,
          lastDate: DateTime(DateTime.now().year, 12, 31),
          firstDate: DateTime(DateTime.now().year, 1, 1),
          selectableDayPredicate: (DateTime val) => isPublicHoliday(val, publicHolidayList) ? false : true,
          selectDate: (DateTime date) {
            setState(() {
              _date = date;
            });
          },
        )
    );
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
}


class AddPublicHolidayLeaveViewModel {
  final List<PublicHoliday> publicHolidayList;

  AddPublicHolidayLeaveViewModel({
    @required this.publicHolidayList,
  });

  static AddPublicHolidayLeaveViewModel fromStore(Store<AppState> store) {
    return AddPublicHolidayLeaveViewModel(publicHolidayList: store.state.publicHolidayState.publicHolidayList);
  }
}
