import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFD6D6D6)),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            const Icon(
              Icons.search_rounded,
              color: AppColors.textHint,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'ابحث عن وجبات أو مطاعم',
                textAlign: TextAlign.right,
                style: getRegularStyle(
                  fontFamily: FontConstant.ibmPlexSansArabic,
                  fontSize: FontSize.size12,
                  color: AppColors.textHint,
                ).copyWith(height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
