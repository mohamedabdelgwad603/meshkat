import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mishkat/config/routes/page_name.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/core/utills/extentions/build_context_extention.dart';
import 'package:mishkat/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:mishkat/features/splash/presentation/cubit/splash_state.dart';
import 'package:mishkat/features/splash/presentation/widgets/splash_background_pattern.dart';
import 'package:mishkat/features/splash/presentation/widgets/splash_content.dart';

// Lays the brand content over the star pattern and opens the main layout when done.
class SplashBody extends StatelessWidget {
  // Creates the splash body.
  const SplashBody({super.key});

  // Builds the green backdrop, pattern and content.
  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashFinished) context.pushReplacementNamed(PageName.mainLayout);
      },
      child: const AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: ColorsManager.primary,
          body: Stack(
            alignment: Alignment.center,
            children: [
              SplashBackgroundPattern(),
              SplashContent(),
            ],
          ),
        ),
      ),
    );
  }
}
