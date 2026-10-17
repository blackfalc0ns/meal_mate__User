import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_event.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_state.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_view_model.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_content.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_setup_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';

class FamilyPackageDaysSetupScreen extends StatefulWidget {
  const FamilyPackageDaysSetupScreen({super.key, this.programId});

  final String? programId;

  @override
  State<FamilyPackageDaysSetupScreen> createState() =>
      _FamilyPackageDaysSetupScreenState();
}

class _FamilyPackageDaysSetupScreenState
    extends State<FamilyPackageDaysSetupScreen> {
  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isInFamilyFlow = FamilyFlowScope.isActive(context);

    return BlocProvider<FamilyPackageDaysViewModel>(
      create: (_) {
        final vm = getIt<FamilyPackageDaysViewModel>();
        vm.doIntent(
          GetFamilySubscriptionCurrentEvent(
            memberId: FamilyFlowScope.targetMemberIdOf(context),
          ),
        );
        if (widget.programId != null && widget.programId!.isNotEmpty) {
          vm.doIntent(GetFamilyBundlesEvent(widget.programId!));
        }
        return vm;
      },
      child: isInFamilyFlow
          ? BlocBuilder<FamilyPackageDaysViewModel, FamilyPackageDaysState>(
              buildWhen: _shouldRebuildSetupScreen,
              builder: _buildContent,
            )
          : Scaffold(
              appBar: CustomAppBar(
                showBackButton: true,
                titleWidget: Column(
                  children: [
                    Text(
                      locale.family_setup_title,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size13,
                        color: color.onSurface,
                      ),
                    ),
                    Text(
                      locale.family_setup_subtitle,
                      style: getBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size9,
                        color: color.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              body: SafeArea(
                child:
                    BlocBuilder<
                      FamilyPackageDaysViewModel,
                      FamilyPackageDaysState
                    >(
                      buildWhen: _shouldRebuildSetupScreen,
                      builder: _buildContent,
                    ),
              ),
            ),
    );
  }

  bool _shouldRebuildSetupScreen(
    FamilyPackageDaysState previous,
    FamilyPackageDaysState current,
  ) {
    if (previous.isPlanSaving != current.isPlanSaving) return true;
    final prevHasMembers = previous.members.isNotEmpty;
    final currHasMembers = current.members.isNotEmpty;
    if (prevHasMembers != currHasMembers) return true;
    if (!currHasMembers) {
      return previous.isCurrentFlowLoading != current.isCurrentFlowLoading ||
          previous.failure != current.failure;
    }
    return false;
  }

  Widget _buildContent(BuildContext context, FamilyPackageDaysState state) {
    if ((state.isLoading || state.isCurrentFlowLoading) &&
        state.members.isEmpty) {
      const skeleton = FamilyPackageDaysSetupLoadingSkeleton();
      return context.areAnimationsDisabled
          ? skeleton
          : skeleton.animate().fadeIn(duration: 250.ms);
    }

    if (state.failure != null && state.members.isEmpty) {
      return ApiErrorWidget(
        exception: state.failure!.exception,
        onRetry: () {
          final vm = context.read<FamilyPackageDaysViewModel>();
          vm.doIntent(
            GetFamilySubscriptionCurrentEvent(
              memberId: FamilyFlowScope.targetMemberIdOf(context),
            ),
          );
          if (widget.programId != null && widget.programId!.isNotEmpty) {
            vm.doIntent(GetFamilyBundlesEvent(widget.programId!));
          }
        },
      );
    }

    final color = context.colorScheme;
    final content = FamilyPackageDaysContent(
      programId: widget.programId,
      onNextPressed: () => _savePlanAndProceed(context),
    );

    final Widget animatedContent = context.areAnimationsDisabled
        ? content
        : content.animate().fadeIn(duration: 300.ms, curve: Curves.easeOut);

    return Stack(
      children: [
        animatedContent,
        if (state.isPlanSaving)
          Positioned.fill(
            child: AbsorbPointer(
              child: ColoredBox(
                color: color.scrim.withValues(alpha: 0.32),
                child: const Center(
                  child: CustomProgressIndicator(),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _savePlanAndProceed(BuildContext context) async {
    final vm = context.read<FamilyPackageDaysViewModel>();
    final saved = await vm.saveAllMemberPlansAndWait();
    if (!context.mounted) return;
    if (!saved) {
      final failure = vm.state.failure;
      if (failure != null) {
        CustomSnackbar.showError(
          context: context,
          message: ErrorMessagePresenter.fromFailure(context, failure),
        );
      }
      return;
    }

    context.pushNamed(AppRoutes.familyPaymentSetup);
  }
}
