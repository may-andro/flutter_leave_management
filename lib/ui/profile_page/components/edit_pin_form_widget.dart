import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/app_bar_widget.dart';
import 'package:flutter_mm_hrmangement/components/app_button_widget.dart';
import 'package:flutter_mm_hrmangement/components/text_label_widget.dart';
import 'package:flutter_mm_hrmangement/redux/states/app_state.dart';
import 'package:flutter_mm_hrmangement/ui/public_holiday_management/components/add_public_holiday_form_widget.dart';
import 'package:flutter_redux/flutter_redux.dart';


class EditPinFormWidget extends StatefulWidget {
  @override
  _EditPinFormWidgetState createState() => _EditPinFormWidgetState();
}

class _EditPinFormWidgetState extends State<EditPinFormWidget> {
  final formKey = GlobalKey<FormState>();
  String _pin;

  @override
  Widget build(BuildContext context) {
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
                  TextLabelWidget(
                      'New Pin', Colors.white, Colors.deepPurple, () {}),
                  TextLabelWidget('Dummy', Colors.white, Colors.white, () {}),
                ],
              ),
              createTextFormFieldName(),
              Padding(
                padding: const EdgeInsets.all(20.0),
              ),
              AppButtonWidget(
                      () {
                    if (formKey.currentState.validate()) {
                      var store = StoreProvider.of<AppState>(context);
                      //store.dispatch(AddPublicHolidayAction(publicHoliday: publicHoliday));
                      Navigator.pop(context);
                    }
                  }, 'Save'
              )
            ],
          ),
        ) // We'll build this out in the next steps!
    );
  }

  Widget createTextFormFieldName() {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 16.0, right: 16.0),
      child: TextFormField(
        validator: (val) => val.length == 0 ? 'pin  is empty' : null,
        onSaved: (String val) {
          _pin = val;
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
}
