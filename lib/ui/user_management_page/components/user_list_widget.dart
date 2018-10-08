import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/list_item_card_widget.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';

class UserListWidget extends StatefulWidget {

  final List<User> userList;
  final Function(User) deleteItem;
  final Animation<double> _animationReveal;
  final bool isDragable;

  UserListWidget(this.userList, this.deleteItem, this._animationReveal, this.isDragable);

  @override
  _PublicHolidayListState createState() => _PublicHolidayListState();
}

class _PublicHolidayListState extends State<UserListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.userList.length,
      padding: const EdgeInsets.all(0.0),
      shrinkWrap: true,
      primary: true,
      itemBuilder: (context, index) {
        var user = widget.userList[index];
        return ListItemWidget(user,
            user.name,
            user.mmid,
            CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "${user.role.shortcut}",
                  style: TextStyle(color: Colors.blueGrey),
                )),
            CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: Text(
                  "",
                  style: TextStyle(color: Colors.blueGrey),
                )), () {},
            widget._animationReveal, (value) {
              widget.userList.remove( value as User);
              widget.deleteItem(value as User);
            }, widget.isDragable, false);
      },
    );
  }
}
