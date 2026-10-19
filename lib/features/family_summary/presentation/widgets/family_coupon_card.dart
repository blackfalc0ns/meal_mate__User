import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_event.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_state.dart';
import 'package:meal_meat_user/features/family_summary/presentation/manager/family_summary_view_model.dart';
import 'package:meal_meat_user/features/family_shared/presentation/models/family_ui_models.dart';

class FamilyCouponCard extends StatefulWidget {
  const FamilyCouponCard({super.key});

  @override
  State<FamilyCouponCard> createState() => _FamilyCouponCardState();
}

class _FamilyCouponCardState extends State<FamilyCouponCard> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onApply() {
    final code = _controller.text.trim();
    if (code.isEmpty) return;
    _focusNode.unfocus();
    context.read<FamilyCheckoutViewModel>().doIntent(
      ApplyFamilyCouponEvent(code),
    );
  }

  void _onRemove() {
    _focusNode.unfocus();
    _controller.clear();
    context.read<FamilyCheckoutViewModel>().doIntent(
      const RemoveFamilyCouponEvent(),
    );
  }

  Future<void> _onPaste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (text != null && text.isNotEmpty) {
      setState(() {
        _controller.text = text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FamilyCheckoutViewModel, FamilyCheckoutState>(
      buildWhen: (previous, current) =>
          previous.isCouponLoading != current.isCouponLoading ||
          previous.appliedPromoCode != current.appliedPromoCode ||
          previous.summary?.coupon != current.summary?.coupon,
      builder: (context, state) {
        final color = context.colorScheme;
        final locale = context.localization;
        final coupon = state.summary?.coupon;
        final isValid = coupon?.isValid == true;
        final isRejected = coupon != null && !isValid && coupon.code.isNotEmpty;
        final isApplying = state.isCouponLoading;
        final currency = resolveFamilyCurrency(
          locale,
          state.summary?.currencyCode,
        );

        if (isValid) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.base,
              vertical: Spacing.md,
            ),
            decoration: BoxDecoration(
              color: color.primaryContainer.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(Spacing.radiusLg),
              border: Border.all(
                color: color.primary.withValues(alpha: 0.3),
                width: Spacing.border,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: Spacing.avatarSm,
                  height: Spacing.avatarSm,
                  decoration: BoxDecoration(
                    color: color.primary,
                    borderRadius: BorderRadius.circular(Spacing.radiusSm),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.confirmation_number_outlined,
                    color: color.onPrimary,
                    size: Spacing.iconSm,
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              coupon!.code,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size14,
                                color: color.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(width: Spacing.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.xs,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: color.primary,
                              borderRadius: BorderRadius.circular(
                                Spacing.radiusPill,
                              ),
                            ),
                            child: Text(
                              locale.coupon_applied_label,
                              style: getMediumStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size10,
                                color: color.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (coupon.discountAmount > 0) ...[
                        const SizedBox(height: Spacing.xxs),
                        Text(
                          '- ${formatFamilyPrice(coupon.discountAmount)} $currency',
                          style: getSemiBoldStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size12,
                            color: color.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                TextButton(
                  onPressed: isApplying ? null : _onRemove,
                  child: Text(
                    locale.coupon_remove_button,
                    style: getSemiBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.error,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(Spacing.base),
          decoration: BoxDecoration(
            color: color.surface,
            borderRadius: BorderRadius.circular(Spacing.radiusLg),
            border: Border.all(
              color: isRejected ? color.error : color.outlineVariant,
              width: Spacing.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.confirmation_number_outlined,
                    size: Spacing.iconSm,
                    color: color.onSurfaceVariant,
                  ),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    locale.coupon_card_title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size13,
                      color: color.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.sm),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        enabled: !isApplying,
                        textCapitalization: TextCapitalization.characters,
                        style: getMediumStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size13,
                          color: color.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: locale.coupon_input_hint,
                          hintStyle: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size12,
                            color: color.onSurfaceVariant,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: Spacing.md,
                            vertical: Spacing.sm,
                          ),
                          filled: true,
                          fillColor: color.surfaceContainerLowest,
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.paste_rounded,
                              size: Spacing.iconSm,
                              color: color.primary,
                            ),
                            tooltip: locale.offer_promo_paste_tooltip,
                            onPressed: isApplying ? null : _onPaste,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Spacing.radiusMd,
                            ),
                            borderSide: BorderSide(
                              color: color.outlineVariant,
                              width: Spacing.border,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Spacing.radiusMd,
                            ),
                            borderSide: BorderSide(
                              color: isRejected
                                  ? color.error
                                  : color.outlineVariant,
                              width: Spacing.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Spacing.radiusMd,
                            ),
                            borderSide: BorderSide(
                              color: isRejected ? color.error : color.primary,
                              width: Spacing.border * 1.5,
                            ),
                          ),
                        ),
                        onSubmitted: (_) => _onApply(),
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  SizedBox(
                    height: 44,
                    child: FilledButton(
                      onPressed: isApplying ? null : _onApply,
                      style: FilledButton.styleFrom(
                        backgroundColor: color.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Spacing.radiusMd),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.lg,
                        ),
                      ),
                      child: isApplying
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: color.onPrimary,
                              ),
                            )
                          : Text(
                              locale.coupon_apply_button,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size13,
                                color: color.onPrimary,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              if (isRejected) ...[
                const SizedBox(height: Spacing.xs),
                Text(
                  coupon.message(locale.localeName).isNotEmpty
                      ? coupon.message(locale.localeName)
                      : locale.coupon_status_unknown,
                  style: getRegularStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size11,
                    color: color.error,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
