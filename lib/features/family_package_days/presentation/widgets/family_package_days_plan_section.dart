import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tier_ui_model.dart';
import 'package:meal_meat_user/core/widget/restaurant_tier/restaurant_package_tiers_section.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_event.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_state.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/manager/family_package_days_view_model.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_days_browse_restaurants_section.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_package_tiers_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_payment_note_card.dart';
import 'package:meal_meat_user/features/family_package_days/presentation/widgets/family_tier_price.dart';
import 'package:meal_meat_user/features/family_programs/presentation/widgets/family_program_actions.dart';

class FamilyPackageDaysPlanSection extends StatelessWidget {
  const FamilyPackageDaysPlanSection({
    super.key,
    this.state,
    required this.onNextPressed,
    this.programId,
    this.showActions = true,
  });

  final FamilyPackageDaysState? state;
  final VoidCallback onNextPressed;
  final String? programId;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    if (state != null) {
      return _buildContent(context, state!);
    }
    return BlocBuilder<FamilyPackageDaysViewModel, FamilyPackageDaysState>(
      buildWhen: (previous, current) =>
          previous.isMemberChanging != current.isMemberChanging ||
          (previous.isTiersLoading != current.isTiersLoading &&
              current.tiers.isEmpty) ||
          previous.tiersFailure != current.tiersFailure ||
          !sameFamilyTierCardsExceptPrice(
            previous.tiers.map((tier) => tier.toTierUiModel('en')).toList(),
            current.tiers.map((tier) => tier.toTierUiModel('en')).toList(),
          ) ||
          previous.selectedTierIndex != current.selectedTierIndex ||
          previous.isRestaurantsView != current.isRestaurantsView ||
          previous.browseRestaurants != current.browseRestaurants ||
          previous.isBrowseRestaurantsLoading !=
              current.isBrowseRestaurantsLoading ||
          previous.browseRestaurantsFailure !=
              current.browseRestaurantsFailure ||
          previous.isSelectedManagerPlanLocked !=
              current.isSelectedManagerPlanLocked,
      builder: _buildContent,
    );
  }

  Widget _buildContent(BuildContext context, FamilyPackageDaysState state) {
    final locale = context.localization;

    if (state.isRestaurantsView) {
      return FamilyPackageDaysBrowseRestaurantsSection(
        state: state,
        programId: programId,
      );
    }

    final displayedTiers = state.tiers
        .map(
          (tier) => tier.toTierUiModel(
            locale.localeName,
            isPriceLoading: state.isTiersLoading,
          ),
        )
        .toList();

    return Column(
      children: [
        if (state.tiersFailure != null && state.tiers.isEmpty)
          InlineApiErrorWidget(
            failure: state.tiersFailure!,
            onRetry: () => context.read<FamilyPackageDaysViewModel>().doIntent(
              const RetryFamilyTiersEvent(),
            ),
          )
        else if (state.isMemberChanging ||
            (state.isTiersLoading && state.tiers.isEmpty))
          const FamilyPackageTiersLoadingSkeleton()
        else
          _buildAnimatedTiers(context, state, displayedTiers),
        const SizedBox(height: Spacing.lg),
        const FamilyPaymentNoteCard(),
        if (showActions) ...[
          const SizedBox(height: Spacing.md),
          FamilyProgramActions(
            nextText: locale.family_next_payment,
            nextIcon: Icons.credit_card_rounded,
            onNextPressed: onNextPressed,
          ),
        ],
      ],
    );
  }

  Widget _buildAnimatedTiers(
    BuildContext context,
    FamilyPackageDaysState state,
    List<RestaurantPackageTierUiModel> displayedTiers,
  ) {
    final tiersSection = AbsorbPointer(
      absorbing: state.isSelectedManagerPlanLocked,
      child: RestaurantPackageTiersSection(
        packages: displayedTiers,
        selectedIndex: state.selectedTierIndex,
        onSelected: (index) => context
            .read<FamilyPackageDaysViewModel>()
            .doIntent(SelectFamilyTierEvent(index)),
        onBrowseRestaurants: (index) => context
            .read<FamilyPackageDaysViewModel>()
            .doIntent(BrowseFamilyTierRestaurantsEvent(index)),
        priceBuilder: this.state == null
            ? (index, priceColor, subtitleColor, dividerColor) =>
                  FamilyTierPrice(
                    index: index,
                    priceColor: priceColor,
                    subtitleColor: subtitleColor,
                    dividerColor: dividerColor,
                  )
            : null,
      ),
    );

    if (context.areAnimationsDisabled) {
      return tiersSection;
    }

    return tiersSection
        .animate(key: ValueKey('member-${state.selectedMemberIndex}-tiers'))
        .fadeIn(duration: 250.ms, curve: Curves.easeOut);
  }
}

bool sameFamilyTierCardsExceptPrice(
  List<RestaurantPackageTierUiModel> previous,
  List<RestaurantPackageTierUiModel> current,
) {
  if (previous.length != current.length) return false;
  for (var i = 0; i < previous.length; i++) {
    final a = previous[i];
    final b = current[i];
    if (a.id != b.id ||
        a.title != b.title ||
        a.subtitle != b.subtitle ||
        a.iconName != b.iconName ||
        a.logoUrl != b.logoUrl ||
        a.restaurantCount != b.restaurantCount ||
        !listEquals(a.restaurantLogoUrls, b.restaurantLogoUrls) ||
        a.isPopular != b.isPopular ||
        a.canSelect != b.canSelect ||
        a.isAvailable != b.isAvailable ||
        a.disabledReason != b.disabledReason) {
      return false;
    }
  }
  return true;
}
