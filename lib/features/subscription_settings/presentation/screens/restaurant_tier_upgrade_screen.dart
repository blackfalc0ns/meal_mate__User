import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/data/mapper/restaurant_tier_upgrade_mapper.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/subscription_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/restaurant_tier_upgrade_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/restaurant_tier_upgrade_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/restaurant_tier_upgrade_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_continue_button.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_current_subscription_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_option_card.dart';

class RestaurantTierUpgradeScreen extends StatefulWidget {
  const RestaurantTierUpgradeScreen({super.key, this.args});

  final RestaurantTierUpgradeArgs? args;

  @override
  State<RestaurantTierUpgradeScreen> createState() =>
      _RestaurantTierUpgradeScreenState();
}

class _RestaurantTierUpgradeScreenState
    extends State<RestaurantTierUpgradeScreen> {
  late final RestaurantTierUpgradeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<RestaurantTierUpgradeViewModel>();
    _viewModel.doIntent(
      LoadUpgradeOptionsEvent(subscriptionId: widget.args?.subscriptionId),
    );
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;

    return BlocProvider<RestaurantTierUpgradeViewModel>.value(
      value: _viewModel,
      child: BlocBuilder<RestaurantTierUpgradeViewModel,
          RestaurantTierUpgradeState>(
        builder: (context, state) {
          final title = state.uiData?.title ?? 'ترقية تصنيف المطاعم';

          if (state.isLoadingOptions) {
            return Scaffold(
              appBar: CustomAppBar(elevation: Spacing.zero, title: title),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (state.optionsFailure != null) {
            return Scaffold(
              appBar: CustomAppBar(elevation: Spacing.zero, title: title),
              body: ApiErrorWidget(
                exception: state.optionsFailure!.exception,
                onRetry: () => _viewModel.doIntent(
                  LoadUpgradeOptionsEvent(
                    subscriptionId: widget.args?.subscriptionId,
                  ),
                ),
              ),
            );
          }

          final optionsEntity = state.optionsEntity;
          final uiData = state.uiData;

          if (optionsEntity == null || uiData == null) {
            return Scaffold(
              appBar: CustomAppBar(elevation: Spacing.zero, title: title),
              body: EmptyStateWidget(
                title: title,
                description: state.errorMessage ??
                    'لا تتوفر خيارات ترقية للاشتراك الحالي حالياً',
                icon: Icons.star_border_rounded,
              ),
            );
          }

          if (!optionsEntity.canUpgrade) {
            return Scaffold(
              appBar: CustomAppBar(elevation: Spacing.zero, title: title),
              body: EmptyStateWidget(
                title: title,
                description: _unavailableReasonMessage(
                  optionsEntity.unavailableReason,
                ),
                icon: Icons.info_outline_rounded,
              ),
            );
          }

          final selectedOption = state.selectedOption;
          final canContinue = selectedOption != null && selectedOption.selectable;

          return Semantics(
            label: locale.nav_subscription,
            child: Scaffold(
              appBar: CustomAppBar(elevation: Spacing.zero, title: uiData.title),
              bottomNavigationBar: canContinue
                  ? RestaurantTierContinueButton(
                      text: _continueLabel(selectedOption),
                      onPressed: () => _navigateToConfirmation(
                        state,
                        selectedOption,
                      ),
                    )
                  : null,
              body: SafeArea(
                top: false,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.screenH,
                      ),
                      sliver: SliverList.list(
                        children: _selectionChildren(context, state, uiData),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _selectionChildren(
    BuildContext context,
    RestaurantTierUpgradeState state,
    RestaurantTierUpgradeEntity data,
  ) {
    final color = context.colorScheme;
    final optionsEntity = state.optionsEntity;
    if (optionsEntity == null) return const [];

    return [
      const SizedBox(height: Spacing.lg),
      RestaurantTierCurrentSubscriptionCard(data: data),
      const SizedBox(height: Spacing.xxl),
      Text(
        data.chooseTitle,
        style: getBoldStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size16,
          color: color.onSurface,
        ),
      ),
      const SizedBox(height: Spacing.base),
      Text(
        data.chooseSubtitle,
        style: getMediumStyle(
          fontFamily: FontConstant.alexandria,
          fontSize: FontSize.size12,
          color: color.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: Spacing.xxl),
      for (final option in optionsEntity.options) ...[
        _buildOptionCard(context, state, option, data),
        const SizedBox(height: Spacing.restaurantTierCardsGap),
      ],
      SizedBox(height: MediaQuery.paddingOf(context).bottom + Spacing.xxxl),
    ];
  }

  Widget _buildOptionCard(
    BuildContext context,
    RestaurantTierUpgradeState state,
    SubscriptionUpgradeOptionEntity option,
    RestaurantTierUpgradeEntity data,
  ) {
    final optionType = RestaurantTierUpgradeMapper.optionTypeForTier(
      option.targetTier,
      option.isCurrent,
    );
    final isSelected = state.selectedOption?.targetTier == option.targetTier;
    final isCurrent = option.isCurrent;

    final currency = option.currencyCode.isNotEmpty ? option.currencyCode : 'KWD';
    final currencyText = currency == 'KWD' ? 'د.ك' : currency;
    final priceText = option.isCurrent
        ? data.price
        : '${option.priceDifference.toStringAsFixed(3)} $currencyText';

    return RestaurantTierOptionCard(
      title: option.tierNameAr.isNotEmpty ? option.tierNameAr : option.targetTier,
      badgeAsset: RestaurantTierUpgradeMapper.badgeAssetForTier(option.targetTier),
      description: isCurrent
          ? 'كل تصنيف يضم مجموعة مختارة من المطاعم المميزة.'
          : 'يشمل كل مطاعم التصنيف الحالي + مطاعم إضافية',
      restaurantCount: '+${option.accessibleRestaurantCount}',
      titleColor: _titleColor(context, optionType),
      descriptionColor: _descriptionColor(context, optionType),
      countColor: _countColor(context, optionType),
      countBorderColor: _countBorderColor(context, optionType),
      background: _cardBackground(context, optionType),
      actionPanelColor: _actionPanelColor(context, optionType),
      actionPanelBorderColor: _actionPanelBorderColor(context, optionType),
      actionButtonColor: _actionButtonColor(context, optionType),
      actionButtonTextColor: _actionButtonTextColor(context, optionType),
      priceColor: _priceColor(context, optionType),
      actionText: isCurrent
          ? 'تصنيفك الحالي'
          : 'ترقية إلى ${option.tierNameAr.isNotEmpty ? option.tierNameAr : option.targetTier}',
      price: priceText,
      pricePeriod: data.pricePeriod,
      isCurrent: isCurrent,
      isSelected: isSelected,
      onTap: !option.selectable
          ? null
          : () {
              _viewModel.doIntent(SelectTierOptionEvent(option));
              _navigateToConfirmation(state, option);
            },
    );
  }

  String _continueLabel(SubscriptionUpgradeOptionEntity selectedOption) {
    final name = selectedOption.tierNameAr.isNotEmpty
        ? selectedOption.tierNameAr
        : selectedOption.targetTier;
    return 'متابعة الترقية إلى $name';
  }

  void _navigateToConfirmation(
    RestaurantTierUpgradeState state,
    SubscriptionUpgradeOptionEntity selectedOption,
  ) {
    if (state.optionsEntity == null) return;
    context.pushNamed(
      AppRoutes.restaurantTierUpgradeConfirmation,
      arguments: RestaurantTierUpgradeConfirmationArgs(
        subscriptionId: state.subscriptionId,
        selectedOption: selectedOption,
        optionsEntity: state.optionsEntity!,
        programName: state.programName,
        bundleName: state.bundleName,
      ),
    );
  }

  String _unavailableReasonMessage(String? code) {
    switch (code) {
      case 'upgrade_not_available_for_status':
        return 'الترقية متاحة فقط للاشتراكات النشطة (Active).';
      case 'already_elite':
        return 'أنت مشترك بالفعل في أعلى تصنيف مطاعم متاح.';
      case 'upgrade_request_pending':
        return 'يوجد طلب ترقية معلق قيد المتابعة حالياً.';
      case 'upgrade_no_remaining_days':
        return 'لا توجد أيام خدمة متبقية في الاشتراك الحالي لإجراء الترقية.';
      case 'pricing.unavailable':
        return 'خدمة التسعير غير متوفرة حالياً، يرجى المحاولة لاحقاً.';
      default:
        return 'الترقية غير متوفرة حالياً لهذا الاشتراك.';
    }
  }

  BoxDecoration _cardBackground(
    BuildContext context,
    RestaurantTierOptionType type,
  ) {
    final color = context.colorScheme;

    return BoxDecoration(
      color: type == RestaurantTierOptionType.current
          ? color.surface
          : type == RestaurantTierOptionType.plus
          ? color.primary
          : color.inverseSurface,
      gradient: type == RestaurantTierOptionType.plus
          ? LinearGradient(
              begin: AlignmentDirectional.topEnd,
              end: AlignmentDirectional.bottomStart,
              colors: [color.primary, color.primaryFixedDim],
            )
          : null,
      border: Border.all(
        color: type == RestaurantTierOptionType.max
            ? color.secondary
            : color.outlineVariant,
      ),
      borderRadius: BorderRadius.circular(Spacing.restaurantTierCardRadius),
      boxShadow: [
        BoxShadow(
          color: color.shadow.withValues(alpha: 0.08),
          blurRadius: Spacing.md,
          offset: const Offset(Spacing.zero, Spacing.xs),
        ),
      ],
    );
  }

  Color _titleColor(BuildContext context, RestaurantTierOptionType type) {
    final color = context.colorScheme;

    return type == RestaurantTierOptionType.max
        ? color.secondary
        : type == RestaurantTierOptionType.current
        ? color.primary
        : color.onPrimary;
  }

  Color _descriptionColor(BuildContext context, RestaurantTierOptionType type) {
    final color = context.colorScheme;

    return type == RestaurantTierOptionType.current
        ? color.onSurfaceVariant
        : color.onPrimary;
  }

  Color _countColor(BuildContext context, RestaurantTierOptionType type) {
    final color = context.colorScheme;

    return type == RestaurantTierOptionType.max
        ? color.secondary
        : color.primary;
  }

  Color _countBorderColor(BuildContext context, RestaurantTierOptionType type) {
    final color = context.colorScheme;

    return type == RestaurantTierOptionType.max
        ? color.secondary
        : color.primary;
  }

  Color _actionPanelColor(BuildContext context, RestaurantTierOptionType type) {
    final color = context.colorScheme;

    return type == RestaurantTierOptionType.max
        ? color.inverseSurface
        : color.primaryFixedDim;
  }

  Color _actionPanelBorderColor(
    BuildContext context,
    RestaurantTierOptionType type,
  ) {
    final color = context.colorScheme;

    return type == RestaurantTierOptionType.max
        ? color.secondary
        : color.primaryContainer;
  }

  Color _actionButtonColor(
    BuildContext context,
    RestaurantTierOptionType type,
  ) {
    final color = context.colorScheme;

    return type == RestaurantTierOptionType.max
        ? color.secondary
        : color.surface;
  }

  Color _actionButtonTextColor(
    BuildContext context,
    RestaurantTierOptionType type,
  ) {
    final color = context.colorScheme;

    return type == RestaurantTierOptionType.max
        ? color.onSecondary
        : color.primary;
  }

  Color _priceColor(BuildContext context, RestaurantTierOptionType type) {
    final color = context.colorScheme;

    return type == RestaurantTierOptionType.max
        ? color.secondary
        : color.onPrimary;
  }
}
