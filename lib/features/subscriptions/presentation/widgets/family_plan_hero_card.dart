import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/features/subscriptions/domain/entities/family_plan_entity.dart';

class FamilyPlanHeroCard extends StatelessWidget {
  const FamilyPlanHeroCard({super.key, required this.plan});

  final FamilyPlanEntity plan;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 265,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            height: 191,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFF6F7F6),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: const Color(0xFFECEEED)),
              ),
            ),
          ),
          PositionedDirectional(
            start: 0,
            top: 0,
            width: 177,
            height: 265,
            child: Image.asset(Assets.familyPlanHero, fit: BoxFit.cover),
          ),
          PositionedDirectional(
            end: 11,
            top: 75,
            child: _TinyBadge(
              text: plan.statusLabel,
              color: const Color(0xFF1B8E2F),
              textColor: Colors.white,
            ),
          ),
          PositionedDirectional(
            end: 10,
            top: 94,
            width: 130,
            child: Column(
              children: [
                Text(
                  plan.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF006C30),
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  plan.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF1B1B1B),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          PositionedDirectional(
            end: 10,
            top: 164,
            width: 161,
            height: 57,
            child: _FeatureStrip(features: plan.features),
          ),
          PositionedDirectional(
            start: 13,
            bottom: 41,
            child: Text(
              '${plan.originalPrice} ${plan.currency}',
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.lineThrough,
                decorationColor: Color(0xFFE00606),
              ),
            ),
          ),
          PositionedDirectional(
            start: 13,
            bottom: 16,
            child: Text(
              '${plan.discountedPrice} ${plan.currency}',
              style: const TextStyle(
                color: Color(0xFF0C6C3F),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          PositionedDirectional(
            start: 118,
            bottom: 25,
            child: _TinyBadge(
              text: plan.badge,
              color: const Color(0xFFEAF0EA),
              textColor: const Color(0xFF0C6C3F),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureStrip extends StatelessWidget {
  const _FeatureStrip({required this.features});

  final List<String> features;

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        for (int index = 0; index < features.length; index++) ...[
          Expanded(
            child: Column(
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Color(0xFF0C6C3F),
                  size: 20,
                ),
                const SizedBox(height: 5),
                Text(
                  features[index],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 6.9,
                    fontWeight: FontWeight.w600,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          if (index != features.length - 1)
            Container(width: 1, height: 50, color: const Color(0xFFEAEBEB)),
        ],
      ],
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({
    required this.text,
    required this.color,
    required this.textColor,
  });

  final String text;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 6.9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
