import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mishkat/config/themes/color_manager.dart';
import 'package:mishkat/core/utills/functions/spacing.dart';
import 'package:mishkat/core/utills/text_manager.dart';
import 'package:mishkat/core/utills/widgets/state_message_view.dart';
import 'package:mishkat/features/hifz/data/models/hifz_session_model.dart';
import 'package:mishkat/features/hifz/data/models/hifz_settings_model.dart';
import 'package:mishkat/features/hifz/data/requests_params/hifz_session_params.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_session_cubit.dart';
import 'package:mishkat/features/hifz/presentation/cubit/hifz_session_state.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_session_ayah_card.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_session_controls.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_session_finished.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_session_status.dart';
import 'package:mishkat/features/hifz/presentation/widgets/hifz_top_bar.dart';
import 'package:skeletonizer/skeletonizer.dart';

// Dark session page: title, current ayah, repeat status and the playback controls.
class HifzSessionBody extends StatelessWidget {
  final HifzSessionParams params;

  // Creates the body for the given range.
  const HifzSessionBody({super.key, required this.params});

  // Builds the page for the current session state.
  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: ColorsManager.primary,
        body: SafeArea(
          child: BlocBuilder<HifzSessionCubit, HifzSessionState>(
            builder: (context, state) {
              final data = state is HifzSessionSuccess
                  ? state.data
                  : HifzSessionData(session: HifzSessionModel.dummy(), settings: HifzSettingsModel.dummy());
              return Padding(
                padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HifzTopBar(
                      title: TextManager.hifzTitle,
                      subtitle: _subtitle(data.session, isArabic),
                      translateSubtitle: false,
                      onDark: true,
                    ),
                    verticalSpace(12.h),
                    Expanded(child: _buildContent(context, state, data)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Builds the error view, the finished view or the running session.
  Widget _buildContent(BuildContext context, HifzSessionState state, HifzSessionData data) {
    if (state is HifzSessionError) {
      return StateMessageView(
        message: state.message,
        textColor: ColorsManager.white,
        onRetry: HifzSessionCubit.get(context).retry,
      );
    }
    if (data.stage == HifzStage.finished) return HifzSessionFinished(params: params);
    return Skeletonizer(
      enabled: state is! HifzSessionSuccess,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HifzSessionStatus(data: data),
            verticalSpace(14.h),
            Expanded(child: HifzSessionAyahCard(data: data)),
            verticalSpace(20.h),
            HifzSessionControls(data: data),
          ],
        ),
      ),
    );
  }

  // Returns the surah and reciter line shown under the title.
  String _subtitle(HifzSessionModel session, bool isArabic) {
    final surah = session.displaySurah(isArabic);
    return session.reciterName.isEmpty ? surah : '$surah · ${session.reciterName}';
  }
}
