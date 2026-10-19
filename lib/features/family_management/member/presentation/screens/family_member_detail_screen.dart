import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/family_context/presentation/manager/family_context_view_model.dart';
import 'package:meal_meat_user/features/family_management/calendar/domain/entities/family_calendar_args.dart';
import 'package:meal_meat_user/features/family_management/member/domain/entities/family_member_detail_entity.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_event.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_state.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/manager/family_member_view_model.dart';
import 'package:meal_meat_user/features/family_management/overview/domain/entities/family_member_summary_entity.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_management/shared/domain/entities/family_subscription_settings_entity.dart'
    as ui;
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_detail_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_detail_package_card.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_detail_profile_card.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_detail_program_card.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_detail_progress_card.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_detail_quick_actions_row.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_detail_shortcut_bar.dart';
import 'package:meal_meat_user/features/subscription_upgrade/domain/entities/restaurant_tier_upgrade_args.dart';

class FamilyMemberDetailScreen extends StatefulWidget {
  const FamilyMemberDetailScreen({super.key, required this.member});

  final FamilyMemberSummaryEntity member;

  @override
  State<FamilyMemberDetailScreen> createState() =>
      _FamilyMemberDetailScreenState();
}

class _FamilyMemberDetailScreenState extends State<FamilyMemberDetailScreen> {
  late final FamilyMemberViewModel _viewModel;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt.isRegistered<FamilyMemberViewModel>()
        ? getIt<FamilyMemberViewModel>()
        : FamilyMemberViewModel(
            getIt(),
            getIt(),
            getIt(),
            getIt(),
            getIt(),
            getIt(),
            getIt(),
          );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      if (getIt.isRegistered<FamilyContextViewModel>() &&
          getIt<FamilyContextViewModel>().state.contexts.isEmpty) {
        getIt<FamilyContextViewModel>().loadFamilyContext();
      }
      _viewModel.doIntent(
        LoadFamilyMemberDetailEvent(
          widget.member.memberId,
          locale: context.localization.localeName,
        ),
      );
    }
  }

  @override
  void dispose() {
    unawaited(_viewModel.close());
    super.dispose();
  }

  bool _isViewerManager() {
    if (getIt.isRegistered<FamilyContextViewModel>()) {
      final state = getIt<FamilyContextViewModel>().state;
      if (state.contexts.isNotEmpty) {
        return state.hasManagerContext;
      }
    }
    return true;
  }

  void _confirmDetach(BuildContext context, FamilyMemberDetailEntity detail) {
    final locale = context.localization;
    unawaited(
      showDialog<void>(
        context: context,
        builder: (dialogCtx) => AlertDialog(
          title: Text(locale.family_detach_member_title),
          content: Text(locale.family_detach_member_confirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: Text(locale.family_member_access_deactivate_cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogCtx).pop();
                _viewModel.doIntent(DetachFamilyMemberEvent(detail.memberId));
              },
              child: Text(locale.family_detach_member_action),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final isViewerManager = _isViewerManager();

    return BlocProvider.value(
      value: _viewModel,
      child: BlocConsumer<FamilyMemberViewModel, FamilyMemberState>(
        buildWhen: (previous, current) =>
            previous.detail != current.detail ||
            previous.isSaving != current.isSaving,
        listenWhen: (previous, current) =>
            previous.failure != current.failure ||
            previous.saveFailure != current.saveFailure ||
            previous.saveSuccessCount != current.saveSuccessCount,
        listener: (context, state) {
          final failure = state.saveFailure ?? state.failure;
          if (failure != null) {
            CustomSnackbar.showError(
              context: context,
              message: ErrorMessagePresenter.fromFailure(context, failure),
            );
          } else if (state.saveSuccessCount > 0) {
            CustomSnackbar.showSuccess(
              context: context,
              message: state.isDetached
                  ? locale.family_detach_member_success
                  : locale.family_member_renewal_success,
            );
            _viewModel.doIntent(
              LoadFamilyMemberDetailEvent(
                widget.member.memberId,
                locale: locale.localeName,
              ),
            );
          }
        },
        builder: (context, state) {
          final detail = state.detail;
          return Scaffold(
            backgroundColor: color.surface,
            appBar: CustomAppBar(
              titleWidget: Text(
                locale.family_member_details_title(
                  detail?.displayName ?? widget.member.displayName,
                ),
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size15,
                  color: color.onSurface,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded),
                  tooltip: locale.profile_settings_notifications,
                  onPressed: () => Navigator.of(context).pushNamed(
                    AppRoutes.notifications,
                  ),
                ),
              ],
              onBackPressed: () => Navigator.maybePop(context),
            ),
            body: detail == null
                ? const FamilyMemberDetailLoadingSkeleton()
                : _content(context, detail, isViewerManager: isViewerManager),
          );
        },
      ),
    );
  }

  Widget _content(
    BuildContext context,
    FamilyMemberDetailEntity detail, {
    required bool isViewerManager,
  }) {
    final locale = context.localization;
    final dateFormat = DateFormat.yMMMd(locale.localeName);
    final start = detail.startDate == null
        ? ''
        : dateFormat.format(detail.startDate!);
    final end = detail.endDate == null
        ? ''
        : dateFormat.format(detail.endDate!);
    final nutrition = detail.todayNutrition;

    final statusLabel = detail.isDetached
        ? locale.family_member_detached_label
        : (detail.isDisabled
            ? locale.family_member_disabled_label
            : (detail.isPaidPreparingCalendar
                ? locale.family_member_paid_preparing_label
                : (detail.isSetupRequired
                    ? locale.family_member_setup_required_label
                    : (detail.isPaused
                        ? locale.family_member_paused_label
                        : locale.family_member_active_label))));

    final member = ui.FamilyMemberDetailEntity(
      memberId: detail.memberId,
      subscriptionId: detail.effectiveSubscriptionId,
      isManager: detail.isManager,
      canManageAccess: isViewerManager && !detail.isDetached,
      title: locale.family_member_details_title(detail.displayName),
      name: detail.displayName,
      imageAsset: (detail.displayName.contains('أحمد') ||
              detail.displayName.toLowerCase().contains('ahmed'))
          ? AssetsFake.familyMemberAhmed
          : resolveFamilyMemberAvatar(1),
      ageLabel: detail.ageYears == null
          ? ''
          : locale.family_member_age_years(detail.ageYears!),
      statusLabel: statusLabel,
      roleLabel: detail.isManager
          ? locale.family_member_manager_label
          : locale.family_member_primary_member_label,
      programTitle: locale.family_member_program_title,
      programImageAsset: AssetsFake.familyMemberProgramBalanced,
      programName: detail.hasPlan
          ? detail.programName
          : locale.family_member_no_plan,
      programSubtitle: detail.hasPlan
          ? locale.family_member_program_default_subtitle
          : '',
      changeProgramLabel: locale.family_member_change_program,
      packageTitle: locale.family_member_package_card_title,
      packageImageAsset: AssetsFake.mealBoxes,
      remainingDaysLabel: detail.hasPlan
          ? locale.family_member_days_remaining(detail.remainingDays)
          : locale.family_member_no_plan,
      packageDescription: detail.hasPlan
          ? (start.isEmpty || end.isEmpty
              ? locale.family_member_package_default_subtitle
              : locale.family_member_subscription_dates(start, end))
          : '',
      packageSubtitle: detail.hasPlan
          ? locale.family_member_package_default_subtitle
          : '',
      editPackageLabel: locale.family_member_edit_package,
      selectionTitle: locale.family_member_total_selections_title,
      completedValue: detail.hasPlan && detail.remainingDays > 0
          ? '${detail.remainingDays}/${detail.remainingDays + 2}'
          : (nutrition != null && nutrition.calories > 0
              ? locale.family_member_calories_value(
                  nutrition.calories.toStringAsFixed(0),
                )
              : '0/0'),
      completedLabel: locale.family_member_completed_days_label,
      progress: detail.hasPlan && detail.remainingDays > 0
          ? (detail.remainingDays / (detail.remainingDays + 2)).clamp(0.0, 1.0)
          : (nutrition == null || nutrition.calories <= 0 ? 0 : 1),
      showCalendarLabel: locale.family_member_show_calendar,
      canUpgradeTier: detail.hasPlan && !detail.isDetached,
      canFreeze: detail.hasPlan && !detail.isDetached,
      canRenew: detail.canRenew && !detail.isDetached,
      canCancel: !detail.isManager && !detail.isDetached,
      onUpgradeTier: () {
        final subId = detail.effectiveSubscriptionId;
        if (subId == null || subId.isEmpty) {
          CustomSnackbar.showWarning(
            context: context,
            message: locale.family_member_no_active_subscription,
          );
          return;
        }
        unawaited(
          Navigator.of(context).pushNamed(
            AppRoutes.restaurantTierUpgrade,
            arguments: RestaurantTierUpgradeArgs(subscriptionId: subId),
          ),
        );
      },
      onFreeze: () {
        if (!detail.hasPlan) {
          CustomSnackbar.showWarning(
            context: context,
            message: locale.family_member_no_active_subscription,
          );
          return;
        }
        CustomSnackbar.showWarning(
          context: context,
          message: locale.billing_freeze,
        );
      },
      onRenew: detail.canRenew && detail.renewalPath != null
          ? () => _viewModel.doIntent(
                RenewFamilyMemberSubscriptionEvent(detail.renewalPath!),
              )
          : () {
              CustomSnackbar.showWarning(
                context: context,
                message: locale.family_member_no_active_subscription,
              );
            },
      onCancel: () => _confirmDetach(context, detail),
      shortcuts: [
        ui.FamilyMemberDetailShortcutEntity(
          title: locale.family_member_shortcut_daily_meals,
          subtitle: locale.family_member_shortcut_daily_meals_subtitle,
          type: ui.FamilyMemberDetailShortcutType.dailyMeals,
          onTap: () {
            if (detail.isPaidPreparingCalendar) {
              CustomSnackbar.showWarning(
                context: context,
                message: locale.family_member_fulfillment_pending,
              );
              return;
            }
            final effectiveSub = detail.effectiveSubscriptionId;
            if (effectiveSub == null || effectiveSub.isEmpty) {
              CustomSnackbar.showError(
                context: context,
                message: locale.family_member_no_active_subscription,
              );
              return;
            }
            unawaited(
              Navigator.of(context).pushNamed(
                AppRoutes.familyMemberDailyMeals,
                arguments: FamilyMemberCalendarArgs(
                  memberId: detail.memberId,
                  displayName: detail.displayName,
                  subscriptionId: effectiveSub,
                  isManager: detail.isManager,
                ),
              ),
            );
          },
        ),
        ui.FamilyMemberDetailShortcutEntity(
          title: locale.family_member_shortcut_permissions,
          subtitle: locale.family_member_shortcut_permissions_subtitle,
          type: ui.FamilyMemberDetailShortcutType.permissions,
          onTap: () => unawaited(
            Navigator.of(context).pushNamed(
              AppRoutes.familyMemberAccess,
              arguments: (
                detail.memberId,
                detail.isManager,
                detail.displayName,
              ),
            ),
          ),
        ),
      ],
    );

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsetsDirectional.only(
        start: Spacing.familyMemberDetailHorizontalPadding,
        end: Spacing.familyMemberDetailHorizontalPadding,
        top: Spacing.familyMemberDetailCardGap,
        bottom: Spacing.xl,
      ),
      child: Column(
        children: [
          FamilyMemberDetailProfileCard(member: member),
          const SizedBox(height: Spacing.familyMemberDetailCardGap),
          FamilyMemberDetailQuickActionsRow(member: member),
          const SizedBox(height: Spacing.familyMemberDetailCardGap),
          FamilyMemberDetailProgramCard(member: member),
          const SizedBox(height: Spacing.familyMemberDetailCardGap),
          FamilyMemberDetailPackageCard(
            member: member,
            showAction: isViewerManager &&
                !detail.isDetached &&
                detail.canRenew &&
                !detail.hasUpcomingSubscription,
            onAction: detail.canRenew && detail.renewalPath != null
                ? () => _viewModel.doIntent(
                    RenewFamilyMemberSubscriptionEvent(detail.renewalPath!),
                  )
                : null,
          ),
          if (isViewerManager &&
              !detail.isDetached &&
              !detail.hasPlan &&
              !detail.isManager) ...[
            const SizedBox(height: Spacing.familyMemberDetailCardGap),
            FilledButton.icon(
              onPressed: () async {
                await Navigator.of(context).pushNamed(
                  AppRoutes.familyProgramSetup,
                  arguments: detail.memberId,
                );
                if (!context.mounted) return;
                _viewModel.doIntent(
                  LoadFamilyMemberDetailEvent(
                    detail.memberId,
                    locale: context.localization.localeName,
                  ),
                );
              },
              icon: const Icon(Icons.add_shopping_cart_outlined),
              label: Text(locale.family_member_subscribe_later),
            ),
          ],
          const SizedBox(height: Spacing.familyMemberDetailCardGap),
          FamilyMemberDetailProgressCard(member: member),
          const SizedBox(height: Spacing.familyMemberDetailCardGap),
          FamilyMemberDetailShortcutBar(shortcuts: member.shortcuts),
        ],
      ),
    );
  }
}
