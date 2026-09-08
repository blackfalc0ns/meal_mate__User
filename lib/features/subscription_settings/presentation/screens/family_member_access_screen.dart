import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/data/family_subscription_settings_fake_data_source.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_access_credentials_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_access_deactivate_dialog.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_access_header.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_access_independent_card.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_access_permissions_tile.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_access_status_card.dart';

class FamilyMemberAccessScreen extends StatefulWidget {
  const FamilyMemberAccessScreen({super.key});

  @override
  State<FamilyMemberAccessScreen> createState() =>
      _FamilyMemberAccessScreenState();
}

class _FamilyMemberAccessScreenState extends State<FamilyMemberAccessScreen> {
  static const _dataSource = FamilySubscriptionSettingsFakeDataSource();
  late final FamilyMemberAccessEntity _member = _dataSource.getMemberAccess();

  late bool _hasIndependentAccount = _member.hasIndependentAccount;
  late FamilyMemberAccessStatus _status = _member.status;

  void _showDeactivateDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => FamilyMemberAccessDeactivateDialog(
        memberName: _member.memberName,
        onConfirm: () {
          setState(() {
            _status = FamilyMemberAccessStatus.paused;
          });
        },
      ),
    );
  }

  void _onSave() {
    final locale = context.localization;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          locale.family_member_access_save_success,
          style: getMediumStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size12,
            color: context.colorScheme.onPrimary,
          ),
        ),
        backgroundColor: context.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        titleWidget: Text(
          locale.family_member_access_title(_member.memberName),
          style: getBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size15,
            color: color.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.tune_rounded,
              color: color.primary,
              size: Spacing.iconMd,
            ),
            tooltip: locale.family_member_access_permissions_tile_title,
            onPressed: () => Navigator.of(
              context,
            ).pushNamed(AppRoutes.familyMemberPermissions),
          ),
        ],
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
                  bottom: Spacing.md,
                ),
                child: Column(
                  children: [
                    FamilyMemberAccessHeader(
                      member: FamilyMemberAccessEntity(
                        memberName: _member.memberName,
                        memberImageAsset: _member.memberImageAsset,
                        status: _status,
                        lastLogin: _member.lastLogin,
                        email: _member.email,
                        hasIndependentAccount: _hasIndependentAccount,
                      ),
                    ),
                    const SizedBox(height: Spacing.md),
                    const FamilyMemberAccessPermissionsTile(),
                    const SizedBox(height: Spacing.md),
                    FamilyMemberAccessCredentialsCard(
                      member: _member,
                    ),
                    const SizedBox(height: Spacing.md),
                    FamilyMemberAccessIndependentCard(
                      memberName: _member.memberName,
                      hasIndependentAccount: _hasIndependentAccount,
                      onChanged: (val) {
                        setState(() {
                          _hasIndependentAccount = val;
                        });
                      },
                    ),
                    const SizedBox(height: Spacing.md),
                    FamilyMemberAccessStatusCard(
                      memberName: _member.memberName,
                      currentStatus: _status,
                      onStatusChanged: (newStatus) {
                        setState(() {
                          _status = newStatus;
                        });
                      },
                      onDeactivate: _showDeactivateDialog,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: Spacing.familyPermissionsHorizontalPadding,
                end: Spacing.familyPermissionsHorizontalPadding,
                top: Spacing.familyPermissionsSaveTopGap,
                bottom: Spacing.md,
              ),
              child: AppButton.filled(
                text: locale.family_member_access_save_button,
                onPressed: _onSave,
                height: Spacing.familyPermissionsSaveButtonHeight,
                borderRadius: Spacing.familyDayReviewButtonRadius,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color.tertiary, color.primary],
                ),
                textColor: color.onPrimary,
                fontSize: FontSize.size16,
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
