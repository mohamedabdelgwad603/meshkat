import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/core/services/dependancy_injection_methods/init_di.dart';
import 'package:mishkat/features/app_update/presentation/cubit/app_update_cubit.dart';
import 'package:mishkat/features/app_update/presentation/widgets/app_update_listener.dart';
import 'package:mishkat/features/layout/presentation/cubit/layout_cubit.dart';
import 'package:mishkat/features/layout/presentation/widgets/main_layout_body.dart';

// Hosts the four main tabs and the bottom navigation bar.
class MainLayoutScreen extends StatelessWidget {
  // Creates the main layout screen.
  const MainLayoutScreen({super.key});

  // Provides the layout and update cubits and builds the body.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LayoutCubit()),
        BlocProvider(create: (_) => getIt<AppUpdateCubit>()..checkForUpdate()),
      ],
      child: const AppUpdateListener(child: MainLayoutBody()),
    );
  }
}
