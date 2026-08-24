import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';

class FamilyMealsTable extends StatelessWidget {
  const FamilyMealsTable({super.key, required this.members});

  final List<FamilyPlanMemberUiModel> members;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final color = context.colorScheme;
    final columns = [
      l10n.family_table_member,
      l10n.family_table_breakfast,
      l10n.family_table_lunch,
      l10n.family_table_snack,
      l10n.family_table_dinner,
      l10n.family_table_meals_count,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.xs,
        vertical: Spacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.restaurant_rounded,
                size: Spacing.iconSm,
                color: color.primary,
              ),
              const SizedBox(width: Spacing.xss),
              Text(
                l10n.family_meals_each_member,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xss),
          _TableRow(cells: columns, isHeader: true),
          for (final member in members) ...[
            const _TableDivider(),
            _MemberTableRow(member: member),
          ],
        ],
      ),
    );
  }
}

class _MemberTableRow extends StatelessWidget {
  const _MemberTableRow({required this.member});

  final FamilyPlanMemberUiModel member;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      height: 28,
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          _MemberNameCell(member: member),
          for (final checked in member.mealChecks)
            Expanded(
              child: Icon(
                checked ? Icons.check_rounded : Icons.remove_rounded,
                color: checked ? color.primary : color.onSurfaceVariant,
                size: 16,
              ),
            ),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.xss,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color:
                      member.badgeColor ??
                      color.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(Spacing.radiusXs),
                ),
                child: Text(
                  member.mealsCount,
                  maxLines: 1,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    color: member.badgeTextColor ?? color.primary,
                    fontSize: FontSize.size9,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableDivider extends StatelessWidget {
  const _TableDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: context.colorScheme.outlineVariant,
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.cells, this.isHeader = false});

  final List<String> cells;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        textDirection: TextDirection.rtl,
        children: cells
            .map((cell) => _TableCell(text: cell, isHeader: isHeader))
            .toList(),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({required this.text, this.isHeader = false});

  final String text;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Expanded(
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: isHeader
            ? getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onSurface,
              )
            : getMediumStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size8,
                color: color.onSurfaceVariant,
              ),
      ),
    );
  }
}

class _MemberNameCell extends StatelessWidget {
  const _MemberNameCell({required this.member});

  final FamilyPlanMemberUiModel member;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Expanded(
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipOval(
            child: member.imageAsset.isNotEmpty
                ? Image.asset(
                    member.imageAsset,
                    width: 14,
                    height: 14,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _fallbackAvatar(context),
                  )
                : _fallbackAvatar(context),
          ),
          const SizedBox(width: Spacing.xss),
          Flexible(
            child: Text(
              member.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size10,
                color: color.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackAvatar(BuildContext context) {
    final color = context.colorScheme;
    return Container(
      width: 14,
      height: 14,
      color: color.primary.withValues(alpha: 0.15),
      child: Icon(Icons.person_rounded, color: color.primary, size: 10),
    );
  }
}
