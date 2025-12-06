// ignore_for_file: constant_identifier_names

part of './advent_of_code_2025.dart';

final class AdventOfCode2025Day6 extends AocDay {
  const AdventOfCode2025Day6({
    required super.year,
    super.day = December.day6,
    super.useTestInput,
  });

  @override
  Future<String> part1() async {
    final colToNumMap = <int, List<int>>{};

    final result = await loadInput()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .transform(
          StreamTransformer<String, List<String>>.fromHandlers(
            handleData: (data, sink) {
              for (final (i, str)
                  in data.split(" ").where((s) => s.isNotEmpty).indexed) {
                if (str == "+" || str == "*") {
                  break;
                }

                colToNumMap.putIfAbsent(i, () => []).add(int.parse(str));
              }

              if (data[0] == "+" || data[0] == "*") {
                sink.add(data.split(" ").where((s) => s.isNotEmpty).toList());
              }
            },
            handleDone: (s) => s.close(),
          ),
        )
        .transform(
          StreamTransformer<List<String>, int>.fromHandlers(
            handleData: (operations, sink) {
              for (final (i, op) in operations.indexed) {
                final nums = colToNumMap[i]!;

                sink.add(
                  nums.reduce((a, b) {
                    if (op == "+") {
                      return a + b;
                    }

                    return a * b;
                  }),
                );
              }
            },
            handleDone: (s) => s.close(),
          ),
        )
        .reduce((a, b) => a + b);

    return result.toString();
  }

  @override
  Future<String> part2() async {
    final result = await loadInput().transform(utf8.decoder).length;

    return result.toString();
  }
}
