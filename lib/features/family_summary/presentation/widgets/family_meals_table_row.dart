import 'package:flutter/material.dart';
import 'package:meal_meat_user/features/family_summary/presentation/widgets/family_meals_table_cell.dart';

class FamilyMealsTableRow extends StatelessWidget {
  const FamilyMealsTableRow({
    super.key,
    required this.cells,
    this.isHeader = false,
  });

  final List<String> cells;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: Row(
        children: cells
            .map((cell) => FamilyMealsTableCell(text: cell, isHeader: isHeader))
            .toList(),
      ),
    );
  }
}
