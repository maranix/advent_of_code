import 'dart:async' show StreamTransformer, EventSink, Completer;
import 'dart:collection' show SplayTreeSet;
import 'dart:convert' show LineSplitter, utf8;
import 'dart:io' as io;
import 'dart:math' as math show max;

import 'package:advent_of_code/src/aoc_day.dart';
import 'package:advent_of_code/src/aoc_year.dart';
import 'package:collection/collection.dart';

part './advent_of_code_day_1.dart';
part './advent_of_code_day_2.dart';
part './advent_of_code_day_3.dart';
part './advent_of_code_day_4.dart';
part './advent_of_code_day_5.dart';
part './advent_of_code_day_6.dart';
part './advent_of_code_day_7.dart';

final class AdventOfCode2025 extends AocYear {
  const AdventOfCode2025({super.year = "2025", super.useTestInput});

  @override
  Map<December, AocDay> get solutions => {
    December.day1: AdventOfCode2025Day1(year: year, useTestInput: useTestInput),
    December.day2: AdventOfCode2025Day2(year: year, useTestInput: useTestInput),
    December.day3: AdventOfCode2025Day3(year: year, useTestInput: useTestInput),
    December.day4: AdventOfCode2025Day4(year: year, useTestInput: useTestInput),
    December.day5: AdventOfCode2025Day5(year: year, useTestInput: useTestInput),
    December.day6: AdventOfCode2025Day6(year: year, useTestInput: useTestInput),
    December.day7: AdventOfCode2025Day7(year: year, useTestInput: useTestInput),
  };
}
