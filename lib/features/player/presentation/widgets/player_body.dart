import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/routes/route_arguments.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/widgets/state_message_view.dart';
import 'package:mishkat/features/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:mishkat/features/bookmarks/presentation/cubit/bookmarks_state.dart';
import 'package:mishkat/features/player/presentation/cubit/player_cubit.dart';
import 'package:mishkat/features/player/presentation/cubit/player_state.dart';
import 'package:mishkat/features/player/presentation/widgets/current_ayah_strip.dart';
import 'package:mishkat/features/player/presentation/widgets/player_controls.dart';
import 'package:mishkat/features/player/presentation/widgets/player_options_row.dart';
import 'package:mishkat/features/player/presentation/widgets/player_progress.dart';
import 'package:mishkat/features/player/presentation/widgets/player_top_bar.dart';
import 'package:mishkat/features/player/presentation/widgets/reciter_row.dart';
import 'package:mishkat/features/player/presentation/widgets/surah_artwork.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Dark green player layout that opens the requested surah when shown.
class PlayerBody extends StatefulWidget {
  final PlayerArgs? args;

  // Creates the body.
  const PlayerBody({super.key, this.args});

  // Creates the body state.
  @override
  State<PlayerBody> createState() => _PlayerBodyState();
}

// Asks the shared player to open the requested surah once.
class _PlayerBodyState extends State<PlayerBody> {
  // Opens the requested surah, keeps what is already playing, or falls back to the last-read surah.
  @override
  void initState() {
    super.initState();
    final bookmarks = BookmarksCubit.get(context).state;
    final lastRead = bookmarks is BookmarksSuccess ? bookmarks.lastRead : null;
    PlayerCubit.get(context).open(
      surahNumber: widget.args?.surahNumber,
      startAyah: widget.args?.startAyah ?? 1,
      fallbackSurah: lastRead?.surahNumber ?? 1,
    );
  }

  // Builds the layout for the current player state.
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: ColorsManager.primary,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: BlocBuilder<PlayerCubit, PlayerState>(
              buildWhen: (a, b) => a.runtimeType != b.runtimeType,
              builder: (context, state) {
                if (state is PlayerError) {
                  return Column(
                    children: [
                      const PlayerTopBar(),
                      Expanded(
                        child: StateMessageView(
                          message: state.message,
                          textColor: ColorsManager.white,
                          onRetry: PlayerCubit.get(context).retry,
                        ),
                      ),
                    ],
                  );
                }
                return Skeletonizer(
                  enabled: state is! PlayerSuccess,
                  child: const _PlayerContent(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Vertical stack of the player sections, scrollable on short screens.
class _PlayerContent extends StatelessWidget {
  // Creates the content.
  const _PlayerContent();

  // Builds every player section in order.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const PlayerTopBar(),
              verticalSpace(12.h),
              const SurahArtwork(),
              verticalSpace(20.h),
              const ReciterRow(),
              verticalSpace(16.h),
              const CurrentAyahStrip(),
              verticalSpace(16.h),
              const PlayerProgress(),
              verticalSpace(8.h),
              const PlayerControls(),
              verticalSpace(16.h),
              const PlayerOptionsRow(),
              verticalSpace(16.h),
            ],
          ),
        ),
      ),
    );
  }
}
