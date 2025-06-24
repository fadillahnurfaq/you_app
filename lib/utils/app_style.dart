import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  AppTextStyle._();
  static FontWeight light = FontWeight.w300;
  static FontWeight regular = FontWeight.w400;
  static FontWeight medium = FontWeight.w500;
  static FontWeight semiBold = FontWeight.w600;
  static FontWeight bold = FontWeight.w700;
  static FontWeight extraBold = FontWeight.w800;
  static FontWeight black = FontWeight.w900;

  static final String? _inter = GoogleFonts.inter().fontFamily;

  static TextStyle h1 = TextStyle(
    decoration: TextDecoration.none,
    color: AppColors.white,
    fontSize: 20,
    fontWeight: bold,
    height: 1.2,
    fontFamily: _inter,
  );
  static TextStyle h2 = TextStyle(
    decoration: TextDecoration.none,
    color: AppColors.white,
    fontSize: 18,
    fontWeight: bold,
    height: 1.2,
    fontFamily: _inter,
  );
  static TextStyle h3 = TextStyle(
    decoration: TextDecoration.none,
    color: AppColors.white,
    fontSize: 16,
    fontWeight: bold,
    height: 1.2,
    fontFamily: _inter,
  );
  static TextStyle h4 = TextStyle(
    decoration: TextDecoration.none,
    color: AppColors.white,
    fontSize: 14,
    fontWeight: bold,
    height: 1.2,
    fontFamily: _inter,
  );

  static TextStyle regularStyle = TextStyle(
    decoration: TextDecoration.none,
    color: AppColors.white,
    fontSize: 12,
    fontWeight: regular,
    height: 1.2,
    fontFamily: _inter,
  );
}

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1F4247);
  static const Color black = Color(0xFF09141A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Colors.grey;
  static const Color red = Color(0xffFF0032);
  static const Color card = Color(0xFF162329);
  static const Color cardDark = Color(0xFF0E191F);

  static const List<Color> listGold = [
    Color(0xFF94783E),
    Color(0xFFF3EDA6),
    Color(0xFFF8FAE5),
    Color(0xFFFFE2BE),
    Color(0xFFD5BE88),
    Color(0xFFF8FAE5),
    Color(0xFFD5BE88),
  ];

  static const List<Color> listdarkBlue = [
    Color(0xFFABFFFD),
    Color(0xFF4599DB),
    Color(0xFFAADAFF),
  ];

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF62CDCB), Color(0xFF4599DB)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const RadialGradient darkRadialGradient = RadialGradient(
    colors: [Color(0xFF1F4247), Color(0xFF0D1D23), Color(0xFF09141A)],
    center: Alignment.topRight, // pusat terang sedikit di atas
    radius: 1.6,
    stops: [0.0, 0.5, 1.0],
  );
}

class AppPadding {
  static const EdgeInsets horizonal = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets normal = EdgeInsets.all(16.0);
}
