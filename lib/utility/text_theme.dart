import 'package:flutter/material.dart';
import 'package:flutter_mm_hrmangement/utility/colors.dart';

class TextStyles {

  const TextStyles();

  static const TextStyle appBarTitle = const TextStyle(
      color: colorPrimary,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      fontSize: 36.0
  );

  static const TextStyle headingStyle = const TextStyle(
      color: colorHeadingText,
      fontFamily: 'Rubik',
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      fontStyle: FontStyle.normal,
      fontSize: 35.0,
  );

  static const TextStyle titleStyle = const TextStyle(
      color: colorTitleText,
      fontFamily: 'Rubik',
      fontWeight: FontWeight.w600,
      fontSize: 18.0
  );

  static const TextStyle subtitleStyle = const TextStyle(
      color: colorSubtitleText,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      fontSize: 16.0
  );

  static const TextStyle captionStyle = const TextStyle(
      color: colorCaptionText,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
      fontSize: 14.0
  );

  static const TextStyle loadingProgressStyle = const TextStyle(
      color: colorLoadingProgressText,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
      fontSize: 14.0
  );
}