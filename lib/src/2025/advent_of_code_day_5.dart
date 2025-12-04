import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/src/aoc_day.dart';

final class AdventOfCode2025Day5 extends AocDay {
  AdventOfCode2025Day5({
    required super.year,
    required super.useTestInput,
    super.day = December.day5,
  });

  @override
  Future<String> part1() async {
    final result = await loadInput()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .length;

    return result.toString();
  }

  @override
  Future<String> part2() async {
    final result = await loadInput()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .length;

    return result.toString();
  }
}
