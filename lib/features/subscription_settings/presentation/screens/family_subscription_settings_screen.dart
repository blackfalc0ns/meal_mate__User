import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/core/widget/notification_button.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_management_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart'
    as ui;
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_management_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_management_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/family_management_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_subscription_meals_status_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_subscription_members_section.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_subscription_plan_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_subscription_quick_access_section.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_subscription_settings_loading_skeleton.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_subscription_warning_card.dart';

class FamilySubscriptionSettingsScreen extends StatefulWidget {
  const FamilySubscriptionSettingsScreen({super.key});
  @override
  State<FamilySubscriptionSettingsScreen> createState() =>
      _FamilySubscriptionSettingsScreenState();
}

class _FamilySubscriptionSettingsScreenState
    extends State<FamilySubscriptionSettingsScreen> {
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
    if (!_loaded) {
      _loaded = true;
      _viewModel.doIntent(LoadFamilyHomeEvent(context.localization.localeName));
    }
  }

  @override
  void dispose() {
    unawaited(_viewModel.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return BlocProvider.value(
      value: _viewModel,
      child: BlocConsumer<FamilyManagementViewModel, FamilyManagementState>(
        buildWhen: (previous, current) =>
            previous.home != current.home ||
            previous.isLoading != current.isLoading ||
            previous.failure != current.failure,
        listenWhen: (previous, current) =>
            previous.failure != current.failure && current.failure != null,
        listener: (context, state) => CustomSnackbar.showError(
          context: context,
          message: ErrorMessagePresenter.fromFailure(context, state.failure!),
        ),
        builder: (context, state) {
          final home = state.home;
          return Scaffold(
            backgroundColor: color.surface,
            appBar: CustomAppBar(
              title: locale.family_manage_title,
              titleFontSize: FontSize.size14,
              backgroundColor: color.surface,
              showShadow: false,
              actions: [NotificationButton(onTap: () {})],
            ),
            body: home == null && state.failure != null
                ? ApiErrorWidget(
                    exception: state.failure!.exception,
                    onRetry: () => _viewModel.doIntent(
                      LoadFamilyHomeEvent(locale.localeName),
                    ),
                  )
                : home == null
                ? const FamilySubscriptionSettingsLoadingSkeleton()
                : RefreshIndicator(
                    color: color.primary,
                    onRefresh: () async {
                      _viewModel.doIntent(
                        LoadFamilyHomeEvent(locale.localeName),
                      );
                      await _viewModel.stream.firstWhere(
                        (next) => !next.isLoading,
                      );
                    },
                    child: _content(context, home),
                  ),
          );
        },
      ),
    );
  }

  Widget _content(BuildContext context, FamilyHomeEntity home) {
    final locale = context.localization;
    final hasIncompleteMeals = home.todaySchedule.any(
      (m) =>
          m.todayRequiredCount > 0 && m.todayFilledCount < m.todayRequiredCount,
    );
    final settings = ui.FamilySubscriptionSettingsEntity(
      title: home.name,
      subtitle: home.packageName,
      statusLabel: locale.family_member_active_label,
      originalPrice: home.price.toStringAsFixed(3),
      discountedPrice: home.price.toStringAsFixed(3),
      currency: home.currencyCode,
      endsOn: '',
      heroImageAsset: Assets.familyManagePlanCard,
      members: home.members
          .map(
            (member) => ui.FamilySubscriptionMemberEntity(
              name: member.displayName,
              imageAsset: Assets.profileAvatar,
              statusLabel: member.isUnsubscribed
                  ? locale.family_member_unsubscribed_status
                  : (member.todayFilledCount >= member.todayRequiredCount &&
                          member.todayRequiredCount > 0
                      ? locale.family_member_completed
                      : locale.family_manage_missing_selection),
              isComplete: member.isUnsubscribed
                  ? false
                  : (member.todayFilledCount >= member.todayRequiredCount &&
                          member.todayRequiredCount > 0),
            ),
          )
          .toList(),
      quickActions: [
        ui.FamilySubscriptionQuickActionEntity(
          code: 'meals',
          label: locale.family_manage_meals,
          iconAsset: Assets.familyManageMeals,
        ),
        ui.FamilySubscriptionQuickActionEntity(
          code: 'subscription',
          label: locale.family_manage_subscription,
          iconAsset: Assets.familyManageSubscription,
        ),
        ui.FamilySubscriptionQuickActionEntity(
          code: 'permissions',
          label: locale.family_manage_permissions,
          iconAsset: Assets.familyManagePermissions,
        ),
      ],
      mealStatuses: home.todaySchedule.map((member) {
        final required = member.todayRequiredCount;
        final filled = member.todayFilledCount;
        final complete = required > 0 && filled >= required;
        final isStarted = filled > 0;
        final String statusLabel = complete
            ? locale.family_manage_completed_status
            : isStarted
            ? locale.family_manage_selected_status
            : (member.todayUiStatus?.trim().isNotEmpty == true
                  ? member.todayUiStatus!
                  : locale.family_manage_not_started_status);
        final String mealsLabel = required <= 0
            ? '$filled/$required'
            : filled == 0
            ? locale.family_manage_meal_count_0.replaceFirst(
                '0/4',
                '$filled/$required',
              )
            : locale.family_manage_meal_count_4.replaceFirst(
                '4/4',
                '$filled/$required',
              );
        return ui.FamilySubscriptionMealStatusEntity(
          memberName: member.displayName,
          memberImageAsset: Assets.profileAvatar,
          mealsLabel: mealsLabel,
          statusLabel: statusLabel,
          progress: required <= 0 ? 0 : (filled / required).clamp(0, 1),
          status: complete
              ? ui.FamilySubscriptionMealStatus.completed
              : isStarted
              ? ui.FamilySubscriptionMealStatus.selected
              : ui.FamilySubscriptionMealStatus.missing,
        );
      }).toList(),
      warningTitle: hasIncompleteMeals
          ? locale.family_manage_warning_title
          : '',
      warningMessage: hasIncompleteMeals
          ? locale.family_manage_warning_message
          : '',
    );
    return SafeArea(
      top: false,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.familyManageHorizontalPadding,
        ),
        children: [
          const SizedBox(height: Spacing.md),
          FamilySubscriptionPlanCard(settings: settings),
          const SizedBox(height: Spacing.xl),
          FamilySubscriptionMembersSection(
            members: settings.members,
            onShowAllTap: () =>
                context.pushNamed(AppRoutes.familySubscriptionMembers),
          ),
          if (settings.quickActions.isNotEmpty) ...[
            const SizedBox(height: Spacing.xl),
            FamilySubscriptionQuickAccessSection(
              actions: settings.quickActions,
              onActionTap: (_) =>
                  context.pushNamed(AppRoutes.familySubscriptionMembers),
            ),
          ],
          if (settings.mealStatuses.isNotEmpty) ...[
            const SizedBox(height: Spacing.xl),
            FamilySubscriptionMealsStatusCard(
              statuses: settings.mealStatuses,
              onCompleteMealsTap: () =>
                  context.pushNamed(AppRoutes.familySubscriptionMembers),
            ),
          ],
          if (settings.warningTitle.isNotEmpty) ...[
            const SizedBox(height: Spacing.md),
            FamilySubscriptionWarningCard(settings: settings),
          ],
          const SizedBox(height: Spacing.xl),
        ],
      ),
    );
  }
}
