import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/family_plan_entity.dart';

class FamilyMembersStrip extends StatelessWidget {
  const FamilyMembersStrip({
    super.key,
    required this.members,
    required this.onAddTap,
  });

  final List<FamilyMemberEntity> members;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 129,
      child: ListView.separated(
        reverse: true,
        scrollDirection: Axis.horizontal,
        itemCount: members.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 7),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _AddMemberCard(onTap: onAddTap);
          }
          return _MemberCard(member: members[index - 1]);
        },
      ),
    );
  }
}

class _AddMemberCard extends StatelessWidget {
  const _AddMemberCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9),
      child: Container(
        width: 65,
        decoration: BoxDecoration(
          color: const Color(0xFFF6F8F7),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: const Color(0xFF0C6C3F)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_circle_rounded,
              color: Color(0xFF0C6C3F),
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.family_add_member,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF066A2E),
                fontSize: 8.2,
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.family_add_member_subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF5A5C62),
                fontSize: 5.8,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({required this.member});

  final FamilyMemberEntity member;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 65,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7F6),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage(member.imageAsset),
              ),
              if (member.isOwner)
                Positioned(
                  bottom: -5,
                  left: 8,
                  right: 8,
                  child: Container(
                    alignment: Alignment.center,
                    height: 9,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDEEDDE),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      context.localization.family_owner,
                      style: const TextStyle(
                        color: Color(0xFF217B4E),
                        fontSize: 4.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            member.name,
            style: const TextStyle(fontSize: 8.2, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          _MiniChecks(checks: member.mealChecks),
        ],
      ),
    );
  }
}

class _MiniChecks extends StatelessWidget {
  const _MiniChecks({required this.checks});

  final List<bool> checks;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 3,
      runSpacing: 3,
      children: checks
          .map(
            (checked) => Icon(
              checked ? Icons.check_rounded : Icons.remove_rounded,
              size: 9,
              color: const Color(0xFF0C6C3F),
            ),
          )
          .toList(),
    );
  }
}
