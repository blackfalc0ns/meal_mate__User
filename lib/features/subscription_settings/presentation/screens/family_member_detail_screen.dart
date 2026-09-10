import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_management_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart'
    as ui;
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_management_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_management_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_management_view_model.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_member_calendar_args.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_loading_skeleton.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_package_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_profile_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_program_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_progress_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_shortcut_bar.dart';

class FamilyMemberDetailScreen extends StatefulWidget {
  const FamilyMemberDetailScreen({super.key, required this.member});
  final FamilyMemberSummaryEntity member;
  @override
  State<FamilyMemberDetailScreen> createState() =>
      _FamilyMemberDetailScreenState();
}

class _FamilyMemberDetailScreenState extends State<FamilyMemberDetailScreen> {
  late final FamilyManagementViewModel _viewModel;
  bool _loaded = false;
  @override
  void initState() {
    super.initState();
    _viewModel = getIt<FamilyManagementViewModel>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    _viewModel.doIntent(
      LoadFamilyMemberEvent(
        widget.member.memberId,
        context.localization.localeName,
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return BlocProvider.value(
      value: _viewModel,
      child: BlocConsumer<FamilyManagementViewModel, FamilyManagementState>(
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
            CustomSnackbar.showInfo(
              context: context,
              message: context.localization.family_member_renewal_success,
            );
          }
        },
        builder: (context, state) {
          final detail = state.memberDetail;
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
              onBackPressed: () => Navigator.maybePop(context),
            ),
            body: detail == null
                ? const FamilyMemberDetailLoadingSkeleton()
                : _content(context, detail),
          );
        },
      ),
    );
  }

  Widget _content(BuildContext context, FamilyMemberDetailEntity detail) {
    final locale = context.localization;
    final dateFormat = DateFormat.yMMMd(locale.localeName);
    final start = detail.startDate == null
        ? ''
        : dateFormat.format(detail.startDate!);
    final end = detail.endDate == null
        ? ''
        : dateFormat.format(detail.endDate!);
    final nutrition = detail.todayNutrition;
    final member = ui.FamilyMemberDetailEntity(
      memberId: detail.memberId,
      subscriptionId: detail.subscriptionId,
      isManager: detail.isManager,
      title: locale.family_member_details_title(detail.displayName),
      name: detail.displayName,
      imageAsset: Assets.profileAvatar,
      ageLabel: detail.ageYears == null
          ? ''
          : locale.family_member_age_years(detail.ageYears!),
      statusLabel: detail.isPaused
          ? locale.family_member_paused_label
          : locale.family_member_active_label,
      roleLabel: detail.isManager
          ? locale.family_member_manager_label
          : locale.family_member_member_label,
      programTitle: locale.family_member_program_title,
      programImageAsset: AssetsFake.searchSalad,
      programName: detail.hasPlan
          ? detail.programName
          : locale.family_member_no_plan,
      changeProgramLabel: locale.family_member_change_program,
      packageTitle: locale.family_member_package_title,
      remainingDaysLabel: detail.hasPlan
          ? locale.family_member_days_remaining(detail.remainingDays)
          : locale.family_member_no_plan,
      packageDescription: start.isEmpty || end.isEmpty
          ? ''
          : locale.family_member_subscription_dates(start, end),
      editPackageLabel: locale.family_member_renew_subscription,
      selectionTitle: locale.family_member_today_nutrition,
      completedValue: locale.family_member_calories_value(
        (nutrition?.calories ?? 0).toStringAsFixed(0),
      ),
      completedLabel: detail.todayNutrition == null
          ? ''
          : '${nutrition!.proteinG.toStringAsFixed(0)} / ${nutrition.carbsG.toStringAsFixed(0)} / ${nutrition.fatG.toStringAsFixed(0)}',
      progress: nutrition == null || nutrition.calories <= 0 ? 0 : 1,
      showCalendarLabel: locale.family_member_show_calendar,
      shortcuts: [
        ui.FamilyMemberDetailShortcutEntity(
          title: locale.family_member_shortcut_daily_meals,
          subtitle: locale.family_member_shortcut_daily_meals_subtitle,
          type: ui.FamilyMemberDetailShortcutType.dailyMeals,
          onTap: () {
            if (detail.subscriptionId == null ||
                detail.subscriptionId!.isEmpty) {
              CustomSnackbar.showError(
                context: context,
                message: locale.family_member_no_active_subscription,
              );
              return;
            }
            Navigator.of(context).pushNamed(
              AppRoutes.familyMemberDailyMeals,
              arguments: FamilyMemberCalendarArgs(
                memberId: detail.memberId,
                displayName: detail.displayName,
                subscriptionId: detail.subscriptionId,
                isManager: detail.isManager,
              ),
            );
          },
        ),
        ui.FamilyMemberDetailShortcutEntity(
          title: locale.family_member_shortcut_permissions,
          subtitle: locale.family_member_shortcut_permissions_subtitle,
          type: ui.FamilyMemberDetailShortcutType.permissions,
          onTap: () => Navigator.of(context).pushNamed(
            AppRoutes.familyMemberAccess,
            arguments: (detail.memberId, detail.isManager, detail.displayName),
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
          FamilyMemberDetailProgramCard(member: member),
          const SizedBox(height: Spacing.familyMemberDetailCardGap),
          FamilyMemberDetailPackageCard(
            member: member,
            showAction: detail.canRenew,
            onAction: detail.canRenew && detail.renewalPath != null
                ? () => _viewModel.doIntent(
                    RenewFamilyMemberSubscriptionEvent(detail.renewalPath!),
                  )
                : null,
          ),
          const SizedBox(height: Spacing.familyMemberDetailCardGap),
          FamilyMemberDetailProgressCard(member: member),
          const SizedBox(height: Spacing.familyMemberDetailCardGap),
          FamilyMemberDetailShortcutBar(shortcuts: member.shortcuts),
        ],
      ),
    );
  }
}
