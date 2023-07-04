import 'dart:math';

final Random rand = Random();

abstract class Asset {
  Asset({
    required this.name,
    required this.valueCents,
  });

  final String name;
  int valueCents;

  static List<Asset> defaults = <Asset>[
    Stock(
      name: 'microweb',
      valueCents: 100000, // $1k
    ),
    Stock(
      name: 'pyramidbusiness',
      valueCents: 10000000, // $100k
    ),
    Stock(
      name: 'legitsoft',
      valueCents: 1000000,
    ),
  ];

  String get value => (valueCents.toDouble() / 100.0).toStringAsFixed(2);

  void lapseOneMonth();

  @override
  String toString() => '$name: \$$value';
}

class Stock extends Asset {
  Stock({
    required super.name,
    required super.valueCents,
  });

  static const double floor = -0.1;
  static const double mean = 0.1;
  static const double range = (mean - floor) * 2;

  double get nextRate => floor + rand.nextDouble() * range;

  @override
  void lapseOneMonth() {
    print('$name value was ${valueCents / 100}');
    final rate = nextRate;
    valueCents = (valueCents * (1 + rate / 12)).truncate();
    print('$name now is ${valueCents / 100} at rate $rate, multiplier is ${1 + rate / 12}\n');
  }
}
