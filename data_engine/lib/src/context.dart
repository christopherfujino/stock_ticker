import 'dart:io' as io;

abstract class Context {
  void print(final Object? msg);

  static Context real = _RealContext();
}

class _RealContext implements Context {
  @override
  void print(final Object? msg) => io.stdout.writeln(msg);
}
