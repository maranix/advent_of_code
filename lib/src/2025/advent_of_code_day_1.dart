// ignore_for_file: constant_identifier_names

part of './advent_of_code_2025.dart';

enum DialRotationDirection {
  l("L"),
  r("R");

  static DialRotationDirection fromString(String val) {
    return DialRotationDirection.values.firstWhere(
      (d) => d.direction == val.toUpperCase(),
    );
  }

  final String direction;
  const DialRotationDirection(this.direction);
}

final class AdventOfCode2025Day1 extends AocDay {
  const AdventOfCode2025Day1({
    required super.year,
    super.day = December.day1,
    super.useTestInput,
  });

  static const int _DIAL_INITIAL_POS = 50;
  // 0-99, 0 is inclusive hence 100 positions
  static const int _DIAL_TOTAL_POS = 100;

  StreamTransformer<String, ({DialRotationDirection direction, int distance})>
  _dialRotationSplitter() => StreamTransformer.fromHandlers(
    handleData: (data, sink) {
      final direction = DialRotationDirection.fromString(data[0]);
      final distance = int.parse(data.substring(1));

      sink.add((direction: direction, distance: distance));
    },
    handleError: (error, trace, sink) {
      sink.addError(error, trace);
    },

    handleDone: (sink) {
      sink.close();
    },
  );

  @override
  Future<String> part1() async {
    var dialPos = _DIAL_INITIAL_POS;
    final result = await loadInput()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .transform(_dialRotationSplitter())
        .fold(0, (leftRotationZeroCount, rotation) {
          dialPos = switch (rotation.direction) {
            // An alternative would be to do the following:
            // ((dialPos - rotationDistance) % _DIAL_TOTAL_POS + _DIAL_TOTAL_POS ) % _DIAL_TOTAL_POS)
            .l => ((dialPos - rotation.distance) % 100).abs(),
            .r => (dialPos + rotation.distance) % _DIAL_TOTAL_POS,
          };

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
