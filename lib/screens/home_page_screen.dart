import 'package:flutter/material.dart';
import 'package:sudoku/screens/sudoku_screen.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    const double _buttonSize = 200;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home screen'),
      ),
      body: Center(
        child: SizedBox(
          width: _buttonSize,
          height: _buttonSize,
          child: ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Image.asset('assets/images/sudoku.png'),
                  const Spacer(),
                  Text(
                    'Sudoku',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ],
              ),
            ),
            onPressed: () =>
                Navigator.of(context).pushNamed(SudokuScreen.routeName),
          ),
        ),
      ),
    );
  }
}
