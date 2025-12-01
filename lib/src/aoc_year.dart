import 'dart:async';

import 'package:advent_of_code/src/aoc_day.dart';

abstract class AocYear {
  const AocYear({required this.year, this.useTestInput = false});

  final String year;

  final bool useTestInput;

  Map<December, AocDay> get solutions;

  Future<String> run(December day) async {
    final solution = solutions[day];
    if (solution == null) {
      throw AocDaySolutionNotFound(year: year, day: day);
    }

    final result = await Future.wait<String>([
      solution.part1(),
      solution.part2(),
    ]);

    return '''Advent Of Code $year, ${day.name}.
    \n
    Part 1: ${result.first}
    Part 2: ${result.last}
    '''
        .trim();
  }

  Future<String> runPart1(December day) async {
    final solution = solutions[day];
    if (solution == null) {
      throw AocDaySolutionNotFound(year: year, day: day);
    }

    final result = await solution.part1();

    return '''Advent Of Code $year, ${day.name}.
    \n
    Part 1: $result
    '''
        .trim();
  }

  Future<String> runPart2(December day) async {
    final solution = solutions[day];
    if (solution == null) {
      throw AocDaySolutionNotFound(year: year, day: day);
    }

    final result = await solution.part2();

    return '''Advent Of Code $year, ${day.name}.
    \n
    Part 2: $result
    '''
        .trim();
  }
}

final class AocDaySolutionNotFound implements Exception {
  const AocDaySolutionNotFound({required this.year, required this.day});

  final String year;

  final December day;

  @override
  String toString() {
    return "Advent of Code Solution for Year $year, Day ${day.name} not found.";
  }
}
