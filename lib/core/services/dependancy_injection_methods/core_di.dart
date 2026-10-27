import 'package:dio/dio.dart';
import 'package:mishkat/core/api/api_consumer.dart';
import 'package:mishkat/core/api/dio_consumer.dart';
import 'package:mishkat/core/services/audio/audio_player_service.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/core/services/local_storage/cache_helper.dart';
import 'package:mishkat/core/services/notifications/local_notifications_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Registers shared infrastructure: storage, HTTP client, audio player and local notifications.
Future<void> setupCoreDi() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);
  getIt.registerLazySingleton<CacheHelper>(() => CacheHelper(getIt()));
  getIt.registerLazySingleton<Dio>(Dio.new);
  getIt.registerLazySingleton<ApiConsumer>(() => DioConsumer(getIt()));
  final audio = AudioPlayerService();
  await audio.init();
  getIt.registerLazySingleton<AudioPlayerService>(() => audio);
  final notifications = LocalNotificationsService();
  await notifications.init();
  getIt.registerLazySingleton<LocalNotificationsService>(() => notifications);
}
