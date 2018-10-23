import 'package:flutter/material.dart';

class MenuListItemWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function() onTap;
  final Animation<double> animationReveal;

  MenuListItemWidget({
    this.title,
    this.isSelected,
    this.onTap,
    this.animationReveal
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: const Color(0x44000000),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        child: new Padding(
          padding: const EdgeInsets.only(left: 50.0, top: 15.0, bottom: 15.0),
          child: new Text(
            title,
            style: new TextStyle(
              color: isSelected ? Colors.red : Colors.white,
              fontSize: 25.0,
              fontFamily: 'bebas-neue',
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}

