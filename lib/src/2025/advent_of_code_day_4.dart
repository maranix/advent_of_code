import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/src/aoc_day.dart';

const List<List<int>> neighborOffsets = [
  [-1, -1], [-1, 0], [-1, 1], // Top row
  [0, -1], [0, 1], // Middle row
  [1, -1], [1, 0], [1, 1], // Bottom row
];

final class AdventOfCode2025Day4 extends AocDay {
  AdventOfCode2025Day4({
    required super.year,
    required super.useTestInput,
    super.day = December.day4,
  });

  @override
  Future<String> part1() async {
    var lines = <String>[];
    final result = await loadInput()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .transform(
          StreamTransformer<String, List<String>>.fromHandlers(
            handleData: (line, sink) {
              lines.add(line);
            },
            handleDone: (sink) {
              sink.add(lines);

              sink.close();
            },
          ),
        )
        .transform(
          StreamTransformer<List<String>, int>.fromHandlers(
            handleData: (grid, sink) {
              final row = grid.length;
              final col = grid[0].length;

              int accessibleRolls = 0;

              for (var r = 0; r < row; r++) {
                for (var c = 0; c < col; c++) {
                  if (grid[r][c] == ".") {
                    continue;
                  }

                  var adjacentRollsOfPaper = 0;

                  for (final offset in neighborOffsets) {
                    int neighbourR = r + offset[0];
                    int neighbourC = c + offset[1];

                    bool isWithinBounds =
                        neighbourR >= 0 &&
                        neighbourR < row &&
                        neighbourC >= 0 &&
                        neighbourC < col;

                    if (isWithinBounds) {
                      if (grid[neighbourR][neighbourC] == "@") {
                        adjacentRollsOfPaper += 1;
                      }
                    }
                  }

                  if (adjacentRollsOfPaper < 4) {
                    accessibleRolls += 1;
                  }
                }
              }

              sink.add(accessibleRolls);
            },
            handleDone: (sink) {
              sink.close();
            },
          ),
        )
        .fold(0, (val, add) {
          return val + add;
        });

    return result.toString();
  }

  @override
  Future<String> part2() async {
    final result = await loadInput().transform(utf8.decoder).length;

    return result.toString();
  }
}
