import 'dart:io';

import 'package:benchmark_harness/benchmark_harness.dart';

enum December {
  day1,
  day2,
  day3,
  day4,
  day5,
  day6,
  day7,
  day8,
  day9,
  day10,
  day11,
  day12,
  day13,
  day14,
  day15,
  day16,
  day17,
  day18,
  day19,
  day20,
  day21,
  day22,
  day23,
  day24,
  day25,
  day26,
  day27,
  day28,
  day29,
  day30,
  day31;

  static December fromString(String val) =>
      values.firstWhere((d) => d.name.contains(val));

  const December();
}

abstract class AocDay {
  const AocDay({
    required this.year,
    required this.day,
    this.useTestInput = false,
  });

  final String year;

  final December day;

  final bool useTestInput;

  Future<String> part1();

  Future<String> part2();

  Stream<List<int>> loadInput() {
    final aocDay = day.name;

    var pathList = Platform.script.path.split(Platform.pathSeparator);
    pathList = pathList.sublist(0, pathList.length - 2)
      ..addAll(["tests", year, aocDay]);

    Uri uri;

    if (useTestInput) {
      pathList.add("$aocDay.test");

      uri = Uri.file(
        pathList.join(Platform.pathSeparator),
        windows: Platform.isWindows,
      );
    } else {
      pathList.add(aocDay);

      uri = Uri.file(
        pathList.join(Platform.pathSeparator),
        windows: Platform.isWindows,
      );
    }

    return File.fromUri(uri).openRead();
  }
}
