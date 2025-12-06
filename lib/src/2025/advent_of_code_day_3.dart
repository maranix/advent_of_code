part of './advent_of_code_2025.dart';

final class AdventOfCode2025Day3 extends AocDay {
  AdventOfCode2025Day3({
    required super.year,
    required super.useTestInput,
    super.day = December.day3,
  });

  @override
  Future<String> part1() async {
    final result = await loadInput()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .transform(
          StreamTransformer<String, List<int>>.fromHandlers(
            handleData: (bank, sink) {
              sink.add(bank.split('').map(int.parse).toList());
            },
          ),
        )
        .transform(
          StreamTransformer<List<int>, int>.fromHandlers(
            handleData: (joltBank, sink) {
              var maxJolt = 0;

              for (final (i, tensJolt) in joltBank.indexed) {
                for (var j = i + 1; j < joltBank.length; j++) {
                  maxJolt = math.max(maxJolt, (tensJolt * 10) + joltBank[j]);
                }
              }

              sink.add(maxJolt);
            },
          ),
        )
        .fold(0, (val, jolt) => val + jolt);

    return result.toString();
  }

  @override
  Future<String> part2() async {
    final result = await loadInput().transform(utf8.decoder).length;

    return result.toString();
  }
}
