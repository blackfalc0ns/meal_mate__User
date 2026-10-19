import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyMemberPermissionsNote extends StatelessWidget {
  const FamilyMemberPermissionsNote({super.key, required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return SizedBox(
      height: Spacing.familyPermissionsNoteHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.tertiaryContainer,
          borderRadius: BorderRadius.circular(
            Spacing.familyPermissionsNoteRadius,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
          child: Row(
            children: [
              Icon(
                Icons.verified_user_rounded,
                size: Spacing.familyPermissionsNoteIconSize,
                color: color.primary,
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Text(
                  note,

                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
