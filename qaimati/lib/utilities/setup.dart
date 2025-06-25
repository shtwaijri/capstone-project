import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:qaimati/layer_data/app_data.dart';
import 'package:qaimati/layer_data/auth_layer.dart';
import 'package:qaimati/repository/supabase.dart';

Future<void> setUp() async {
  await dotenv.load(fileName: ".env");
  await SupabaseConnect.init();
  //await EasyLocalization.ensureInitialized();
  GetIt.I.registerSingleton<AuthLayer>(AuthLayer());
  GetIt.I.registerLazySingleton<AppDatatLayer>(() => AppDatatLayer());
}
