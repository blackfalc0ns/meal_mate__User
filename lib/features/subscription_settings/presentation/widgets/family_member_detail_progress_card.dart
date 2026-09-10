import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_member_calendar_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/family_subscription_settings_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_header_icon.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/family_member_detail_section_card.dart';

class FamilyMemberDetailProgressCard extends StatelessWidget {
  const FamilyMemberDetailProgressCard({super.key, required this.member});

  final FamilyMemberDetailEntity member;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return FamilyMemberDetailSectionCard(
      height: Spacing.familyMemberDetailProgressCardHeight,
      padding: const EdgeInsetsDirectional.only(
        start: Spacing.xl,
        top: Spacing.md,
        end: Spacing.md,
        bottom: Spacing.sm,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const FamilyMemberDetailHeaderIcon(icon: Icons.bar_chart_rounded),
              const SizedBox(width: Spacing.sm),
              Text(
                member.selectionTitle,
                locale: Locale(locale.localeName),
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size11,
                  color: color.onSurface,
                ),
              ),
            ],
          ),
          Expanded(
            child: Row(
              children: [
                SizedBox.square(
                  dimension: Spacing.familyMemberDetailProgressRingSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.square(
                        dimension: Spacing.familyMemberDetailProgressRingSize,
                        child: CircularProgressIndicator(
                          value: member.progress,
                          strokeWidth: Spacing.sm,
                          backgroundColor: color.outlineVariant,
                          color: color.primary,
                          strokeCap: StrokeCap.butt,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            member.completedValue,
                            locale: Locale(locale.localeName),
                            style: getBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size15,
                              color: color.onSurface,
                            ),
                          ),
                          Text(
                            member.completedLabel,
                            locale: Locale(locale.localeName),
                            style: getRegularStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size9,
                              color: color.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: Spacing.familyMemberDetailCalendarButtonWidth,
                  height: Spacing.familyMemberDetailCalendarButtonHeight,
                  child: OutlinedButton(
                    onPressed: () {
                      if (member.subscriptionId == null ||
                          member.subscriptionId!.isEmpty) {
                        CustomSnackbar.showError(
                          context: context,
                          message: locale.family_member_no_active_subscription,
                        );
                        return;
                      }
                      Navigator.of(context).pushNamed(
                        AppRoutes.familyMemberDailyMeals,
                        arguments: FamilyMemberCalendarArgs(
                          memberId: member.memberId,
                          displayName: member.name,
                          subscriptionId: member.subscriptionId,
                          isManager: member.isManager,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: color.primaryContainer.withValues(
                        alpha: 0.22,
                      ),
                      foregroundColor: color.primary,
                      side: BorderSide(color: color.outlineVariant),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Spacing.familyMemberDetailCalendarButtonRadius,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                      ),
                    ),
                    child: Text(
                      member.showCalendarLabel,
                      locale: Locale(locale.localeName),
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size10,
                        color: color.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
