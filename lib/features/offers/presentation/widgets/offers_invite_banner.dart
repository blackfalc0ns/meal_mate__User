import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';

class OffersInviteBanner extends StatelessWidget {
  const OffersInviteBanner({super.key, required this.banner});

  final InviteBannerEntity banner;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      margin: const EdgeInsets.symmetric(horizontal: 13),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFFF0FAF1), Color(0xFFE7F4EA)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 104,
            child: Image.asset(banner.imageAsset, fit: BoxFit.contain),
          ),
          const Spacer(),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  banner.title,
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: getBoldStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: FontSize.size13,
                    color: AppColors.textPrimary,
                  ).copyWith(height: 1.2),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 80,
                  height: 21,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: Text(
                      banner.buttonLabel,
                      style: getSemiBoldStyle(
                        fontFamily: FontConstant.ibmPlexSansArabic,
                        fontSize: FontSize.size9,
                        color: AppColors.white,
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
