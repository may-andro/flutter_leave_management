import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/input_dropdown_widget.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatelessWidget {
  const DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectDate,
    this.firstDate,
    this.lastDate,
    this.selectableDayPredicate
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> selectDate;
  final SelectableDayPredicate selectableDayPredicate;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstDate,
        lastDate: lastDate,
        selectableDayPredicate: selectableDayPredicate
    );
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.subhead;
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Expanded(
          flex: 4,
          child: InputDropdown(
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
