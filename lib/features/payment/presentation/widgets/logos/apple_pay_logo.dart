import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';

class ApplePayLogo extends StatelessWidget {
  const ApplePayLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AssetsFake.familyPaymentApplePay,
      width: Spacing.xxxl * 1.5,
      height: Spacing.xl,
    );
  }
}
