import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../services/location_service.dart';
import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  preferRelativeImports: true, // default
)
Future<void> configureDependencies() async {
  await getIt.init();
  if (!getIt.isRegistered<LocationService>()) {
    getIt.registerLazySingleton<LocationService>(() => const LocationService());
  }
}
