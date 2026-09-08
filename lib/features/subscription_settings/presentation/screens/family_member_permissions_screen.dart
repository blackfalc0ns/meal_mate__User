import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_subscription_settings_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_permissions_header.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_permissions_note.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_permissions_section_card.dart';

class FamilyMemberPermissionsScreen extends StatefulWidget {
  const FamilyMemberPermissionsScreen({super.key});

  @override
  State<FamilyMemberPermissionsScreen> createState() =>
      _FamilyMemberPermissionsScreenState();
}

class _FamilyMemberPermissionsScreenState
    extends State<FamilyMemberPermissionsScreen> {
  static const _dataSource = FamilySubscriptionSettingsFakeDataSource();
  late final _permissions = _dataSource.getMemberPermissions();
  late final List<List<bool>> _values = [
    for (final section in _permissions.sections)
      [for (final permission in section.permissions) permission.enabled],
  ];

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        titleWidget: Text(
          locale.family_member_permissions_title(_permissions.memberName),
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size15,
            color: color.onSurface,
          ),
        ),
        onBackPressed: () => Navigator.maybePop(context),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsetsDirectional.only(
                  start: Spacing.familyPermissionsHorizontalPadding,
                  end: Spacing.familyPermissionsHorizontalPadding,
                  top: Spacing.familyPermissionsHeaderTopGap,
                ),
                child: Column(
                  children: [
                    FamilyMemberPermissionsHeader(permissions: _permissions),
                    const SizedBox(height: Spacing.xs),
                    for (
                      int index = 0;
                      index < _permissions.sections.length;
                      index++
                    )
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FamilyMemberPermissionsSectionCard(
                            section: _permissions.sections[index],
                            values: _values[index],
                            onPermissionChanged: (permissionIndex, value) {
                              setState(() {
                                _values[index][permissionIndex] = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: Spacing.familyPermissionsSectionGap,
                          ),
                        ],
                      ),
                    SizedBox(height: Spacing.md),
                    FamilyMemberPermissionsNote(
                      note: locale.family_member_permissions_note,
                    ),
                    SizedBox(height: Spacing.md),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: Spacing.familyPermissionsHorizontalPadding,
                end: Spacing.familyPermissionsHorizontalPadding,
                top: Spacing.familyPermissionsSaveTopGap,
              ),
              child: AppButton.filled(
                text: locale.family_member_permissions_save,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        locale.family_member_permissions_save_success,
                        style: getMediumStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size12,
                          color: color.onPrimary,
                        ),
                      ),
                      backgroundColor: color.primary,
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  Navigator.maybePop(context);
                },
                height: Spacing.familyPermissionsSaveButtonHeight,
                borderRadius: Spacing.familyDayReviewButtonRadius,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color.tertiary, color.primary],
                ),
                textColor: color.onPrimary,
                fontSize: FontSize.size18,
                fontWeight: FontWeightManger.semiBold,
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
