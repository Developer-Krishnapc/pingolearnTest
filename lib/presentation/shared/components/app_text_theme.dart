import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/config/app_color.dart';

class AppTextTheme {
  AppTextTheme._();

  static final base = GoogleFonts.poppins(
    color: AppColor.black,
  );

  static final label = base.copyWith(
    fontSize: 9,
    fontWeight: FontWeight.normal,
  );

  static final label10 = base.copyWith(
    fontSize: 10,
  );

  static final label11 = base.copyWith(
    fontSize: 11,
  );

  static final label12 = base.copyWith(
    fontSize: 12,
  );

  static final label13 = base.copyWith(
    fontSize: 13,
  );

  static final label14 = base.copyWith(
    fontSize: 14,
  );

  static final semiBold = base.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static final semiBold12 = semiBold.copyWith(
    fontSize: 12,
  );

  static final semiBold14 = semiBold.copyWith(
    fontSize: 14,
  );

  static final semiBold16 = semiBold.copyWith(
    fontSize: 16,
  );

  static final semiBold18 = semiBold.copyWith(
    fontSize: 18,
  );

  static final semiBold20 = semiBold.copyWith(
    fontSize: 20,
  );

  static final label16 = base.copyWith(fontSize: 16);

  static final medium = base.copyWith(
    fontWeight: FontWeight.w500,
  );

  static final medium12 = medium.copyWith(
    fontSize: 12,
  );

  static final medium10 = medium.copyWith(
    fontSize: 10,
  );

  static final medium14 = medium.copyWith(
    fontSize: 14,
  );

  static final semiBold25 = semiBold.copyWith(fontSize: 25);

  static final semiBold30 = semiBold.copyWith(fontSize: 30);
}
