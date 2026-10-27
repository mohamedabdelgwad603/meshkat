import 'package:get_it/get_it.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/app_update_di.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/bookmarks_di.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/core_di.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/home_di.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/player_di.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/reader_di.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/reminders_di.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/settings_di.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/splash_di.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/surahs_di.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/tafsir_di.dart';

final GetIt getIt = GetIt.instance;

// Registers every dependency by calling each feature's DI setup.
Future<void> initDi() async {
  await setupCoreDi();
  setupSurahsDi();
  setupBookmarksDi();
  setupReaderDi();
  setupTafsirDi();
  setupPlayerDi();
  setupHomeDi();
  setupSettingsDi();
  setupSplashDi();
  setupRemindersDi();
  setupAppUpdateDi();
}
