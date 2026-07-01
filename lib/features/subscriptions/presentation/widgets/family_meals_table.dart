import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/family_plan_entity.dart';

class FamilyMealsTable extends StatelessWidget {
  const FamilyMealsTable({super.key, required this.members});

  final List<FamilyMemberEntity> members;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final columns = [
      l10n.family_table_member,
      l10n.family_table_breakfast,
      l10n.family_table_lunch,
      l10n.family_table_snack,
      l10n.family_table_dinner,
      l10n.family_table_meals_count,
    ];

    return Container(
      height: 129,
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFECEEED)),
      ),
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              const Icon(Icons.restaurant_rounded, size: 12),
              const SizedBox(width: 5),
              Text(
                l10n.family_meals_each_member,
                style: const TextStyle(
                  fontSize: 8.6,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _TableRow(cells: columns, isHeader: true),
          for (final member in members) _MemberTableRow(member: member),
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
    return Container(
      height: 20,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF4F6F5), width: 0.5)),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          _TableCell(text: member.name),
          for (final checked in member.mealChecks)
            Expanded(
              child: Icon(
                checked ? Icons.check_rounded : Icons.remove_rounded,
                color: const Color(0xFF0C6C3F),
                size: 11,
              ),
            ),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Color(member.badgeColorHex),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  member.mealsCount,
                  maxLines: 1,
                  style: TextStyle(
                    color: Color(member.badgeTextColorHex),
                    fontSize: 6.1,
                    fontWeight: FontWeight.w600,
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
        style: TextStyle(
          fontSize: isHeader ? 6.9 : 7.8,
          fontWeight: isHeader ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}
