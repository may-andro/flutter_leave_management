import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/utility/navigation.dart';

class ExtendedFabWidget extends StatelessWidget {

  final String label;
  final Function onPress;

  ExtendedFabWidget(this.label, this.onPress);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1.0,
      child: FloatingActionButton.extended(
        elevation: 4.0,
        clipBehavior: Clip.antiAlias,
        icon: const Icon(Icons.add),
        label: Text(label),
        backgroundColor: Colors.black,
        onPressed: onPress,
        heroTag: null,
      ),
    );
  }
}
