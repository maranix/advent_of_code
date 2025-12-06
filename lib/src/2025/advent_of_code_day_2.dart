part of './advent_of_code_2025.dart';

final class AdventOfCode2025Day2 extends AocDay {
  const AdventOfCode2025Day2({
    required super.year,
    super.day = December.day2,
    super.useTestInput,
  });

  StreamTransformer<String, String> _commaSplitter() {
    return StreamTransformer<String, String>.fromHandlers(
      handleData: (data, sink) {
        for (final idRange in data.split(",")) {
          sink.add(idRange.trim());
        }
      },
      handleError: (error, stackTrace, sink) {
        sink.addError(error, stackTrace);
      },
      handleDone: (sink) {
        sink.close();
      },
    );
  }

  StreamTransformer<String, ({String start, String end})> _dashSplitter() {
    return StreamTransformer.fromHandlers(
      handleData: (data, sink) {
        final dashIdx = data.indexOf("-");

        sink.add((
          start: data.substring(0, dashIdx),
          end: data.substring(dashIdx + 1, data.length),
        ));
      },
      handleError: (error, stackTrace, sink) {
        sink.addError(error, stackTrace);
      },
      handleDone: (sink) {
        sink.close();
      },
    );
  }

  @override
  Future<String> part1() async {
    final result = await loadInput()
        .transform(utf8.decoder)
        .transform(_commaSplitter())
        .transform(_dashSplitter())
        .transform(
          StreamTransformer<({String start, String end}), int>.fromHandlers(
            handleData: (data, sink) {
              final rangeStart = int.parse(data.start);
              final rangeEnd = int.parse(data.end);

              for (var i = rangeStart; i <= rangeEnd; i++) {
                final iStr = i.toString();

                final mid = (iStr.length / 2).floor();

                final firstHalf = iStr.substring(0, mid);
                final secondHalf = iStr.substring(mid, iStr.length);

                // Only push numbers that match our condition of being invalid
                if (firstHalf == secondHalf) {
                  sink.add(i);
                }
              }
            },
            handleError: (error, stackTrace, sink) {
              sink.addError(error, stackTrace);
            },
            handleDone: (sink) {
              sink.close();
            },
          ),
        )
        .reduce((prev, next) => prev + next);

    return result.toString();
  }

  @override
  Future<String> part2() async {
    final result = await loadInput()
        .transform(utf8.decoder)
        .transform(_commaSplitter())
        .transform(_dashSplitter())
        .transform(
          StreamTransformer<({String start, String end}), int>.fromHandlers(
            handleData: (data, sink) {
              final rangeStart = int.parse(data.start);
              final rangeEnd = int.parse(data.end);

              for (var i = rangeStart; i <= rangeEnd; i++) {
                final iStr = i.toString();

                var mid = (iStr.length / 2).floor();

                while (mid >= 0) {
                  final possibleSequence = iStr.substring(0, mid);
                  final remainingSpace = iStr.substring(mid, iStr.length);

                  final lengthOfSequence = possibleSequence.length;

                  if (possibleSequence.isEmpty) {
                    mid -= 1;
                    continue;
                  }

                  // Must be an exact multiple of the sequence length
                  if (iStr.length % lengthOfSequence != 0) {
                    mid -= 1;
                    continue; // Skip this possibleSequence, try a shorter one
                  }

                  bool containsRepeatingSequence = true;

                  var l = 0;
                  final r = remainingSpace.length;

                  while ((l <= r) && ((r - l) >= lengthOfSequence)) {
                    final sequence = remainingSpace.substring(
                      l,
                      l + lengthOfSequence,
                    );

                    if (sequence != possibleSequence) {
                      containsRepeatingSequence = false;
                      break;
                    }

                    l += possibleSequence.length;
                  }

                  mid -= 1;

                  if (containsRepeatingSequence) {
                    sink.add(i);
                    break;
                  }
                }
              }

              sink.add(0);
            },
            handleError: (error, stackTrace, sink) {
              sink.addError(error, stackTrace);
            },
            handleDone: (sink) {
              sink.close();
            },
          ),
        )
        .reduce((prev, next) => prev + next);

    return result.toString();
  }
}
