import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_types/domain/entities/subscription_type_entity.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/manager/subscription_types_state.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/widgets/subscription_types_action_section.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/widgets/subscription_types_header_section.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/widgets/subscription_types_list_section.dart';

class SubscriptionTypesContent extends StatelessWidget {
  const SubscriptionTypesContent({
    super.key,
    required this.state,
    required this.showBottomSpace,
    required this.selectedTypeIndex,
    required this.onSelectType,
    required this.onOpenSelectedType,
    this.scrollController,
  });

  final SubscriptionTypesState state;
  final bool showBottomSpace;
  final int? selectedTypeIndex;
  final ValueChanged<int> onSelectType;
  final VoidCallback onOpenSelectedType;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final selectedType = _selectedType(state.types);

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
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(
                top: Spacing.lg,
                bottom: showBottomSpace
                    ? Spacing.subscriptionProgramsBottomSpace
                    : Spacing.xl,
              ).add(const EdgeInsets.symmetric(horizontal: Spacing.screenH)),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed([
                  const SubscriptionTypesHeaderSection(),
                  const SizedBox(height: Spacing.sm),
                  SubscriptionTypesListSection(
                    types: state.types,
                    selectedTypeIndex: selectedTypeIndex,
                    onSelectType: onSelectType,
                  ),
                  const SizedBox(height: Spacing.base),
                  SubscriptionTypesActionSection(
                    selectedType: selectedType,
                    isLoading: state.isConversionLoading,
                    onPressed: onOpenSelectedType,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  SubscriptionTypeEntity? _selectedType(List<SubscriptionTypeEntity> types) {
    final index = selectedTypeIndex;
    if (index == null || index < 0 || index >= types.length) return null;
    return types[index];
  }
}
