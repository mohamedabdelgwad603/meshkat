import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/routes/page_name.dart';
import 'package:mishkat/config/routes/route_manager.dart';
import 'package:mishkat/config/themes/app_theme.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/features/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:mishkat/features/player/presentation/cubit/player_cubit.dart';
import 'package:mishkat/features/reminders/presentation/cubit/reminders_cubit.dart';
import 'package:mishkat/features/reminders/presentation/widgets/daily_reminders_scheduler.dart';
import 'package:mishkat/features/settings/presentation/cubit/settings_cubit.dart';

// Root widget: provides app-wide cubits, theme, localization and routing.
class MishkatApp extends StatelessWidget {
  // Creates the root widget.
  const MishkatApp({super.key});

  // Builds the MaterialApp inside ScreenUtil and the shared providers.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<BookmarksCubit>()),
        BlocProvider.value(value: getIt<SettingsCubit>()),
        BlocProvider.value(value: getIt<PlayerCubit>()),
        BlocProvider(create: (_) => getIt<RemindersCubit>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => TextManager.appName.tr(context: context),
          theme: AppTheme.light(),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          initialRoute: PageName.splash,
          onGenerateInitialRoutes: (name) => [RouteManager.onGenerateRoute(RouteSettings(name: name))],
          onGenerateRoute: RouteManager.onGenerateRoute,
          builder: (context, child) => DailyRemindersScheduler(child: child!),
        ),
      ),
    );
  }
}
