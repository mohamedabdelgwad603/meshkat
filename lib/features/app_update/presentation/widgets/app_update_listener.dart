import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/features/app_update/presentation/cubit/app_update_cubit.dart';
import 'package:mishkat/features/app_update/presentation/cubit/app_update_state.dart';
import 'package:mishkat/features/app_update/presentation/widgets/app_update_sheet.dart';

// Shows the update sheet once the check finds a newer published version.
class AppUpdateListener extends StatelessWidget {
  final Widget child;

  // Creates the listener around the given content.
  const AppUpdateListener({super.key, required this.child});

  // Listens for a successful check that needs an update and opens the sheet.
  @override
  Widget build(BuildContext context) {
    return BlocListener<AppUpdateCubit, AppUpdateState>(
      listenWhen: (_, state) => state is AppUpdateSuccess && state.data.needsUpdate,
      listener: (context, state) => showAppUpdateSheet(context, (state as AppUpdateSuccess).data),
      child: child,
    );
  }
}
