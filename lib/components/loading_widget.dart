import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/utility/text_theme.dart';

class LoadingWidget extends StatelessWidget {
  final String message;

  LoadingWidget(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "$message",
                style: TextStyles.loadingProgressStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
