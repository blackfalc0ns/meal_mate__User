import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_purchase_options_entity.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offer_purchase_state.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offer_purchase_view_model.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/redeem_package_bottom_bar.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/redeem_package_card.dart';

class RedeemPackageScreen extends StatefulWidget {
  const RedeemPackageScreen({super.key, required this.offer});
  final OfferEntity offer;

  @override
  State<RedeemPackageScreen> createState() => _RedeemPackageScreenState();
}

class _RedeemPackageScreenState extends State<RedeemPackageScreen> {
  late final OfferPurchaseViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<OfferPurchaseViewModel>();
    unawaited(_viewModel.open(widget.offer.id));
  }

  @override
  void dispose() {
    unawaited(_viewModel.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: _viewModel,
    child: BlocBuilder<OfferPurchaseViewModel, OfferPurchaseState>(
      builder: (context, state) {
        final locale = context.localization;
        final color = context.colorScheme;
        final lang = Localizations.localeOf(context).languageCode;
        final options = state.options;
        final offer = state.offerDetails ?? widget.offer;
        final selectedOption = state.selectedOption;

        final hasSelection = selectedOption != null;
        final displayedPrice = state.summary?.finalPrice ??
            selectedOption?.finalPrice ??
            selectedOption?.basePrice ??
            0;
        final displayedCurrency = state.summary?.currencyCode.isNotEmpty == true
            ? state.summary!.currencyCode
            : (selectedOption?.currencyCode ?? locale.currency);

        return Scaffold(
          backgroundColor: color.surface,
          appBar: CustomAppBar(
            title: locale.offer_redeem_title,
            showBackButton: true,
          ),
          bottomNavigationBar: hasSelection
              ? RedeemPackageBottomBar(
                  finalPrice: displayedPrice,
                  currency: displayedCurrency,
                  canPay: hasSelection && !state.isSummaryLoading,
                  isLoading: state.isSummaryLoading,
                  onPay: () {
                    unawaited(
                      Navigator.of(context).pushNamed(
                        AppRoutes.offerSubscriptionSummary,
                        arguments: _viewModel,
                      ),
                    );
                  },
                )
              : null,
          body: state.isOptionsLoading && options == null
              ? const Center(child: CustomProgressIndicator())
              : options == null && state.failure != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(Spacing.xl),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 48,
                              color: color.error,
                            ),
                            const SizedBox(height: Spacing.md),
                            Text(
                              ErrorMessagePresenter.fromFailure(
                                context,
                                state.failure!,
                              ),
                              textAlign: TextAlign.center,
                              style: getRegularStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size13,
                                color: color.error,
                              ),
                            ),
                            const SizedBox(height: Spacing.md),
                            AppButton(
                              text: locale.payment_failed_retry_button,
                              onPressed: () => unawaited(
                                _viewModel.open(widget.offer.id),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SafeArea(
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(Spacing.md),
                        children: [
                          // Error banner if any action failed
                          if (state.failure != null) ...[
                            Container(
                              margin: const EdgeInsets.only(bottom: Spacing.md),
                              padding: const EdgeInsets.all(Spacing.md),
                              decoration: BoxDecoration(
                                color: color.errorContainer.withValues(
                                  alpha: 0.3,
                                ),
                                borderRadius: BorderRadius.circular(
                                  Spacing.radiusMd,
                                ),
                                border: Border.all(
                                  color: color.error.withValues(alpha: 0.5),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: color.error,
                                    size: 20,
                                  ),
                                  const SizedBox(width: Spacing.sm),
                                  Expanded(
                                    child: Text(
                                      ErrorMessagePresenter.fromFailure(
                                        context,
                                        state.failure!,
                                      ),
                                      style: getRegularStyle(
                                        fontFamily: FontConstant.alexandria,
                                        fontSize: FontSize.size12,
                                        color: color.error,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (state.selectedOption != null) {
                                        unawaited(
                                          _viewModel.selectOption(
                                            state.selectedOption!,
                                          ),
                                        );
                                      } else {
                                        unawaited(
                                          _viewModel.open(widget.offer.id),
                                        );
                                      }
                                    },
                                    child: Text(
                                      locale.payment_failed_retry_button,
                                      style: getBoldStyle(
                                        fontFamily: FontConstant.alexandria,
                                        fontSize: FontSize.size12,
                                        color: color.error,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          // Family packages action
                          if (options?.isFamily == true)
                            AppButton(
                              text: locale.family_packages_header_title,
                              onPressed: () => Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.familyPackageSelection),
                            ),

                          // Standard Package Options
                          if (options != null && !options.isFamily) ...[
                            // Section Title
                            Text(
                              locale.offer_redeem_select_package_title,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size15,
                                color: color.onSurface,
                              ),
                            ),
                            const SizedBox(height: Spacing.md),

                            // Blocking reasons for overall options
                            for (final reason in options.blockingReasons)
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: Spacing.xs,
                                ),
                                child: Text(
                                  _reason(context, reason, lang),
                                  style: getRegularStyle(
                                    fontFamily: FontConstant.alexandria,
                                    fontSize: FontSize.size12,
                                    color: color.error,
                                  ),
                                ),
                              ),

                            if (options.options.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Spacing.xl,
                                ),
                                child: Center(
                                  child: Text(
                                    locale.subscription_flow_empty_options,
                                    style: getMediumStyle(
                                      fontFamily: FontConstant.alexandria,
                                      fontSize: FontSize.size13,
                                      color: color.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ),

                            // List of Package Cards (Figma 12.04)
                            for (final option in options.options)
                              RedeemPackageCard(
                                option: option,
                                isSelected:
                                    selectedOption?.selectionKey ==
                                    option.selectionKey,
                                discountPercent: _calculateDiscountPercent(
                                  offer,
                                  option,
                                ),
                                onTap:
                                    option.canCheckout &&
                                        !state.isOptionsLoading
                                    ? () => unawaited(
                                        _viewModel.selectOption(option),
                                      )
                                    : null,
                              ),
                            const SizedBox(height: Spacing.lg),
                          ],
                        ],
                      ),
                    ),
        );
      },
    ),
  );

  int _calculateDiscountPercent(
    OfferEntity offer,
    OfferPurchaseOptionEntity option,
  ) {
    if (offer.discountRate != null && offer.discountRate! > 0) {
      return (offer.discountRate! * 100).round();
    }
    if (option.basePrice != null &&
        option.finalPrice != null &&
        option.basePrice! > option.finalPrice! &&
        option.basePrice! > 0) {
      return (((option.basePrice! - option.finalPrice!) / option.basePrice!) *
              100)
          .round();
    }
    return 0;
  }

  String _reason(
    BuildContext context,
    OfferPurchaseBlockingReasonEntity reason,
    String lang,
  ) {
    final message = lang == 'ar'
        ? (reason.messageAr ?? reason.messageEn)
        : (reason.messageEn ?? reason.messageAr);
    return message ?? ErrorMessagePresenter.mapCode(context, reason.code);
  }
}
