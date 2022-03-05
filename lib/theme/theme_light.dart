import 'package:flutter/material.dart';

ThemeData themeLight() {
  return ThemeData.light().copyWith(
    appBarTheme: appBarTheme,
  );
}

AppBarTheme get appBarTheme {
  return const AppBarTheme().copyWith(
    centerTitle: true,
  );
}
