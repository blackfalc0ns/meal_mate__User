import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_plans/domain/entities/family_plan_entity.dart';

class FamilyMealsTable extends StatelessWidget {
  const FamilyMealsTable({super.key, required this.members});

  final List<FamilyMemberEntity> members;

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
      constraints: const BoxConstraints(
        minHeight: Spacing.familyMealsMinHeight,
      ),
      padding: const EdgeInsets.fromLTRB(
        Spacing.md,
        Spacing.xss,
        Spacing.md,
        Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
        border: Border.all(color: color.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              const Icon(Icons.restaurant_rounded, size: 12),
              const SizedBox(width: Spacing.xss),
              Text(
                l10n.family_meals_each_member,
                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size11,
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

  final FamilyMemberEntity member;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      height: 26,
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          _MemberNameCell(member: member),
          for (final checked in member.mealChecks)
            Expanded(
              child: Icon(
                checked ? Icons.check_rounded : Icons.remove_rounded,
                color: color.primary,
                size: 15,
              ),
            ),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.xss,
                  vertical: Spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: member.badgeColor,
                  borderRadius: BorderRadius.circular(Spacing.radiusXs),
                ),
                child: Text(
                  member.mealsCount,
                  maxLines: 1,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    color: member.badgeTextColor,
                    fontSize: FontSize.size8,
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
      height: 17,
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
    return Expanded(
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: isHeader
            ? getSemiBoldStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size9,
              )
            : getMediumStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size8,
              ),
      ),
    );
  }
}

class _MemberNameCell extends StatelessWidget {
  const _MemberNameCell({required this.member});

  final FamilyMemberEntity member;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 6,
            backgroundImage: AssetImage(member.imageAsset),
          ),
          const SizedBox(width: Spacing.xss),
          Flexible(
            child: Text(
              member.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
