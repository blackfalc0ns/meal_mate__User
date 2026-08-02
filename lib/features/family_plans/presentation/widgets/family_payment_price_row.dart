import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_plans/data/family_program_setup_fake_data.dart';

class FamilyPaymentPriceRow extends StatelessWidget {
  const FamilyPaymentPriceRow({super.key, required this.row});

  final FamilyPaymentPriceRowFakeData row;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final valueColor = row.isDiscount ? color.primary : color.onSurface;
    final valueStyle = row.isStrong ? getBoldStyle : getSemiBoldStyle;

    return Row(
      children: [
        Text(
          row.label,

          style: getSemiBoldStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size10,
            color: color.onSurfaceVariant,
          ),
        ),

        const Spacer(),

        Text.rich(
          TextSpan(
            children: [
               TextSpan(text: row.value,style: valueStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size11,
                color: valueColor,
              ),),
              TextSpan(
                text: ' ${locale.currency}',
                style: valueStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size9,
                  color: valueColor,
                ),
              ),
             
            ],
          ),
         
          style: valueStyle(
            fontFamily: FontConstant.alexandria,
            fontSize: FontSize.size9,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
