import 'package:flutter/material.dart';
import 'package:sudoku/screens/home_page_screen.dart';
import 'package:sudoku/screens/sudoku_screen.dart';
import 'package:sudoku/theme/theme_dark.dart';
import 'package:sudoku/theme/theme_light.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeLight(),
      darkTheme: themeDark(),
      title: 'Sudoku',
      debugShowCheckedModeBanner: false,
      initialRoute: HomePageScreen.routeName,
      routes: {
        HomePageScreen.routeName: (ctx) => const HomePageScreen(),
        SudokuScreen.routeName: (ctx) => const SudokuScreen(),
      },
    );
  }
}