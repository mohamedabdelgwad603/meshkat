import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/features/bookmarks/presentation/screens/saved_screen.dart';
import 'package:mishkat/features/home/presentation/screens/home_screen.dart';
import 'package:mishkat/features/layout/presentation/cubit/layout_cubit.dart';
import 'package:mishkat/features/layout/presentation/cubit/layout_state.dart';
import 'package:mishkat/features/layout/presentation/widgets/app_bottom_nav.dart';
import 'package:mishkat/features/settings/presentation/screens/settings_screen.dart';
import 'package:mishkat/features/surahs/presentation/screens/surahs_screen.dart';

// Shows the selected tab above the bottom navigation bar, keeping each tab alive.
class MainLayoutBody extends StatelessWidget {
  // Creates the layout body.
  const MainLayoutBody({super.key});

  // Builds the tab stack and the navigation bar.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCubit, LayoutState>(
      buildWhen: (a, b) => a.tabIndex != b.tabIndex,
      builder: (context, state) => Scaffold(
        body: IndexedStack(
          index: state.tabIndex,
          children: const [
            HomeScreen(),
            SurahsScreen(),
            SavedScreen(),
            SettingsScreen(),
          ],
        ),
        bottomNavigationBar: AppBottomNav(currentTab: state.tabIndex),
      ),
    );
  }
}
