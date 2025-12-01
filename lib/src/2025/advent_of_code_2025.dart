import 'package:advent_of_code/src/2025/advent_of_code_day_1.dart';
import 'package:advent_of_code/src/aoc_day.dart';
import 'package:advent_of_code/src/aoc_year.dart';

final class AdventOfCode2025 extends AocYear {
  const AdventOfCode2025({super.year = "2025", super.useTestInput});

  @override
  Map<December, AocDay> get solutions => {
    December.day1: AdventOfCode2025Day1(year: year, useTestInput: useTestInput),
  };
}
