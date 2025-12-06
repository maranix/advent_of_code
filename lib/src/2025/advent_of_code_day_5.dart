part of './advent_of_code_2025.dart';

final class AdventOfCode2025Day5 extends AocDay {
  AdventOfCode2025Day5({
    required super.year,
    required super.useTestInput,
    super.day = December.day5,
  });

  StreamTransformer<String, ({String ranges, String ingredients})>
  _rangeAndIdSeparator() => StreamTransformer.fromHandlers(
    handleData: (data, sink) {
      final separated = data.split(("\n\n"));
      sink.add((ranges: separated.first, ingredients: separated.last));
    },
    handleDone: (sink) => sink.close(),
  );

  StreamTransformer<
    ({String ranges, String ingredients}),
    ({List<List<int>> ranges, List<int> ingredients})
  >
  _rangeAndIdParser(
    SplayTreeSet<List<int>> autoSortingRangeList,
    List<int> ingredientList, [
    bool ignoreIngredients = false,
  ]) => StreamTransformer.fromHandlers(
    handleData: (data, sink) {
      if (!ignoreIngredients) {
        ingredientList.addAll(
          data.ingredients.trim().split("\n").map(int.parse),
        );
      }

      for (final range in data.ranges.split("\n")) {
        final dashIdx = range.indexOf("-");
        if (dashIdx == -1) {
          throw Exception("separator `-` doesn't exist  in range $range");
        }

        autoSortingRangeList.add([
          int.parse(range.substring(0, dashIdx)),
          int.parse(range.substring(dashIdx + 1, range.length)),
        ]);
      }
    },
    handleDone: (sink) {
      sink.add((
        ranges: autoSortingRangeList.toList(),
        ingredients: ingredientList,
      ));
      sink.close();
    },
  );

  SplayTreeSet<List<int>> _creatAutoSortingRangeList() =>
      SplayTreeSet<List<int>>((a, b) {
        final (aStart, aEnd) = (a[0], a[1]);
        final (bStart, bEnd) = (b[0], b[1]);

        final compareStart = aStart.compareTo(bStart);
        if (compareStart != 0) {
          return compareStart;
        }

        return aEnd.compareTo(bEnd);
      });

  @override
  Future<String> part1() async {
    final autoSortingRangeList = _creatAutoSortingRangeList();
    final ingredientIds = <int>[];

    final result = await loadInput()
        .transform(utf8.decoder)
        .transform(_rangeAndIdSeparator())
        .transform(_rangeAndIdParser(autoSortingRangeList, ingredientIds))
        .transform(
          StreamTransformer<
            ({List<List<int>> ranges, List<int> ingredients}),
            int
          >.fromHandlers(
            handleData: (data, sink) {
              for (final id in data.ingredients) {
                for (final range in data.ranges) {
                  final rangeStart = range[0];
                  final rangeEnd = range[1];

                  if (id >= rangeStart && id <= rangeEnd) {
                    sink.add(id);
                  }
                }
              }
            },
            handleDone: (sink) => sink.close(),
          ),
        )
        .distinct()
        .fold(0, (carry, found) {
          return carry += 1;
        });

    return result.toString();
  }

  @override
  Future<String> part2() async {
    final autoSortingRangeList = _creatAutoSortingRangeList();

    final result = await loadInput()
        .transform(utf8.decoder)
        .transform(_rangeAndIdSeparator())
        .transform(_rangeAndIdParser(autoSortingRangeList, [], true))
        .transform(
          StreamTransformer<
            ({List<List<int>> ranges, List<int> ingredients}),
            List<List<int>>
          >.fromHandlers(
            handleData: (data, sink) {
              final mergedRanges = <List<int>>[];
              var currentMerged = data.ranges.first;

              for (var i = 1; i < data.ranges.length; i++) {
                final nextRange = data.ranges[i];

                final currentEnd = currentMerged[1];
                final nextStart = nextRange[0];
                final nextEnd = nextRange[1];

                // **Check for Overlap or Touching**
                // Overlap/Touch occurs if nextStart is less than or equal to currentEnd + 1
                // Example: [3, 5] and [6, 8] -> 6 <= 5 + 1 (TRUE, they touch)
                // Example: [10, 14] and [12, 18] -> 12 <= 14 + 1 (TRUE, they overlap)
                if (nextStart <= currentEnd + 1) {
                  // Case 1: Overlap/Touch -> Merge
                  // Extend the end of the current merged interval
                  currentMerged[1] = math.max(currentEnd, nextEnd);
                } else {
                  // Case 2: No Overlap -> Disjoint
                  // Finalize the current merged interval and add it to the result
                  mergedRanges.add(currentMerged);
                  // Start a new current merged interval with the next range
                  currentMerged = nextRange;
                }
              }

              // **4. Add the very last merged interval**
              // The last interval built in 'currentMerged' must be added after the loop
              mergedRanges.add(currentMerged);

              sink.add(mergedRanges);
            },
            handleDone: (s) => s.close(),
          ),
        )
        .transform(
          StreamTransformer<List<List<int>>, BigInt>.fromHandlers(
            handleData: (data, sink) {
              for (final range in data) {
                sink.add(BigInt.from(((range.last - range.first) + 1)));
              }
            },
            handleDone: (s) => s.close(),
          ),
        )
        .reduce((prev, next) {
          return prev + next;
        });

    return result.toString();
  }
}
