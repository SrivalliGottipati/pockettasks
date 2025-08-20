import 'package:flutter/material.dart';

class ScreenUtils {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double pixelRatio;
  static late double statusBarHeight;
  static late double bottomBarHeight;
  static late double textScaleFactor;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    pixelRatio = _mediaQueryData.devicePixelRatio;
    statusBarHeight = _mediaQueryData.padding.top;
    bottomBarHeight = _mediaQueryData.padding.bottom;
    textScaleFactor = _mediaQueryData.textScaleFactor;
  }

  // Screen size breakpoints
  static bool get isPhone => screenWidth < 600;
  static bool get isTablet => screenWidth >= 600 && screenWidth < 900;
  static bool get isDesktop => screenWidth >= 900;
  static bool get isLandscape => screenWidth > screenHeight;

  // Responsive sizing
  static double get responsivePadding => isPhone ? 20.0 : isTablet ? 32.0 : 40.0;
  static double get responsiveProgressSize => isPhone ? 76.0 : isTablet ? 100.0 : 120.0;
  static double get responsiveIconSize => isPhone ? 28.0 : isTablet ? 32.0 : 36.0;
  static double get responsiveButtonPadding => isPhone ? 18.0 : isTablet ? 22.0 : 26.0;
  static double get responsiveTextSize => isPhone ? 18.0 : isTablet ? 20.0 : 22.0;
  static double get responsiveTitleSize => isPhone ? 24.0 : isTablet ? 28.0 : 32.0;
  static double get responsiveSpacing => isPhone ? 12.0 : isTablet ? 16.0 : 20.0;
  static double get responsiveChipSpacing => isPhone ? 12.0 : isTablet ? 16.0 : 20.0;
  
  // Responsive margins
  static EdgeInsets get responsiveMargins => EdgeInsets.symmetric(
    horizontal: responsivePadding,
    vertical: responsivePadding * 0.5,
  );
  
  // Responsive list padding
  static EdgeInsets get responsiveListPadding => EdgeInsets.symmetric(
    horizontal: responsivePadding * 0.5,
    vertical: responsiveSpacing * 0.5,
  );
}

// Extension for easy access
extension ResponsiveExtension on BuildContext {
  bool get isPhone => ScreenUtils.isPhone;
  bool get isTablet => ScreenUtils.isTablet;
  bool get isDesktop => ScreenUtils.isDesktop;
  bool get isLandscape => ScreenUtils.isLandscape;
  
  double get responsivePadding => ScreenUtils.responsivePadding;
  double get responsiveProgressSize => ScreenUtils.responsiveProgressSize;
  double get responsiveIconSize => ScreenUtils.responsiveIconSize;
  double get responsiveButtonPadding => ScreenUtils.responsiveButtonPadding;
  double get responsiveTextSize => ScreenUtils.responsiveTextSize;
  double get responsiveTitleSize => ScreenUtils.responsiveTitleSize;
  double get responsiveSpacing => ScreenUtils.responsiveSpacing;
  double get responsiveChipSpacing => ScreenUtils.responsiveChipSpacing;
}
