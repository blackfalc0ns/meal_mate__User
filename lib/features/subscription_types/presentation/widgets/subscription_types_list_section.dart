import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscription_types/domain/entities/subscription_type_entity.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/widgets/subscription_type_card.dart';

class SubscriptionTypesListSection extends StatelessWidget {
  const SubscriptionTypesListSection({
    super.key,
    required this.types,
    required this.selectedTypeIndex,
    required this.onSelectType,
  });

  final List<SubscriptionTypeEntity> types;
  final int? selectedTypeIndex;
  final ValueChanged<int> onSelectType;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    color.surface;
    locale.localeName;

    return Column(
      children: [
        for (var index = 0; index < types.length; index++) ...[
          SubscriptionTypeCard(
            type: types[index],
            title: _titleForType(context, types[index]),
            description: _descriptionForType(context, types[index]),
            features: _featuresForType(context, types[index]),
            icons: _iconsForType(types[index]),
            isSelected: selectedTypeIndex == index,
            onTap: types[index].isAvailable ? () => onSelectType(index) : null,
          ),
          if (index != types.length - 1) const SizedBox(height: Spacing.sm),
        ],
      ],
    );
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
    if (!type.isAvailable) {
      final disabledReason = type.disabledReason;
      if (disabledReason != null && disabledReason.isNotEmpty) {
        return disabledReason;
      }
    }

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
