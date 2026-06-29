import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';

/// The top hero banner shown on the offer-activated screen.
/// Displays food image, discount percentage, offer title, subtitle, and timer.
class OfferActivatedHeroBanner extends StatelessWidget {
  const OfferActivatedHeroBanner({
    super.key,
    required this.imageAsset,
    required this.discountLabel,
    required this.title,
    required this.subtitle,
    required this.timerText,
    required this.accentColor,
  });

  final String imageAsset;
  final String discountLabel;
  final String title;
  final String subtitle;
  final String timerText;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            accentColor.withValues(alpha: 0.08),
            AppColors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.18),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Scattered leaf decorations
            Positioned(
              top: 12,
              right: 14,
              child: _LeafDot(size: 16, color: accentColor.withValues(alpha: 0.22)),
            ),
            Positioned(
              top: 6,
              right: 40,
              child: _LeafDot(size: 10, color: accentColor.withValues(alpha: 0.14)),
            ),
            Positioned(
              bottom: 30,
              right: 8,
              child: _LeafDot(size: 12, color: accentColor.withValues(alpha: 0.16)),
            ),
            Positioned(
              top: 20,
              left: 10,
              child: _LeafDot(size: 9, color: accentColor.withValues(alpha: 0.12)),
            ),
            // Row: food image + text content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                textDirection: TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Food image (circular)
                  _CircularFoodImage(imageAsset: imageAsset, accentColor: accentColor),
                  const SizedBox(width: 14),
                  // Text block (RTL inside)
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'خصم',
                            style: getBoldStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          // Large discount number
                          Text(
                            discountLabel,
                            style: getBoldStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize: 38,
                              color: accentColor,
                            ),
                          ),
                          Text(
                            title,
                            style: getBoldStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: getMediumStyle(
                              fontFamily: FontConstant.ibmPlexSansArabic,
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Timer badge
                          _TimerBadge(timerText: timerText, accentColor: accentColor),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private helpers ─────────────────────────────────────────────

class _CircularFoodImage extends StatelessWidget {
  const _CircularFoodImage({
    required this.imageAsset,
    required this.accentColor,
  });

  final String imageAsset;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -4,
            top: 10,
            child: _LeafDot(size: 13, color: accentColor.withValues(alpha: 0.28)),
          ),
          Positioned(
            right: 10,
            top: -4,
            child: _LeafDot(size: 9, color: accentColor.withValues(alpha: 0.20)),
          ),
          Positioned(
            left: -2,
            bottom: 18,
            child: _LeafDot(size: 11, color: accentColor.withValues(alpha: 0.22)),
          ),
          Positioned(
            left: 10,
            bottom: 4,
            child: _LeafDot(size: 8, color: accentColor.withValues(alpha: 0.16)),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 118,
              height: 118,
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(5),
              child: ClipOval(
                child: Image.asset(imageAsset, fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimerBadge extends StatelessWidget {
  const _TimerBadge({required this.timerText, required this.accentColor});

  final String timerText;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          Icon(Icons.access_time_rounded, size: 13, color: accentColor),
          const SizedBox(width: 4),
          Text(
            'ينتهي خلال : $timerText',
            style: TextStyle(
              fontFamily: FontConstant.ibmPlexSansArabic,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _LeafDot extends StatelessWidget {
  const _LeafDot({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
