import 'package:flutter/material.dart';

ThemeData mainTheme() {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
      appBarTheme:
          AppBarTheme(iconTheme: IconThemeData(color: Colors.black), color: Colors.grey[200]),
      textTheme: mainTextTheme(base.textTheme),
      primaryColor: Colors.grey[200],
      indicatorColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      iconTheme: IconThemeData(
        color: Colors.black,
        size: 20.0,
      ),
      backgroundColor: Colors.black,
      tabBarTheme: base.tabBarTheme.copyWith(
        labelColor: Color(0xffce107c),
        unselectedLabelColor: Colors.grey,
      ));
}

TextTheme mainTextTheme(TextTheme base) {
  return base.copyWith(
    headline1: base.headline1.copyWith(
      letterSpacing: -1.5,
      fontFamily: 'Assistant-Light',
      fontSize: 96.0,
      color: Colors.black,
    ),
    headline2: base.headline2.copyWith(
      letterSpacing: -0.5,
      fontFamily: 'Assistant-Light',
      fontSize: 60.0,
      color: Colors.grey[700],
    ),
    headline3: base.headline3.copyWith(
      letterSpacing: 0.0,
      fontFamily: 'Assistant-Regular',
      fontSize: 48.0,
      color: Colors.black,
    ),
    headline4: base.headline4.copyWith(
      letterSpacing: 0.25,
      fontFamily: 'Assistant-Regular',
      fontSize: 34.0,
      color: Colors.black,
    ),
    headline5: base.headline5.copyWith(
      letterSpacing: 0,
      fontFamily: 'Assistant-Bold',
      fontSize: 18.0,
      color: Colors.grey[600],
    ),
    headline6: base.headline6.copyWith(
      letterSpacing: 0.15,
      fontFamily: 'Assistant-SemiBold',
      fontSize: 18.0,
      color: Colors.black,
    ),
    subtitle1: base.subtitle1.copyWith(
      letterSpacing: 0.15,
      fontFamily: 'Assistant-Regular',
      fontSize: 16.0,
      color: Colors.grey,
    ),
    subtitle2: base.subtitle2.copyWith(
      letterSpacing: 0.1,
      fontFamily: 'Assistant-Bold',
      fontSize: 14.0,
      color: Colors.black,
    ),
    bodyText1: base.bodyText1.copyWith(
      letterSpacing: 0.5,
      fontFamily: 'Assistant-Regular',
      fontSize: 14.0,
      color: Colors.black87,
    ),
    bodyText2: base.bodyText2.copyWith(
      letterSpacing: 0.25,
      fontFamily: 'Assistant-Regular',
      fontSize: 13.0,
      color: Colors.black,
    ),
    button: base.button.copyWith(
      letterSpacing: 1.25,
      fontFamily: 'Assistant-Bold',
      fontSize: 13.0,
      color: Colors.black,
    ),
    caption: base.caption.copyWith(
      letterSpacing: 0.4,
      fontFamily: 'Assistant-Regular',
      fontSize: 12.0,
      color: Colors.black,
    ),
    overline: base.overline.copyWith(
      letterSpacing: 1.5,
      fontFamily: 'Assistant-Regular',
      fontSize: 10.0,
      color: Colors.black,
    ),
  );
}
