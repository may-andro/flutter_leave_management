import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/model/UserModel.dart';


class UserItemWidget extends StatefulWidget {
  const UserItemWidget({Key key, this.user}): super(key: key);

  final User user;

  @override
  _UserItemWidgetState createState() => _UserItemWidgetState();
}

class _UserItemWidgetState extends State<UserItemWidget> {

  var SelectedState = false;
  var mycolor=Colors.white;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      child:  Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, children: <Widget>[
          new ListTile(
              selected: SelectedState,
              leading: const Icon(Icons.info),
              title: new Text("${widget.user.name}"),
              subtitle: new Text("${widget.user.role.title}"),
              trailing: new Text("${widget.user.mmid}"),
              onLongPress: select // what should I put here,
          )
          ],
        ),
      ),
    )


    ;
  }

  void select() {
    setState(() {
      if (SelectedState) {
        mycolor=Colors.white;
        SelectedState = false;
      } else {
        mycolor=Colors.grey[300];
        SelectedState = true;
      }
    });
  }
}
