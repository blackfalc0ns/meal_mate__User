import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyMemberDetailSectionCard extends StatelessWidget {
  const FamilyMemberDetailSectionCard({
    super.key,
    required this.height,
    required this.child,
    this.padding = const EdgeInsets.all(Spacing.familyMemberDetailCardPadding),
  });

  final double height;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(
          Spacing.familyMemberDetailCardRadius,
        ),
        border: Border.all(
          color: color.outlineVariant,
          width: Spacing.familyMemberDetailCardBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: color.shadow.withValues(alpha: 0.1),
            offset: const Offset(Spacing.zero, Spacing.xs),
            blurRadius: Spacing.xs,
          ),
        ],
      ),
      child: Semantics(label: locale.localeName, child: child),
    );
  }
}
