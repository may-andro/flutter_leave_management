import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/text_label_widget.dart';
import 'package:flutter_mm_hrmangement/ui/signin_page/components/reveal_progress_button_painter.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';
import 'package:intl/intl.dart';

class AddPublicHolidayPage extends StatefulWidget {
  @override
  _AddPublicHolidayPageState createState() => _AddPublicHolidayPageState();
}

class _AddPublicHolidayPageState extends State<AddPublicHolidayPage>
    with TickerProviderStateMixin {
  //Animation
  Animation<double> _animationReval, _animationShrink;
  AnimationController _controllerReveal, _controllerShrink;

  //Keys
  final formKey = GlobalKey<FormState>();
  final _globalKey = GlobalKey();

  String _title;
  DateTime _date = DateTime.now();

  double _fraction = 0.0;
  var _isPressed = false, _animatingReveal = false;
  int _state = 0;
  double _width = double.infinity;

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
  }

  void reset() {
    _width = double.infinity;
    _animatingReveal = false;
    _state = 0;
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
            "Add Public Holiday",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[

                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  TextLabelWidget('Holiday Name', Colors.white, Colors.deepPurple, () {}),
                                  TextLabelWidget('Dummy', Colors.white, Colors.white, () {}),
                                ],
                              ),

                              createTextFormFieldName(),

                              Padding(
                                padding: const EdgeInsets.all(20.0),
                              ),

                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  TextLabelWidget('Holiday Date', Colors.white, Colors.deepPurple, () {}),
                                  TextLabelWidget('Dummy', Colors.white, Colors.white, () {}),
                                ],
                              ),

                              createTextFormFieldDate(),

                              Padding(
                                padding: const EdgeInsets.all(20.0),
                              ),

                              Padding(
                                padding: EdgeInsets.all(24.0),
                                child: Center(
                                  child: CustomPaint(
                                    painter: RevealProgressButtonPainter(
                                        _fraction, MediaQuery.of(context).size),
                                    child: Container(
                                      height: 48.0,
                                      width: _width,
                                      child: RaisedButton(
                                        elevation: calculateElevation(),
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(30.0)),
                                        padding: EdgeInsets.all(0.0),
                                        color: _state == 2
                                            ? Colors.deepPurple
                                            : Colors.black,
                                        child: buildButtonChild(),
                                        onPressed: () {
                                          //do the login
                                          if (formKey.currentState.validate()) {
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
                        )),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  Widget createScreenTitleText() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: new Text(
        "Add new public holiday",
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
        validator: (val) => val.length == 0 ? 'title  is empty' : null,
        onSaved: (String val) {
          _title = val;
        },
        keyboardType: TextInputType.text,
        decoration: new InputDecoration(
          labelText: 'Title',
          border: OutlineInputBorder(),
          hintStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
        ),
      ),
    );
  }

  Widget createTextFormFieldDate() {
    return Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 16.0),
        child: _DateTimePicker(
          labelText: 'Select date',
          selectedDate: _date,
          selectDate: (DateTime date) {
            setState(() {
              _date = date;
            });
          },
        ));
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

    Firestore.instance
        .collection('companyLeaveCollection')
        .document('$_title')
        .setData({
      "title": "$_title",
      "date": _date,
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
          Navigation.navigateTo(context, 'public_holiday_management',  replace: true,
              transition: TransitionType.fadeIn);
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

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectDate,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: new DateTime(2015, 8),
        lastDate: new DateTime(2101));
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Expanded(
          flex: 4,
          child: new _InputDropdown(
            labelText: labelText,
            valueText: new DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
      ],
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      onTap: onPressed,
      child: new InputDecorator(
        decoration: new InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        baseStyle: valueStyle,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(valueText, style: valueStyle),
            new Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}
