import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/features/subscription_programs/domain/entities/subscription_type_entity.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_types_event.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_types_state.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/manager/subscription_types_view_model.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_type_card.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_type_notice.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_types_loading_skeleton.dart';
import 'package:meal_meat_user/shared/widgets/app_logo.dart';

class SubscriptionsScreen extends StatefulWidget {
  const SubscriptionsScreen({super.key, this.showBottomSpace = false});

  final bool showBottomSpace;

  @override
  State<SubscriptionsScreen> createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  int? _selectedTypeIndex;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<SubscriptionTypesViewModel>(
      create: (_) =>
          getIt<SubscriptionTypesViewModel>()
            ..doIntent(const GetSubscriptionTypesEvent()),
      child: Semantics(
        label: locale.nav_subscription,
        child: Scaffold(
          backgroundColor: color.surface,
          body: SafeArea(
            bottom: false,
            child:
                BlocBuilder<SubscriptionTypesViewModel, SubscriptionTypesState>(
                  builder: (context, state) {
                    if (state.isLoading && state.types.isEmpty) {
                      return SubscriptionTypesLoadingSkeleton(
                        showBottomSpace: widget.showBottomSpace,
                      );
                    }

                    if (state.failure != null && state.types.isEmpty) {
                      return ApiErrorWidget(
                        exception: state.failure!.exception,
                        onRetry: () => context
                            .read<SubscriptionTypesViewModel>()
                            .doIntent(const GetSubscriptionTypesEvent()),
                      );
                    }

                    if (state.isSuccess && state.types.isEmpty) {
                      return EmptyStateWidget(
                        title: locale.subscription_type_title,
                        description: locale.subscription_type_subtitle,
                        icon: Icons.subscriptions_rounded,
                      );
                    }

                    return _buildSubscriptionTypesContent(context, state.types);
                  },
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionTypesContent(
    BuildContext context,
    List<SubscriptionTypeEntity> types,
  ) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            Assets.subscriptionTypeBackground,
            fit: BoxFit.cover,
            semanticLabel: locale.nav_subscription,
          ),
        ),
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                left: Spacing.screenH,
                right: Spacing.screenH,
                top: Spacing.lg,
                bottom: widget.showBottomSpace
                    ? Spacing.subscriptionProgramsBottomSpace
                    : Spacing.xl,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed([
                  const Center(
                    child: AppLogo(
                      size: Spacing.subscriptionTypeLogoHeight,
                      alignment: CrossAxisAlignment.center,
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Spacing.subscriptionProgramCardRadius,
                    ),
                    child: AspectRatio(
                      aspectRatio:
                          Spacing.subscriptionTypeHeroWidth /
                          Spacing.subscriptionTypeHeroHeight,
                      child: Image.asset(
                        Assets.subscriptionTypeHero,
                        fit: BoxFit.cover,
                        semanticLabel: locale.subscription_type_hero_label,
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    locale.subscription_type_title,
                    textAlign: TextAlign.center,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size20,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    locale.subscription_type_subtitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size11,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
                  ..._buildTypeCards(context, types),
                  const SizedBox(height: Spacing.base),
                  SubscriptionTypeNotice(
                    message: locale.subscription_type_notice_label,
                  ),
                  const SizedBox(height: Spacing.md),
                  AppButton.filled(
                    text: locale.family_next_program,
                    onPressed: _selectedTypeIndex == null
                        ? null
                        : () => _openSelectedSubscription(types),
                    borderRadius: Spacing.radiusPill,
                    textColor: color.onPrimary,
                    fontSize: FontSize.size12,
                    iconWidget: Icon(
                      Icons.chevron_right_rounded,
                      color: color.onPrimary,
                      size: Spacing.iconMd,
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildTypeCards(
    BuildContext context,
    List<SubscriptionTypeEntity> types,
  ) {
    final children = <Widget>[];

    for (var index = 0; index < types.length; index++) {
      final type = types[index];
      children.add(
        SubscriptionTypeCard(
          type: type,
          title: _titleForType(context, type),
          description: _descriptionForType(context, type),
          features: _featuresForType(context, type),
          icons: _iconsForType(type),
          isSelected: _selectedTypeIndex == index,
          onTap: () => _selectSubscriptionType(index),
        ),
      );

      if (index != types.length - 1) {
        children.add(const SizedBox(height: Spacing.sm));
      }
    }

    return children;
  }

  void _selectSubscriptionType(int index) {
    setState(() => _selectedTypeIndex = index);
  }

  void _openSelectedSubscription(List<SubscriptionTypeEntity> types) {
    final selectedTypeIndex = _selectedTypeIndex;
    if (selectedTypeIndex == null || selectedTypeIndex >= types.length) return;

    if (!types[selectedTypeIndex].isFamily) {
      context.pushNamed(AppRoutes.subscriptionProgramSelection);
      return;
    }

    context.pushNamed(AppRoutes.familyPlanDetails);
  }

  String _titleForType(BuildContext context, SubscriptionTypeEntity type) {
    final locale = context.localization;
    final title = type.name(locale.localeName);
    if (title.isNotEmpty) return title;

    return type.isFamily
        ? locale.subscription_type_family_label
        : locale.subscription_type_individual_label;
  }

  String _descriptionForType(
    BuildContext context,
    SubscriptionTypeEntity type,
  ) {
    final locale = context.localization;
    final description = type.description(locale.localeName);
    if (description.isNotEmpty) return description;

    return type.isFamily
        ? locale.subscription_type_family_description
        : locale.subscription_type_individual_description;
  }

  List<String> _featuresForType(
    BuildContext context,
    SubscriptionTypeEntity type,
  ) {
    final locale = context.localization;

    if (type.isFamily) {
      return [
        locale.subscription_type_family_management,
        locale.subscription_type_family_customization,
        locale.subscription_type_family_members,
      ];
    }

    return [
      locale.subscription_type_individual_customization,
      locale.subscription_type_individual_meal_flexibility,
      locale.subscription_type_individual_restaurants,
    ];
  }

  List<IconData> _iconsForType(SubscriptionTypeEntity type) {
    if (type.isFamily) {
      return const [
        Icons.groups_2_rounded,
        Icons.person_rounded,
        Icons.groups_rounded,
      ];
    }

    return const [
      Icons.track_changes_rounded,
      Icons.calendar_month_rounded,
      Icons.store_rounded,
    ];
  }
}
