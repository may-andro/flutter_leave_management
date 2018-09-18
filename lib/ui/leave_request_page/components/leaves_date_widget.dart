import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeavesDateWidget extends StatefulWidget {
  @override
  _LeavesDateWidgetState createState() => _LeavesDateWidgetState();
}

class _LeavesDateWidgetState extends State<LeavesDateWidget> {

  DateTime _fromDate = new DateTime.now();
  TimeOfDay _fromTime = const TimeOfDay(hour: 7, minute: 28);
  DateTime _toDate = new DateTime.now();
  TimeOfDay _toTime = const TimeOfDay(hour: 7, minute: 28);

  int radioValue = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: _createContent());
  }

  void handleRadioButtonValueChange(int value) {
    setState(() {
      radioValue = value;
    });
  }

  Widget _createContent() {
    return Container(
      child: Column(
        children: <Widget>[
          new Text(
            "Select the dates for your leaves",
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

          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              new Column(
                children: <Widget>[
                  new Radio<int>(
                    value: 0,
                    groupValue: radioValue,
                    onChanged: handleRadioButtonValueChange,
                    activeColor: Colors.brown,
                  ),
                  new Text("Single day",
                    style: TextStyle(
                        color: Colors.blueGrey
                    ),
                  ),
                ],
              ),

              new Padding(padding: new EdgeInsets.all(8.0)),

              new Column(
                children: <Widget>[
                  new Radio<int>(
                    value: 1,
                    groupValue: radioValue,
                    onChanged: handleRadioButtonValueChange,
                    activeColor: Colors.redAccent,
                  ),

                  new Text("Multiple day",
                    style: TextStyle(
                        color: Colors.blueGrey
                    ),
                  ),

                ],
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
          ),

          buildDateButtonDependingOnSelection(),

          new Padding(padding: new EdgeInsets.all(16.0)),

        ],
      ),
    );
  }

  Widget buildDateButtonDependingOnSelection() {
    if (radioValue == 1) {
      return Container(
        child: Column(
          children: <Widget>[
            new _DateTimePicker(
              labelText: 'From',
              selectedDate: _fromDate,
              selectDate: (DateTime date) {
                setState(() {
                  _fromDate = date;
                });
              },
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
            ),

            new _DateTimePicker(
              labelText: 'To',
              selectedDate: _toDate,
              selectDate: (DateTime date) {
                setState(() {
                  _toDate = date;
                });
              },
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
            ),

            new _DateTimePicker(
              labelText: 'Select date',
              selectedDate: _toDate,
              selectDate: (DateTime date) {
                setState(() {
                  _toDate = date;
                });
              },
            ),
          ],
        ),
      );
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
        lastDate: new DateTime(2101)
    );
    if (picked != null && picked != selectedDate)
      selectDate(picked);
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
            onPressed: () { _selectDate(context); },
          ),
        ),
        const SizedBox(width: 12.0),
      ],
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed }) : super(key: key);

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
                color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.white70
            ),
          ],
        ),
      ),
    );
  }
}