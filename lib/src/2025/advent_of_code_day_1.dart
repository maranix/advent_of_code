// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:advent_of_code/src/aoc_day.dart';

final class AdventOfCode2025Day1 extends AocDay {
  const AdventOfCode2025Day1({
    required super.year,
    super.day = December.day1,
    super.useTestInput,
  });

  static const int _DIAL_INITIAL_POS = 50;
  // 0-99, 0 is inclusive hence 100 positions
  static const int _DIAL_TOTAL_POS = 100;

  @override
  Future<String> part1() async {
    var dialPos = _DIAL_INITIAL_POS;
    final result = await loadInput()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .fold(0, (leftRotationZeroCount, line) {
          final (rotationDirection, rotationDistance) = (
            line[0],
            int.tryParse(line.substring(1))!,
          );

          if (rotationDirection == "L") {
            // Other way would be to do the following:
            // ((dialPos - rotationDistance) % _DIAL_TOTAL_POS + _DIAL_TOTAL_POS ) % _DIAL_TOTAL_POS)
            dialPos = ((dialPos - rotationDistance) % 100).abs();
          } else if (rotationDirection == "R") {
            dialPos = (dialPos + rotationDistance) % _DIAL_TOTAL_POS;
          }

          if (dialPos == 0) {
            leftRotationZeroCount += 1;
          }

          return leftRotationZeroCount;
        });

    return result.toString();
  }

  @override
  Future<String> part2() async {
    var dialPos = _DIAL_INITIAL_POS;
    final result = await loadInput()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .fold(0, (leftRotationZeroCount, line) {
          final (rotationDirection, rotationDistance) = (
            line[0],
            int.tryParse(line.substring(1))!,
          );

          final pStart = dialPos;
          var hitsThisRotation = 0;

          if (rotationDirection == "R") {
            // Hits = floor((pStart + Distance) / 100)
            // Integer division (~) works for positive numbers, equivalent to floor.
            hitsThisRotation = (pStart + rotationDistance) ~/ _DIAL_TOTAL_POS;

            // Calculate the new position with positive modulus
            dialPos = (pStart + rotationDistance) % _DIAL_TOTAL_POS;
          } else if (rotationDirection == "L") {
            final distance = rotationDistance;

            if (pStart > 0) {
              // Hits = 1 + floor((Distance - pStart) / 100)
              // Use .floor() for accurate math on potentially negative numbers
              final quotient = (distance - pStart) / _DIAL_TOTAL_POS;
              hitsThisRotation = 1 + quotient.floor();
            } else {
              // pStart == 0
              // Hits = floor(Distance / 100)
              hitsThisRotation = distance ~/ _DIAL_TOTAL_POS;
            }

            // Calculate the new position with Dart-safe positive modulus: (x % n + n) % n
            dialPos =
                ((pStart - distance) % _DIAL_TOTAL_POS + _DIAL_TOTAL_POS) %
                _DIAL_TOTAL_POS;
          }

          return leftRotationZeroCount + hitsThisRotation;
        });

    return result.toString();
  }
}
