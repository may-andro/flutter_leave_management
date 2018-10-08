import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/components/text_label_widget.dart';


class LabelWidget extends StatelessWidget {

  final String leftLabelTitle;
  final Color leftLabelBackGroundColor;
  final Color leftLabelTextColor;

  final String rightLabelTitle;
  final Color rightLabelBackGroundColor;
  final Color rightLabelTextColor;

  final VoidCallback leftLabelClick;
  final VoidCallback rightLabelClick;


  LabelWidget(this.leftLabelTitle,
      this.leftLabelBackGroundColor,
      this.leftLabelTextColor,
      this.rightLabelTitle,
      this.rightLabelBackGroundColor,
      this.rightLabelTextColor,
      this.leftLabelClick,
      this.rightLabelClick);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[

          TextLabelWidget(leftLabelTitle,
              leftLabelTextColor,
              leftLabelBackGroundColor,
              leftLabelClick),

          TextLabelWidget(rightLabelTitle,
              rightLabelTextColor,
              rightLabelBackGroundColor,
              rightLabelClick),
        ],
      ),
    );
  }
}
