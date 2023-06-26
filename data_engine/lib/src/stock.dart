class Asset {
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
  ];

  String get value => (valueCents.toDouble() / 100.0).toStringAsFixed(2);

  @override
  String toString() => '$name: \$$value';
}

class Stock extends Asset {
  Stock({
    required super.name,
    required super.valueCents,
  });
}
