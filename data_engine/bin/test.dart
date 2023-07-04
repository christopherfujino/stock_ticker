import 'package:data_engine/data_engine.dart';

Future<void> main() async => run(Context.real);

Future<void> run(final Context ctx) async {
  final List<Asset> assets = Asset.defaults;
  assets.forEach(ctx.print);
}
