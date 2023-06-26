/// A particular moment in time.
class Moment {
  Moment({
    required this.month,
    required this.year,
  });

  final Year year;
  final Month month;

  Moment operator +(final Object other) {
    if (other is Year) {
      return Moment(
        month: month,
        year: Year(year.value + other.value),
      );
    }
    if (other is Month) {
      throw UnimplementedError('TODO');
    }
    throw UnimplementedError('Foo bar');
  }
}

class Year {
  const Year(this.value) : assert(value > 0);

  final int value;
}

class Month {
  const Month(this.value) : assert(value < 12 && value >= 0);

  final int value;
}
