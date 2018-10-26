import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/utility/text_theme.dart';

class ListItemWidget extends StatelessWidget {
  @required final dynamic objectType;
  @required final String title;
  @required final String subtitle;
  @required final Widget leadingWidget;
  @required final Widget trailingWidget;
  @required final Function() clickCallback;
  @required final Function(dynamic) dismissCallback;
  final Animation<double> animationReveal;
  final bool isDraggable;
  final isSelected;

  ListItemWidget(this.objectType,this.title,
      this.subtitle, this.leadingWidget,
      this.trailingWidget, this.clickCallback, this.animationReveal, this.dismissCallback, this.isDraggable, this.isSelected);

  BoxDecoration _buildShadowAndRoundedCorners(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(4.0),
      boxShadow: <BoxShadow>[
        BoxShadow(
          spreadRadius: 0.0,
          blurRadius: 0.0,
          color: Colors.blueGrey,
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    if(isDraggable) {
      return Dismissible(
        direction: DismissDirection.endToStart,
        background: LeaveBehindView(),
        key: Key(title),
        dismissThresholds: _dismissThresholds(),
        onDismissed: (direction) {
          dismissCallback(objectType);
        },
        child: createChild(context),
      );
    } else {
      return createChild(context);
    }
  }


  Widget createChild(BuildContext context){
    return Opacity(
      opacity: animationReveal != null ? animationReveal.value : 1.0,
      child: Container(
        padding: const EdgeInsets.all(2.0),
        margin: EdgeInsets.symmetric(
            horizontal: ( animationReveal != null ? animationReveal.value * 12.0 : 12.0),
            vertical: animationReveal != null ? animationReveal.value * 4.0 : 4.0),
        decoration: _buildShadowAndRoundedCorners(context),
        child: ListTile(
          title: Text(
            title,
            style: TextStyles.titleStyle,
          ),
          subtitle: new Padding(
            padding: new EdgeInsets.only(top: 5.0),
            child: new Text(
              subtitle,
              style: TextStyles.captionStyle,
            ),
          ),
          leading: leadingWidget,
          trailing: trailingWidget,
          onTap: clickCallback,
          selected: isSelected != null ? isSelected : false,
        ),
      ),
    );
  }
}


Map<DismissDirection, double> _dismissThresholds() {
  Map<DismissDirection, double> map = new Map<DismissDirection, double>();
  map.putIfAbsent(DismissDirection.horizontal, () => 0.3);
  return map;
}

class LeaveBehindView extends StatelessWidget {
  LeaveBehindView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.all(16.0),
      child: new Row (
        children: <Widget>[
          new Expanded(
            child: new Text(''),
          ),
          new Icon(Icons.delete),
        ],
      ),
    );
  }

}
