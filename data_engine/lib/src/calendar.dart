import 'package:meta/meta.dart';

/// A particular moment in time.
@immutable
class Moment {
  const Moment({
    required this.month,
    required this.year,
  });

  final Year year;
  final Month month;

  Moment operator +(final TimePart other) {
    switch (other) {
      case Year():
        return Moment(month: month, year: Year(year.value + other.value));
      case Month():
        final int nextMonthValue = month.value + other.value;
        if (nextMonthValue >= 12) {
          return Moment(
            month: Month(nextMonthValue % 12),
            year: Year(year.value + 1),
          );
        }
        return Moment(
          month: Month(nextMonthValue),
          year: year,
        );
      default:
        throw UnimplementedError('TODO');
    }
  }

  @override
  int get hashCode => Object.hashAll(<Object>[year, month]);

  @override
  bool operator ==(final Object other) =>
      other is Moment && other.hashCode == hashCode;

  @override
  String toString() =>
      '${(month.value + 1).toString().padLeft(2, '0')}-${year.value}';
}

sealed class TimePart {}

class Year implements TimePart {
  const Year(this.value) : assert(value > 0);

  final int value;
}

class Month implements TimePart {
  const Month(this.value) : assert(value < 12 && value >= 0);

  final int value;

  static const Month january = Month(0);
}
