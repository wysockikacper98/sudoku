import 'package:flutter/material.dart';

class SudokuScreen extends StatefulWidget {
  const SudokuScreen({Key? key}) : super(key: key);

  static const routeName = '/sudoku';

  @override
  State<SudokuScreen> createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  late String _sudokuToSolve;
  late String _solvedSudoku;

  @override
  void initState() {
    super.initState();
    _sudokuToSolve =
    '.1...79..........5..54..6..5...8..9146.......9...4...8...965827........6...72.14.';
    _solvedSudoku =
    '312657984684291375795438612527386491468179253931542768143965827279814536856723149';
  }

  @override
  Widget build(BuildContext context) {
    print('build -> SudokuScreen');
    List<String> _sudokuList = createSudokuToSolve();
    final double _width = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildSudokuBoard(_sudokuList, context),
          const SizedBox(height: 16),
          buildInputNumbers(_width),
        ],
      ),
    );
  }

  Padding buildSudokuBoard(List<String> _sudokuList, BuildContext context) {
    print('build -> buildSudokuBoard');

    int _index = -1;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 9,
        children: _sudokuList.map((number) {
          _index++;

          return GestureDetector(
            key: GlobalKey(debugLabel: _index.toString()),
            child: Container(
              decoration: BoxDecoration(
                border: buildBorder(_index),
              ),
              child: Center(
                child: Text(
                  number == '.' ? ' ' : number,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline5,
                ),
              ),
            ),
            onTap: () {
              print('Selected Square: $_index and my number is: $number');
            },
          );
        }).toList(),
      ),
    );
  }

  Border buildBorder(int index) {
    int restOfDivision = index % 9;

    const BorderSide _borderActive = BorderSide(
      width: 2,
      color: Colors.white60,
    );
    const BorderSide _borderDeactivate = BorderSide(
      width: 1,
      color: Colors.white12,
    );

    return Border(
      top: (index < 9 ||
          (index > 26 && index < 36) ||
          (index > 53 && index < 63))
          ? _borderActive
          : _borderDeactivate,
      bottom: (index > 71 && index < 82) ? _borderActive : _borderDeactivate,
      left: (restOfDivision == 0 || restOfDivision == 3 || restOfDivision == 6)
          ? _borderActive
          : _borderDeactivate,
      right: (restOfDivision == 8) ? _borderActive : _borderDeactivate,
    );
  }

  Row buildInputNumbers(double _width) {
    print('build -> buildSudokuBoard');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        9,
            (index) =>
            Container(
              width: _width / 12,
              height: _width / 8,
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: GestureDetector(
                child: Center(
                  child: Text(
                    (index + 1).toString(),
                    style: const TextStyle(fontSize: 34),
                  ),
                ),
                onTap: () {
                  print(index + 1);
                },
              ),
            ),
      ),
    );
  }

  List<String> createSudokuToSolve() {
    return _sudokuToSolve.split("");
  }
}
