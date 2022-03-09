import 'package:badges/badges.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SudokuScreen extends StatefulWidget {
  static const routeName = '/sudoku';

  const SudokuScreen({Key? key}) : super(key: key);

  @override
  State<SudokuScreen> createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen>
    with SingleTickerProviderStateMixin {
  late String _sudokuEnteredByUser;
  late final String _sudokuToSolve;
  late final String _solvedSudoku;
  late double _healthPoint;

  late int _hintAmount;

  int? _selectedSquareIndex;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('SudokuScreen initState');
    }
    _sudokuToSolve = _sudokuEnteredByUser =
        '.1...79..........5..54..6..5...8..9146.......9...4...8...965827........6...72.14.';
    _solvedSudoku =
        '312657984684291375795438612527386491468179253931542768143965827279814536856723149';
    _healthPoint = 3;
    _hintAmount = 3;
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('build -> SudokuScreen');
    }
    List<String> _sudokuList = createSudokuToSolve();
    final double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: () {
              _sudokuEnteredByUser = _sudokuToSolve;
            },
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildHealthPoints(),
          buildSudokuBoard(_sudokuList, context),
          const SizedBox(height: 16),
          buildInputNumbers(_width),
        ],
      ),
    );
  }

  void takeDamage() {
    setState(() {
      _healthPoint--;
    });
    if (_healthPoint == 0) {
      showDialog(context: context, builder: (_) => buildAlertDialog());
    }
  }

  AlertDialog buildAlertDialog() {
    return AlertDialog(
      title: const Text('GAME OVER'),
      content: const Text('You make to many mistakes. Better luck next time.'),
      actions: [
        TextButton(
          child: const Text('Restart puzzle'),
          onPressed: () {
            setState(() {
              _healthPoint = 3;
              _sudokuEnteredByUser = _sudokuToSolve;
            });
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Quit'),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ],
    );
  }

  Padding buildSudokuBoard(List<String> _sudokuList, BuildContext context) {
    if (kDebugMode) {
      print('build -> buildSudokuBoard');
    }
    int _index = 0;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 9,
        children: _sudokuList.map((number) {
          int elementIndex = _index++;

          var staticNumbers = Theme.of(context).textTheme.headline5?.copyWith();
          var addedNumbers = staticNumbers?.copyWith(color: Colors.blue);

          return GestureDetector(
            key: GlobalKey(debugLabel: elementIndex.toString()),
            child: Container(
              decoration: BoxDecoration(
                border: buildBorder(elementIndex),
                color: buildColor(elementIndex),
              ),
              child: Center(
                child: Text(
                  number == '.' ? ' ' : number,
                  style: number == _sudokuToSolve[elementIndex]
                      ? staticNumbers
                      : addedNumbers,
                ),
              ),
            ),
            onTap: () {
              setState(() {
                _selectedSquareIndex = elementIndex;
              });
              if (kDebugMode) {
                print('Selected Square: $elementIndex'
                    ' and my number is: $number');
              }
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
    if (kDebugMode) {
      print('build -> buildSudokuBoard');
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        9,
        (index) => Container(
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
            onTap: _selectedSquareIndex == null ||
                    _sudokuEnteredByUser[_selectedSquareIndex!] != '.'
                ? null
                : () {
                    if (_solvedSudoku[_selectedSquareIndex!] ==
                        (index + 1).toString()) {
                      setState(() {
                        _sudokuEnteredByUser = replaceCharAt(
                          _sudokuEnteredByUser,
                          _selectedSquareIndex!,
                          (index + 1).toString(),
                        );
                      });
                    } else {
                      takeDamage();
                    }
                  },
          ),
        ),
      ),
    );
  }

  String replaceCharAt(String oldString, int index, String newChar) {
    return oldString.substring(0, index) +
        newChar +
        oldString.substring(index + 1);
  }

  List<String> createSudokuToSolve() {
    return _sudokuEnteredByUser.split("");
  }

  Color buildColor(int index) {
    if (_selectedSquareIndex == null) {
      return Colors.transparent;
    } else if (_selectedSquareIndex == index) {
      return Colors.black54;
    } else if (_selectedSquareIndex! % 9 == index % 9 ||
        index >= (_selectedSquareIndex! - _selectedSquareIndex! % 9) &&
            index <= (_selectedSquareIndex! + 8 - _selectedSquareIndex! % 9)) {
      return Colors.black26;
    } else if (_sudokuEnteredByUser[_selectedSquareIndex!] != '.' &&
        _sudokuEnteredByUser[_selectedSquareIndex!] ==
            _sudokuEnteredByUser[index]) {
      return Colors.blueGrey;
    } else {
      return Colors.transparent;
    }
  }

  Widget buildHealthPoints() {
    bool isHintInactive = _hintAmount < 1 ||
        _selectedSquareIndex == null ||
        _sudokuEnteredByUser[_selectedSquareIndex!] != '.';

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(),
          ),
          RatingBar.builder(
            initialRating: _healthPoint,
            minRating: 0,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 3,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (_, __) => const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onRatingUpdate: (double value) {
              if (kDebugMode) {
                print('New health points: $value');
              }
            },
          ),
          Expanded(
            flex: 1,
            child: Badge(
              alignment: Alignment.centerRight,
              badgeContent: Text(_hintAmount.toString()),
              child: IconButton(
                icon: Icon(
                  Icons.lightbulb,
                  size: 32.0,
                  color: isHintInactive ? Colors.white : Colors.yellow,
                ),
                onPressed: isHintInactive
                    ? null
                    : () {
                        setState(() {
                          _hintAmount--;
                          _sudokuEnteredByUser = replaceCharAt(
                              _sudokuEnteredByUser,
                              _selectedSquareIndex!,
                              _solvedSudoku[_selectedSquareIndex!]);
                        });
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
