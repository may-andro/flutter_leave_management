import 'package:flutter/material.dart';

const colorPrimary = Colors.deepPurple;

const colorButtonBackground = Colors.black;
const colorBackground = Colors.white;
const colorCardBackground = Colors.blueGrey;

const colorError = Colors.deepOrange;

const colorHeadingText = Colors.black87;
const colorSubHeading = Colors.deepPurple;


const colorCaptionText = Colors.white70;

const colorTitleText = Colors.white70;
const colorSubtitleText = Colors.white70;

const colorDrawerTitleText= Colors.deepPurple;
const colorDrawerSubtitleText = Colors.deepPurple;

const colorLabelSelectedText= Colors.deepPurple;
const colorLabelUnselectedText= Colors.deepPurple;

const colorChipText= Colors.deepPurple;

const colorButtonText= Colors.deepPurple;

final ThemeData appTheme = _buildAppTheme();

ThemeData _buildAppTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    accentColor: Colors.blueGrey,
    primaryColor: colorPrimary,
    bottomAppBarColor: Colors.deepPurple,
    primaryColorLight: Colors.purpleAccent,
    primaryColorDark: Colors.purple,
    buttonColor: colorButtonBackground,
    scaffoldBackgroundColor: colorBackground,
    backgroundColor: colorBackground,
    cardColor: colorCardBackground,
    textSelectionColor: Colors.deepPurple,
    errorColor: colorError,
    cursorColor: Colors.black,
    canvasColor: Colors.white,
    dialogBackgroundColor: Colors.white,
    indicatorColor: Colors.black,
    hintColor: Colors.blueGrey,
  );
}



