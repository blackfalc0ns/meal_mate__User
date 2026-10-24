import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/services/promo_code_session.dart';
import 'package:meal_meat_user/features/subscription_checkout/domain/entities/subscription_coupon_entity.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_event.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_state.dart';
import 'package:meal_meat_user/features/subscription_checkout/presentation/manager/subscription_summary_view_model.dart';

class SubscriptionCouponCard extends StatefulWidget {
  const SubscriptionCouponCard({
    super.key,
    required this.coupon,
    required this.currencyCode,
  });

  final SubscriptionCouponEntity? coupon;
  final String currencyCode;

  @override
  State<SubscriptionCouponCard> createState() => _SubscriptionCouponCardState();
}

class _SubscriptionCouponCardState extends State<SubscriptionCouponCard> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    final initial = widget.coupon?.code.trim().isNotEmpty == true
        ? widget.coupon!.code
        : (PromoCodeSession.activePromoCode ?? '');
    _controller = TextEditingController(text: initial);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant SubscriptionCouponCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.coupon != oldWidget.coupon) {
      final newText = widget.coupon?.code ?? '';
      if (_controller.text != newText && widget.coupon?.isValid == true) {
        _controller.text = newText;
        PromoCodeSession.setActivePromoCode(newText);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onApply() {
    _focusNode.unfocus();
    final code = _controller.text.trim();
    if (code.isNotEmpty) {
      PromoCodeSession.setActivePromoCode(code);
      try {
        context.read<SubscriptionSummaryViewModel>().doIntent(
          ApplySubscriptionPromoCodeEvent(code),
        );
      } catch (_) {}
    }
  }

  void _onRemove() {
    _focusNode.unfocus();
    _controller.clear();
    PromoCodeSession.clear();
    try {
      context.read<SubscriptionSummaryViewModel>().doIntent(
        const RemoveSubscriptionPromoCodeEvent(),
      );
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    SubscriptionSummaryViewModel? viewModel;
    try {
      viewModel = context.watch<SubscriptionSummaryViewModel>();
    } catch (_) {
      viewModel = null;
    }

    if (viewModel != null) {
      return BlocBuilder<
        SubscriptionSummaryViewModel,
        SubscriptionSummaryState
      >(
        buildWhen: (previous, current) =>
            previous.isApplyingCoupon != current.isApplyingCoupon ||
            previous.summary?.coupon != current.summary?.coupon,
        builder: (context, state) {
          final coupon = state.summary?.coupon ?? widget.coupon;
          return _buildCard(
            context: context,
            coupon: coupon,
            isApplying: state.isApplyingCoupon,
          );
        },
      );
    }

    return _buildCard(
      context: context,
      coupon: widget.coupon,
      isApplying: false,
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required SubscriptionCouponEntity? coupon,
    required bool isApplying,
  }) {
    final color = context.colorScheme;
    final locale = context.localization;

    final effectiveCurrency =
        (widget.currencyCode.isEmpty || widget.currencyCode == 'KWD')
            ? locale.currency_kwd
            : widget.currencyCode;

    final isValid = coupon?.isValid == true;
    final isRejected = coupon != null && !isValid && coupon.code.isNotEmpty;

    if (isValid) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.md,
          vertical: Spacing.sm + 2,
        ),
        decoration: BoxDecoration(
          color: color.primaryContainer.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(Spacing.radiusLg),
          border: Border.all(
            color: color.primary.withValues(alpha: 0.28),
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
                boxShadow: [
                  BoxShadow(
                    color: color.primary.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Directionality(
                          textDirection: TextDirection.ltr,
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
                      '- ${coupon.discountAmount.formattedPrice} $effectiveCurrency',
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
            const SizedBox(width: Spacing.xs),
            InkWell(
              onTap: isApplying ? null : _onRemove,
              borderRadius: BorderRadius.circular(Spacing.radiusPill),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.sm,
                  vertical: Spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: color.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(Spacing.radiusPill),
                  border: Border.all(
                    color: color.error.withValues(alpha: 0.2),
                    width: Spacing.border,
                  ),
                ),
                child: isApplying
                    ? SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: color.error,
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: color.error,
                          ),
                          const SizedBox(width: Spacing.xxs),
                          Text(
                            locale.coupon_remove_button,
                            style: getSemiBoldStyle(
                              fontFamily: FontConstant.alexandria,
                              fontSize: FontSize.size11,
                              color: color.error,
                            ),
                          ),
                        ],
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Spacing.radiusMd),
                        borderSide: BorderSide(
                          color: color.outlineVariant,
                          width: Spacing.border,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Spacing.radiusMd),
                        borderSide: BorderSide(
                          color: isRejected
                              ? color.error
                              : color.outlineVariant,
                          width: Spacing.border,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Spacing.radiusMd),
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
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
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
  }
}
