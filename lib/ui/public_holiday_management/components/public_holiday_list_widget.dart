import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/list_item_card_widget.dart';
import 'package:flutter_mm_hrmangement/model/PublicHoliday.dart';
import 'package:intl/intl.dart';

class PublicHolidayList extends StatefulWidget {

  final List<PublicHoliday> publicHolidayList;
  final Function(PublicHoliday) deleteItem;
  final Animation<double> _animationReveal;
  final bool isDragable;

  PublicHolidayList(this.publicHolidayList, this.deleteItem, this._animationReveal, this.isDragable);

  @override
  _PublicHolidayListState createState() => _PublicHolidayListState();
}

class _PublicHolidayListState extends State<PublicHolidayList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.publicHolidayList.length,
      padding: const EdgeInsets.all(0.0),
      shrinkWrap: true,
      primary: true,
      itemBuilder: (context, index) {
        var publicHoliday = widget.publicHolidayList[index];
        return ListItemWidget(publicHoliday,
            publicHoliday.title,
            "${DateFormat.yMMMMd().format(DateTime.fromMicrosecondsSinceEpoch(publicHoliday.date.millisecondsSinceEpoch * 1000))}",
            CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "${publicHoliday.title.substring(0, 1)}",
                  style: TextStyle(color: Colors.blueGrey),
                )),
            CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: Text(
                  "",
                  style: TextStyle(color: Colors.blueGrey),
                )), () {},
            widget._animationReveal, (value) {
              widget.publicHolidayList.remove( value as PublicHoliday);
              widget.deleteItem(value as PublicHoliday);
            }, widget.isDragable, false);
      },
    );
  }
}
