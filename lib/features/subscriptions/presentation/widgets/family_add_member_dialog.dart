import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyAddMemberDialog extends StatefulWidget {
  const FamilyAddMemberDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierColor: const Color(0x916E6868),
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
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
      child: SizedBox(
        height: 593,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 15, 14, 12),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(99),
                    child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Color(0xFFE6E6E6),
                      child: Icon(Icons.close_rounded, size: 14),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const Icon(
                Icons.person_add_alt_1_rounded,
                color: Color(0xFF0C6C3F),
                size: 54,
              ),
              const SizedBox(height: 6),
              Text(
                l10n.family_add_member,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.family_add_member_dialog_subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF5A5C62), fontSize: 10),
              ),
              const SizedBox(height: 17),
              _LabeledField(
                icon: Icons.person_outline_rounded,
                label: l10n.family_full_name,
                hint: l10n.family_full_name_hint,
              ),
              const SizedBox(height: 10),
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
                  const SizedBox(width: 20),
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
              const SizedBox(height: 10),
              _LabeledField(
                icon: Icons.track_changes_rounded,
                label: l10n.family_nutrition_goal,
                hint: l10n.family_nutrition_goal_hint,
                trailing: Icons.keyboard_arrow_down_rounded,
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 12),
              _InfoHint(),
              const Spacer(),
              SizedBox(
                height: 39,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.family_add_member_button),
                ),
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  l10n.family_cancel,
                  style: const TextStyle(color: Colors.black),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Icon(icon, size: 12),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 5),
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
                      margin: const EdgeInsets.all(1),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE1E1E0),
                        borderRadius: BorderRadiusDirectional.horizontal(
                          start: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        suffix!,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          textDirection: TextDirection.rtl,
          children: [
            Icon(icon, size: 12),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          textDirection: TextDirection.rtl,
          children: List.generate(choices.length, (index) {
            final selected = index == selectedIndex;
            return Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(start: index == 0 ? 0 : 10),
                child: OutlinedButton(
                  onPressed: () => onChanged(index),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 32),
                    side: BorderSide(
                      color: selected
                          ? const Color(0xFF0C6C3F)
                          : const Color(0xFFE1E1E0),
                    ),
                    backgroundColor: selected
                        ? const Color(0xFFF6F8F7)
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    choices[index],
                    style: const TextStyle(color: Colors.black, fontSize: 10),
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
    return Container(
      height: 43,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8F7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          const Icon(Icons.lightbulb_outline_rounded, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  l10n.family_info,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  l10n.family_info_message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF5A5C62),
                    fontSize: 10,
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
