part of './advent_of_code_2025.dart';

class AdventOfCode2025Day7 extends AocDay {
  AdventOfCode2025Day7({
    required super.year,
    required super.useTestInput,
    super.day = December.day7,
  });

  @override
  Future<String> part1() async {
    final tachyonGrid = await loadInput()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .transform(
          StreamTransformer<String, List<String>>.fromHandlers(
            handleData: (line, s) {
              s.add(line.split(''));
            },
            handleDone: (s) => s.close(),
          ),
        )
        .toList();

    final row = tachyonGrid.length;
    final col = tachyonGrid[0].length;

    var c = tachyonGrid[0].indexOf("S");

    final splits = _descend(1, c, row, col, tachyonGrid, {});

    return splits.toString();
  }

  int _descend(
    int r,
    int c,
    int rowCount,
    int colCount,
    List<List<String>> grid,
    Set<(int, int)> visited,
  ) {
    if (r < 0 || r >= rowCount) return visited.length;
    if (c < 0 || c >= colCount) return visited.length;
    if (visited.contains((r, c))) return visited.length;

    if (grid[r][c] == "^") {
      grid[r][c - 1] = "|";
      grid[r][c + 1] = "|";

      visited.add((r, c));

      _descend(r + 1, c - 1, rowCount, colCount, grid, visited);
      _descend(r + 1, c + 1, rowCount, colCount, grid, visited);
    } else {
      grid[r][c] = "|";

      _descend(r + 1, c, rowCount, colCount, grid, visited);
    }

    return visited.length;
  }

  @override
  Future<String> part2() async {
    final result = await loadInput().transform(utf8.decoder).length;

    return result.toString();
  }
}
