import 'package:flutter/material.dart';

class TextLabelWidget extends StatelessWidget {

  final VoidCallback onTap;
  final String label;
  final Color textColor;
  final Color backgroundColor;

  TextLabelWidget(this.label, this.textColor, this.backgroundColor, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Padding(
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  letterSpacing: 1.2,
                  fontFamily: 'Poppins',
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          padding: EdgeInsets.all(8.0),
        ),
        color: backgroundColor,
      ),
    );
  }
}
