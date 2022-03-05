import 'package:flutter/material.dart';

ThemeData themeDark() {
  return ThemeData.dark().copyWith(
    appBarTheme: appBarTheme,
    elevatedButtonTheme: elevatedButtonThemeData
  );
}

ElevatedButtonThemeData get elevatedButtonThemeData {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: Colors.pinkAccent.shade700,
    ),
  );
}

AppBarTheme get appBarTheme {
  return const AppBarTheme().copyWith(
    centerTitle: true,
  );
}
