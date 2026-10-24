import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_wolt_modal_sheet.dart';
import 'package:meal_meat_user/features/customer_support/domain/entities/customer_support_entity.dart';

class CustomerIssueCategoryBottomSheet extends StatelessWidget {
  const CustomerIssueCategoryBottomSheet({
    super.key,
    required this.options,
    required this.selectedTypeCode,
    required this.onSelected,
  });

  final List<CustomerSupportOptionEntity> options;
  final String? selectedTypeCode;
  final ValueChanged<CustomerSupportOptionEntity> onSelected;

  static Future<void> show({
    required BuildContext context,
    required List<CustomerSupportOptionEntity> options,
    required String? selectedTypeCode,
    required ValueChanged<CustomerSupportOptionEntity> onSelected,
  }) {
    final locale = context.localization;

    return AppWoltModalSheet.show<void>(
      context: context,
      title: locale.customer_support_category_sheet_title,
      child: CustomerIssueCategoryBottomSheet(
        options: options,
        selectedTypeCode: selectedTypeCode,
        onSelected: onSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.base,
        vertical: Spacing.sm,
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(height: Spacing.xs),
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = option.value == selectedTypeCode;

          return InkWell(
            onTap: () {
              onSelected(option);
              Navigator.of(context).pop();
            },
            borderRadius: BorderRadius.circular(Spacing.radiusSm),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Spacing.md,
                vertical: Spacing.md,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? color.primary.withValues(alpha: 0.08)
                    : color.surface.withValues(alpha: 0),
                borderRadius: BorderRadius.circular(Spacing.radiusSm),
                border: Border.all(
                  color: isSelected
                      ? color.primary.withValues(alpha: 0.4)
                      : color.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getCategoryIcon(option.value),
                    size: Spacing.iconSm,
                    color: isSelected ? color.primary : color.onSurfaceVariant,
                  ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: Text(
                      option.label,
                      style: isSelected
                          ? getSemiBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size12,
                              color: color.primary,
                            )
                          : getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size12,
                              color: color.onSurface,
                            ),
                    ),
                  ),
                  Icon(
                    isSelected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked,
                    size: Spacing.iconSm,
                    color: isSelected ? color.primary : color.outlineVariant,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String typeCode) {
    final lower = typeCode.toLowerCase();
    if (lower.contains('food') || lower.contains('quality')) {
      return Icons.restaurant_menu_rounded;
    }
    if (lower.contains('missing') || lower.contains('item')) {
      return Icons.remove_shopping_cart_outlined;
    }
    if (lower.contains('package') || lower.contains('damaged')) {
      return Icons.inventory_2_outlined;
    }
    if (lower.contains('delay') || lower.contains('late')) {
      return Icons.schedule_rounded;
    }
    if (lower.contains('delivery') || lower.contains('not_delivered')) {
      return Icons.local_shipping_outlined;
    }
    if (lower.contains('payment') || lower.contains('pay')) {
      return Icons.payment_rounded;
    }
    if (lower.contains('subscription') || lower.contains('sub')) {
      return Icons.card_membership_rounded;
    }
    if (lower.contains('account') || lower.contains('profile')) {
      return Icons.person_outline_rounded;
    }
    return Icons.help_outline_rounded;
  }
}
