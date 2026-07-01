import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyAddMemberDialog extends StatefulWidget {
  const FamilyAddMemberDialog({super.key});

  static Future<void> show(BuildContext context) {
    final color = context.colorScheme;

    return showDialog<void>(
      context: context,
      barrierColor: color.scrim,
      builder: (_) => const FamilyAddMemberDialog(),
    );
  }

  @override
  State<FamilyAddMemberDialog> createState() => _FamilyAddMemberDialogState();
}

class _FamilyAddMemberDialogState extends State<FamilyAddMemberDialog> {
  int _activityIndex = 0;
  int _mealsIndex = 1;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final color = context.colorScheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      backgroundColor: color.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.radiusXl),
      ),
      child: SizedBox(
        height: 593,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Spacing.md,
            Spacing.base,
            Spacing.md,
            Spacing.md,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(Spacing.radiusPill),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: color.surfaceContainerHighest,
                      child: Icon(
                        Icons.close_rounded,
                        size: 14,
                        color: color.onSurface,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              Icon(
                Icons.person_add_alt_1_rounded,
                color: color.primary,
                size: 54,
              ),
              const SizedBox(height: Spacing.xss),
              Text(
                l10n.family_add_member,
                style: getBoldStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  color: color.onSurface,
                  fontSize: FontSize.size17,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                l10n.family_add_member_dialog_subtitle,
                textAlign: TextAlign.center,
                style: getRegularStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  color: color.onSurfaceVariant,
                  fontSize: FontSize.size10,
                ),
              ),
              const SizedBox(height: Spacing.base),
              _LabeledField(
                icon: Icons.person_outline_rounded,
                label: l10n.family_full_name,
                hint: l10n.family_full_name_hint,
              ),
              const SizedBox(height: Spacing.sm),
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Expanded(
                    child: _LabeledField(
                      icon: Icons.groups_2_outlined,
                      label: l10n.family_relation,
                      hint: l10n.family_relation_hint,
                      compact: true,
                      trailing: Icons.keyboard_arrow_down_rounded,
                    ),
                  ),
                  const SizedBox(width: Spacing.lg),
                  Expanded(
                    child: _LabeledField(
                      icon: Icons.calendar_month_outlined,
                      label: l10n.family_age,
                      hint: l10n.family_age_hint,
                      compact: true,
                      suffix: l10n.family_year,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.sm),
              _LabeledField(
                icon: Icons.track_changes_rounded,
                label: l10n.family_nutrition_goal,
                hint: l10n.family_nutrition_goal_hint,
                trailing: Icons.keyboard_arrow_down_rounded,
              ),
              const SizedBox(height: Spacing.sm),
              _ChoiceSection(
                label: l10n.family_activity_level,
                icon: Icons.directions_walk_rounded,
                choices: [
                  l10n.family_activity_low,
                  l10n.family_activity_medium,
                  l10n.family_activity_high,
                ],
                selectedIndex: _activityIndex,
                onChanged: (index) => setState(() => _activityIndex = index),
              ),
              const SizedBox(height: Spacing.sm),
              _ChoiceSection(
                label: l10n.family_daily_meals_count,
                icon: Icons.restaurant_rounded,
                choices: [
                  l10n.family_meals_3,
                  l10n.family_meals_4,
                  l10n.family_meals_5,
                ],
                selectedIndex: _mealsIndex,
                onChanged: (index) => setState(() => _mealsIndex = index),
              ),
              const SizedBox(height: Spacing.md),
              _InfoHint(),
              const Spacer(),
              SizedBox(
                height: Spacing.compactButtonHeight,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.family_add_member_button),
                ),
              ),
              const SizedBox(height: Spacing.xss),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  l10n.family_cancel,
                  style: getRegularStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    color: color.onSurface,
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

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.icon,
    required this.label,
    required this.hint,
    this.compact = false,
    this.trailing,
    this.suffix,
  });

  final IconData icon;
  final String label;
  final String hint;
  final bool compact;
  final IconData? trailing;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Icon(icon, size: 12, color: color.onSurface),
            const SizedBox(width: Spacing.xs),
            Text(
              label,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                color: color.onSurface,
                fontSize: FontSize.size10,
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.xss),
        SizedBox(
          height: 32,
          child: TextField(
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: trailing == null ? null : Icon(trailing, size: 18),
              prefixIcon: suffix == null
                  ? null
                  : Container(
                      width: 37,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(Spacing.border),
                      decoration: BoxDecoration(
                        color: color.outlineVariant,
                        borderRadius: const BorderRadiusDirectional.horizontal(
                          start: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        suffix!,
                        style: getRegularStyle(
                          fontFamily: FontConstant.ibmPlexSansArabic,
                          color: color.onSurface,
                          fontSize: FontSize.size10,
                        ),
                      ),
                    ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: Spacing.md,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChoiceSection extends StatelessWidget {
  const _ChoiceSection({
    required this.label,
    required this.icon,
    required this.choices,
    required this.selectedIndex,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final List<String> choices;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Icon(icon, size: 12, color: color.onSurface),
            const SizedBox(width: Spacing.xs),
            Text(
              label,
              style: getSemiBoldStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                color: color.onSurface,
                fontSize: FontSize.size10,
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.xss),
        Row(
          textDirection: TextDirection.rtl,
          children: List.generate(choices.length, (index) {
            final selected = index == selectedIndex;
            return Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: index == 0 ? 0 : Spacing.sm,
                ),
                child: OutlinedButton(
                  onPressed: () => onChanged(index),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 32),
                    side: BorderSide(
                      color: selected ? color.primary : color.outlineVariant,
                    ),
                    backgroundColor: selected
                        ? color.surfaceContainerHighest
                        : color.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Spacing.radiusSm),
                    ),
                  ),
                  child: Text(
                    choices[index],
                    style: getRegularStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      color: color.onSurface,
                      fontSize: FontSize.size10,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _InfoHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final color = context.colorScheme;

    return Container(
      height: 43,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
      decoration: BoxDecoration(
        color: color.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Spacing.radiusSm),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            size: 24,
            color: color.onSurface,
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  l10n.family_info,
                  style: getSemiBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    color: color.onSurface,
                    fontSize: FontSize.size10,
                  ),
                ),
                Text(
                  l10n.family_info_message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getRegularStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    color: color.onSurfaceVariant,
                    fontSize: FontSize.size10,
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
