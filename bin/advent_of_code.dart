import 'package:advent_of_code/advent_of_code.dart';
import 'package:advent_of_code/src/aoc_day.dart';
import 'package:args/args.dart';

enum ArgOption {
  year('year'),
  day('day'),
  test('test'),
  partOne('part_one'),
  partTwo('part_two');

  final String value;

  const ArgOption(this.value);

  String get abbr => value[0];
}

void main(List<String> arguments) async {
  final argResult = setupArgs().parse(arguments);

  final year = argResult.option(ArgOption.year.value)!;
  final day = December.fromString(argResult.option(ArgOption.day.value)!);
  final useTestInput = argResult.flag(ArgOption.test.value);
  final partOne = argResult.flag(ArgOption.partOne.value);
  final partTwo = argResult.flag(ArgOption.partTwo.value);

  final advent = switch (year) {
    '2025' => AdventOfCode2025(useTestInput: useTestInput),
    _ => throw Exception(
      'Invalid year $year, This shouldn\'t have happened, something went horribly wrong.',
    ),
  };

  if (!partOne && !partTwo) {
    print(await advent.run(day));
  }

  if (partOne) {
    print(await advent.runPart1(day));
  }

  if (partTwo) {
    print(await advent.runPart2(day));
  }
}

ArgParser setupArgs() {
  final today = DateTime.now();

  return ArgParser()
    ..addFlag(
      ArgOption.test.value,
      abbr: ArgOption.test.abbr,
      defaultsTo: false,
    )
    ..addFlag(ArgOption.partOne.value, defaultsTo: false)
    ..addFlag(ArgOption.partTwo.value, defaultsTo: false)
    ..addOption(
      'year',
      abbr: 'y',
      defaultsTo: today.year.toString(),
      callback: (year) {
        if (year == null) {
          throw ArgParserException(
            "Please provide a year using `--year` or `-y` option.",
            [],
            'year',
          );
        }

        if (year.length != 4) {
          throw ArgParserException(
            "Please provide a valid `year` value",
            [],
            'year',
          );
        }

        final parsedYear = int.tryParse(year);
        if (parsedYear == null) {
          throw ArgParserException(
            "Please provide a valid integer `year` value",
            [],
            'year',
          );
        }

        RangeError.checkValidRange(2015, today.year, parsedYear);
      },
    )
    ..addOption(
      'day',
      abbr: 'd',
      defaultsTo: 'day${today.day}',
      callback: (day) {
        if (day == null) {
          throw ArgParserException(
            "Please provide a day using `--day` or `-d` option.",
            [],
            'day',
          );
        }

        final parsedDay = int.tryParse(day.substring(3));
        if (parsedDay == null) {
          throw ArgParserException(
            "Please provide a valid integer `day` value",
            [],
            'day',
          );
        }

        RangeError.checkValidRange(1, parsedDay, 31);
      },
    );
}
