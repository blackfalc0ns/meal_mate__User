import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

/// A reusable header widget for the offer details screen.
/// Displays the offer image, logo, discount badge, and basic info.
class OfferDetailsHeader extends StatelessWidget {
  const OfferDetailsHeader({
    super.key,
    required this.offer,
    this.onBackTap,
    this.onShareTap,
    this.onFavoriteTap,
    this.isFavorite = false,
  });

  final OfferDealEntity offer;
  final VoidCallback? onBackTap;
  final VoidCallback? onShareTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        _buildOfferImage(),

        // Gradient overlay
        _buildGradientOverlay(),

        // Top action bar
        _buildTopActionBar(context),

        // Discount badge
        _buildDiscountBadge(context),

        // Restaurant info at bottom
        _buildRestaurantInfo(),
      ],
    );
  }

  Widget _buildOfferImage() {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(
        color: offer.surfaceColor,
        image: DecorationImage(
          image: AssetImage(offer.imageAsset),
          fit: BoxFit.cover,
          onError: (_, _) {},
        ),
      ),
      child: Container(color: offer.surfaceColor.withValues(alpha: 0.3)),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.4),
              Colors.transparent,
              Colors.black.withValues(alpha: 0.6),
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildTopActionBar(BuildContext context) {
    return PositionedDirectional(
      top: MediaQuery.of(context).padding.top + 8,
      start: 16,
      end: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          _CircleIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: onBackTap ?? () => Navigator.pop(context),
          ),

          // Action buttons
          Row(
            children: [
              _CircleIconButton(icon: Icons.share_rounded, onTap: onShareTap),
              const SizedBox(width: 8),
              _CircleIconButton(
                icon: isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                onTap: onFavoriteTap,
                iconColor: isFavorite ? AppColors.error : AppColors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountBadge(BuildContext context) {
    return PositionedDirectional(
      top: MediaQuery.of(context).padding.top + 60,
      end: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: offer.accentColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: offer.accentColor.withValues(alpha: 0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.local_offer_rounded,
              size: 16,
              color: AppColors.white,
            ),
            const SizedBox(width: 6),
            Text(
              offer.discountLabel,
              style: getBoldStyle(
                fontFamily: FontConstant.ibmPlexSansArabic,
                fontSize: FontSize.size14,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantInfo() {
    return PositionedDirectional(
      bottom: 16,
      start: 16,
      end: 16,
      child: Row(
        children: [
          // Restaurant logo
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                offer.logoAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Icon(
                  Icons.restaurant_rounded,
                  color: offer.accentColor,
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Restaurant name and details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size18,
                    color: AppColors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: AppColors.starFilled,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      offer.reviewLabel,
                      style: getMediumStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size12,
                        color: AppColors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: AppColors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      offer.deliveryLabel,
                      style: getMediumStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size12,
                        color: AppColors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A circular icon button used for actions in the header.
class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    this.onTap,
    this.iconColor = AppColors.white,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Icon(icon, size: 20, color: iconColor),
      ),
    );
  }
}
