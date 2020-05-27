import 'package:dispatch_app_client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final labelTextStyle = GoogleFonts.poppins(
    fontSize: 12,
    color: Constant.primaryColorDark,
  );

  static final greenlabelTextStyle = GoogleFonts.poppins(
    fontSize: 12,
    color: Colors.green,
  );

  static final redlabelTextStyle = GoogleFonts.poppins(
    fontSize: 12,
    color: Colors.red,
  );

  static final smallgreyTextStyle = GoogleFonts.poppins(
    fontSize: 10,
    color: Colors.grey[700],
  );

  static final smallprimaryColorTextStyle = GoogleFonts.poppins(
    fontSize: 10,
    color: Constant.primaryColorDark,
  );

  static final greylabelTextStyle = GoogleFonts.poppins(
    fontSize: 12,
    color: Colors.red,
  );

  static final appTextStyle =
      GoogleFonts.poppins(fontSize: 14, color: Constant.primaryColorDark);

  static final appLightTextStyle =
      GoogleFonts.poppins(fontSize: 14, color: Constant.primaryColorLight);

  static final appLightHeaderTextStyle =
      GoogleFonts.poppins(fontSize: 18, color: Constant.primaryColorLight);

  static final appDarkHeaderTextStyle = GoogleFonts.poppins(
      fontSize: 18,
      color: Constant.primaryColorDark,
      fontWeight: FontWeight.w600);
}
