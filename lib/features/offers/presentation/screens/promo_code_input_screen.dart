import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/network/api_results.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/offers/domain/usecase/validate_discount_usecase.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/suggested_promo_code_card.dart';

class PromoCodeInputScreen extends StatefulWidget {
  const PromoCodeInputScreen({super.key, this.initialCode});

  final String? initialCode;

  @override
  State<PromoCodeInputScreen> createState() => _PromoCodeInputScreenState();
}

class _PromoCodeInputScreenState extends State<PromoCodeInputScreen> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.initialCode != null && widget.initialCode!.trim().isNotEmpty) {
      _controller.text = widget.initialCode!.trim().toUpperCase();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    if (data?.text != null && data!.text!.trim().isNotEmpty) {
      setState(() {
        _controller.text = data.text!.trim().toUpperCase();
        _errorMessage = null;
      });
    }
  }

  Future<void> _applyCode([String? directCode]) async {
    final code = (directCode ?? _controller.text).trim().toUpperCase();
    if (code.isEmpty) {
      final locale = context.localization;
      setState(() {
        _errorMessage = locale.offer_promo_empty_error;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final validateUseCase = getIt<ValidateDiscountUseCase>();
    final result = await validateUseCase(code: code);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    switch (result) {
      case ApiSuccessResult(:final data):
        if (data.isValid) {
          final lang = Localizations.localeOf(context).languageCode;
          final msg =
              data.message(lang) ?? context.localization.coupon_applied_label;
          CustomSnackbar.showSuccess(context: context, message: msg);

          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop(code);
          } else {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.subscriptions,
              arguments: code,
            );
          }
        } else {
          final lang = Localizations.localeOf(context).languageCode;
          final reason =
              data.message(lang) ??
              context.localization.offer_promo_invalid_error;
          setState(() {
            _errorMessage = reason;
          });
        }
      case ApiErrorResult(:final failure):
        final msg = ErrorMessagePresenter.fromFailure(context, failure);
        setState(() {
          _errorMessage = msg.isNotEmpty
              ? msg
              : context.localization.offer_promo_invalid_error;
        });
        CustomSnackbar.showError(context: context, message: _errorMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: locale.offer_promo_title,
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Spacing.md),
              // Illustration Header
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: color.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.card_giftcard_rounded,
                    size: 44,
                    color: color.primary,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.lg),
              Text(
                locale.offer_promo_headline,
                textAlign: TextAlign.center,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size18,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.xs),
              Text(
                locale.offer_promo_subtitle,
                textAlign: TextAlign.center,
                style: getRegularStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: Spacing.xl),

              // Code input box with paste icon
              Container(
                decoration: BoxDecoration(
                  color: color.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(Spacing.sm),
                  border: Border.all(
                    color: _errorMessage != null
                        ? color.error
                        : color.outlineVariant,
                  ),
                ),
                padding: const EdgeInsetsDirectional.only(
                  start: Spacing.md,
                  end: Spacing.xs,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          hintText: locale.offer_promo_hint,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintStyle: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size14,
                            color: color.outline,
                          ),
                        ),
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size15,
                          color: color.onSurface,
                        ),
                        onChanged: (_) {
                          if (_errorMessage != null) {
                            setState(() => _errorMessage = null);
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.content_paste_rounded,
                        color: color.primary,
                      ),
                      tooltip: locale.offer_promo_paste_tooltip,
                      onPressed: _pasteFromClipboard,
                    ),
                  ],
                ),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: Spacing.xs),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.xs),
                  child: Text(
                    _errorMessage!,
                    style: getRegularStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.error,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: Spacing.lg),

              // Primary Apply Button
              AppButton(
                text: locale.offer_promo_apply_button,
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _applyCode,
              ),

              const SizedBox(height: Spacing.xxl),

              // Available Promo Codes Section
              Text(
                locale.offer_promo_available_codes_title,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size15,
                  color: color.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.md),

              SizedBox(
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SuggestedPromoCodeCard(
                      code: 'SAVE20',
                      title: locale.offer_promo_save20_title,
                      discount: '20%',
                      onSelect: () {
                        _controller.text = 'SAVE20';
                        unawaited(_applyCode('SAVE20'));
                      },
                    ),
                    const SizedBox(width: Spacing.md),
                    SuggestedPromoCodeCard(
                      code: 'FIT10',
                      title: locale.offer_promo_fit10_title,
                      discount: '10%',
                      onSelect: () {
                        _controller.text = 'FIT10';
                        unawaited(_applyCode('FIT10'));
                      },
                    ),
                    const SizedBox(width: Spacing.md),
                    SuggestedPromoCodeCard(
                      code: 'WELCOME',
                      title: locale.offer_promo_welcome_title,
                      discount: '15%',
                      onSelect: () {
                        _controller.text = 'WELCOME';
                        unawaited(_applyCode('WELCOME'));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
