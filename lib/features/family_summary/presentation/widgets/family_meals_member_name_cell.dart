import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';

class FamilyMealsMemberNameCell extends StatelessWidget {
  const FamilyMealsMemberNameCell({super.key, required this.member});

  final FamilyPlanMemberUiModel member;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Expanded(
      child: Row(
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
