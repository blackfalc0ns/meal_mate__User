import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_management/shared/domain/entities/family_subscription_settings_entity.dart';
import 'package:meal_meat_user/features/family_management/member/presentation/widgets/family_member_permission_switch.dart';

class FamilyMemberPermissionRow extends StatelessWidget {
  const FamilyMemberPermissionRow({
    super.key,
    required this.permission,
    required this.value,
    required this.onChanged,
  });

  final FamilyMemberPermissionEntity permission;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return SizedBox(
      height: Spacing.familyPermissionsRowHeight,
      child: Row(
        children: [
          Expanded(
            child: Text(
              _permissionLabel(locale),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: color.onSurfaceVariant,
              ),
            ),
          ),
          const Spacer(),
          FamilyMemberPermissionSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }

  String _permissionLabel(AppLocalizations locale) {
    return switch (permission.type) {
      FamilyMemberPermissionType.chooseDailyMeals =>
        locale.family_member_permission_choose_daily_meals,
      FamilyMemberPermissionType.editMealsBeforeLock =>
        locale.family_member_permission_edit_meals_before_lock,
      FamilyMemberPermissionType.viewMealDetails =>
        locale.family_member_permission_view_meal_details,
      FamilyMemberPermissionType.viewNutritionProgram =>
        locale.family_member_permission_view_nutrition_program,
      FamilyMemberPermissionType.changeNutritionProgram =>
        locale.family_member_permission_change_nutrition_program,
      FamilyMemberPermissionType.editMealsAndDaysCount =>
        locale.family_member_permission_edit_meals_and_days_count,
      FamilyMemberPermissionType.editAddress =>
        locale.family_member_permission_edit_address,
      FamilyMemberPermissionType.replaceMeal =>
        locale.family_member_permission_replace_meal,
      FamilyMemberPermissionType.viewReportsAndPayments =>
        locale.family_member_permission_view_reports_and_payments,
      FamilyMemberPermissionType.leaveFamilyPlan =>
        locale.family_member_permission_leave_family_plan,
    };
  }
}
