import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/core/constants/assets.dart';

class SubscriptionInfoNote extends StatelessWidget {
  const SubscriptionInfoNote({
    super.key,
    required this.text,
    required this.highlightedText,
  });

  final String text;
  final String highlightedText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F4EF),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            const SizedBox(width: 12),
            const Icon(
              Icons.info_outline_rounded,
              color: Color(0xFF0C6C3F),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: FontConstant.ibmPlexSansArabic,
                    fontSize: 10,
                    height: 1.55,
                    color: AppColors.black,
                  ),
                  children: [
                    TextSpan(text: text.split(highlightedText).first),
                    TextSpan(
                      text: highlightedText,
                      style: const TextStyle(
                        color: Color(0xFF07773C),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: text.contains(highlightedText)
                          ? text.split(highlightedText).last
                          : '',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 76,
              height: 48,
              child: Image.asset(
                Assets.subscriptionNoteMeal,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
