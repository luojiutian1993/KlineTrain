import 'package:flutter/widgets.dart';

class ScreenUtils {
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
  static double statusBarHeight(BuildContext context) => MediaQuery.of(context).padding.top;
  static double bottomBarHeight(BuildContext context) => MediaQuery.of(context).padding.bottom;
  static double safeAreaHeight(BuildContext context) => screenHeight(context) - statusBarHeight(context) - bottomBarHeight(context);

  static bool isSmallScreen(BuildContext context) => screenWidth(context) < 375;
  static bool isMediumScreen(BuildContext context) => screenWidth(context) >= 375 && screenWidth(context) < 414;
  static bool isLargeScreen(BuildContext context) => screenWidth(context) >= 414;

  static double responsiveSize(BuildContext context, double small, double medium, double large) {
    if (isSmallScreen(context)) return small;
    if (isMediumScreen(context)) return medium;
    return large;
  }

  static double responsiveFontSize(BuildContext context, double baseSize) {
    double scaleFactor = screenWidth(context) / 375;
    return baseSize * scaleFactor;
  }

  static EdgeInsets responsivePadding(BuildContext context, double basePadding) {
    double scaleFactor = screenWidth(context) / 375;
    return EdgeInsets.all(basePadding * scaleFactor);
  }

  static BorderRadius responsiveBorderRadius(BuildContext context, double baseRadius) {
    double scaleFactor = screenWidth(context) / 375;
    return BorderRadius.circular(baseRadius * scaleFactor);
  }

  static double responsiveIconSize(BuildContext context, double baseSize) {
    double scaleFactor = screenWidth(context) / 375;
    return baseSize * scaleFactor;
  }
}