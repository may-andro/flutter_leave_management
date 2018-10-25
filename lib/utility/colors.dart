import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/utility/constants.dart';

const colorPrimary = Colors.deepPurple;

const colorButtonBackground = Colors.black;
const colorBackground = Colors.white;
const colorCardBackground = Colors.blueGrey;

const colorError = Colors.deepOrange;

const colorHeadingText = Colors.black87;
const colorSubHeading = Colors.deepPurple;


const colorCaptionText = Colors.white70;

const colorLoadingProgressText = Colors.blueGrey;

const colorTitleText = Colors.white70;
const colorSubtitleText = Colors.white70;

const colorDrawerTitleText= Colors.deepPurple;
const colorDrawerSubtitleText = Colors.deepPurple;

const colorLabelSelectedText= Colors.deepPurple;
const colorLabelUnselectedText= Colors.deepPurple;

const colorChipText= Colors.deepPurple;

const colorButtonText= Colors.deepPurple;

/*
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
*/
//final ThemeData appTheme = _getAppTheme();

ThemeData _getAppTheme(int themeId) {
  final ThemeData base = ThemeData.light();

  ThemeData appTheme;
  switch(themeId) {
    case SELECTED_THEME_PURPLE: appTheme =  base.copyWith(
      accentColor: Colors.blueGrey,
      primaryColor: Colors.deepPurple,
      bottomAppBarColor: Colors.deepPurple,
      primaryColorLight: Colors.purpleAccent,
      primaryColorDark: Colors.purple,
      buttonColor: Colors.black,
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.white70,
      cardColor: Colors.blueGrey,
      textSelectionColor: Colors.deepPurple,
      errorColor: Colors.redAccent,
      cursorColor: Colors.blueGrey,
      canvasColor: Colors.white,
      dialogBackgroundColor: Colors.white,
      indicatorColor: Colors.blueGrey,
      hintColor: Colors.blueGrey,
    );
    break;

    case SELECTED_THEME_BLUE: appTheme = base.copyWith(
      accentColor: Colors.blueGrey,
      primaryColor: Colors.blue,
      bottomAppBarColor: Colors.blue,
      primaryColorLight: Colors.blueAccent,
      primaryColorDark: Colors.blue,
      buttonColor: Colors.pink,
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.white70,
      cardColor: Colors.blueGrey,
      textSelectionColor: Colors.blueGrey,
      errorColor: Colors.redAccent,
      cursorColor: Colors.black,
      canvasColor: Colors.white,
      dialogBackgroundColor: Colors.white,
      indicatorColor: Colors.black,
      hintColor: Colors.blueGrey,
    );
    break;

    case SELECTED_THEME_RED: appTheme = base.copyWith(
      accentColor: Colors.black87,
      primaryColor: Colors.red,
      bottomAppBarColor: Colors.red,
      primaryColorLight: Colors.redAccent,
      primaryColorDark: Colors.red,
      buttonColor: Colors.black,
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.white70,
      cardColor: Colors.blueGrey,
      textSelectionColor: Colors.deepPurple,
      errorColor: Colors.deepOrange,
      cursorColor: Colors.black,
      canvasColor: Colors.white,
      dialogBackgroundColor: Colors.white,
      indicatorColor: Colors.black,
      hintColor: Colors.blueGrey,
    );
    break;

    case SELECTED_THEME_YELLOW: appTheme = base.copyWith(
      accentColor: Colors.black,
      primaryColor: Colors.amber,
      bottomAppBarColor: Colors.amber,
      primaryColorLight: Colors.amberAccent,
      primaryColorDark: Colors.amber,
      buttonColor: Colors.black,
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.white70,
      cardColor: Colors.blueGrey,
      textSelectionColor: Colors.blueGrey,
      errorColor: Colors.red,
      cursorColor: Colors.black,
      canvasColor: Colors.white,
      dialogBackgroundColor: Colors.white,
      indicatorColor: Colors.black,
      hintColor: Colors.blueGrey,
    );
    break;

    default: appTheme = base.copyWith(
      accentColor: Colors.blueGrey,
      primaryColor: Colors.deepPurple,
      bottomAppBarColor: Colors.deepPurple,
      primaryColorLight: Colors.purpleAccent,
      primaryColorDark: Colors.purple,
      buttonColor: Colors.black,
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.white70,
      cardColor: Colors.blueGrey,
      textSelectionColor: Colors.deepPurple,
      errorColor: Colors.redAccent,
      cursorColor: Colors.blueGrey,
      canvasColor: Colors.white,
      dialogBackgroundColor: Colors.white,
      indicatorColor: Colors.blueGrey,
      hintColor: Colors.blueGrey,
    );
    break;
  }

  return appTheme;
}



