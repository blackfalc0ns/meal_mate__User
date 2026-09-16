import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_relationship_entity.dart';
import 'package:meal_meat_user/features/family_subscription_setup/presentation/models/family_relationship_options.dart';

class FamilyRelationshipPickerSheet extends StatelessWidget {
  const FamilyRelationshipPickerSheet({
    super.key,
    required this.relationships,
    this.selectedCode,
  });

  final List<FamilyRelationshipEntity> relationships;
  final String? selectedCode;

  static Future<FamilyRelationshipEntity?> show({
    required BuildContext context,
    required List<FamilyRelationshipEntity> relationships,
    String? selectedCode,
    bool includeSelectedRelationship = false,
  }) {
    final options = buildFamilyRelationshipOptions(
      relationships,
      selectedCode: selectedCode,
      includeSelectedRelationship: includeSelectedRelationship,
    );
    if (options.isEmpty) return Future.value(null);
    final color = context.colorScheme;
    return showModalBottomSheet<FamilyRelationshipEntity>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: color.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Spacing.bottomSheetRadius),
        ),
      ),
      builder: (_) => FamilyRelationshipPickerSheet(
        relationships: options,
        selectedCode: selectedCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.base,
          vertical: Spacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: Spacing.xxxl,
                height: Spacing.xs,
                decoration: BoxDecoration(
                  color: color.outlineVariant,
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                ),
              ),
            ),
            const SizedBox(height: Spacing.base),
            Text(
              locale.family_relation,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size18,
                color: color.primary,
              ),
            ),
            const SizedBox(height: Spacing.md),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: relationships.length,
                separatorBuilder: (_, _) => Divider(
                  height: Spacing.border,
                  thickness: Spacing.border,
                  color: color.outlineVariant,
                ),
                itemBuilder: (context, index) {
                  final relationship = relationships[index];
                  final isSelected = relationship.code == selectedCode;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    selected: isSelected,
                    title: Text(
                      relationship.name(locale.localeName),
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size16,
                        color: color.onSurface,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_rounded,
                            color: color.primary,
                            size: Spacing.iconMd,
                          )
                        : null,
                    onTap: () => Navigator.of(context).pop(relationship),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
