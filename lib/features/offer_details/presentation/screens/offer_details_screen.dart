import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/core/services/promo_code_session.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/notification_button.dart';
import 'package:meal_meat_user/features/offer_details/data/offer_details_data.dart';
import 'package:meal_meat_user/features/offer_details/presentation/manager/offer_details_event.dart';
import 'package:meal_meat_user/features/offer_details/presentation/manager/offer_details_state.dart';
import 'package:meal_meat_user/features/offer_details/presentation/manager/offer_details_view_model.dart';
import 'package:intl/intl.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_benefits_section.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_hero_card.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_info_card.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_loading_skeleton.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';

class OfferDetailsScreen extends StatelessWidget {
  const OfferDetailsScreen({super.key, this.offerId = '', this.viewModel});

  final String offerId;
  final OfferDetailsViewModel? viewModel;
  static const routeName = '/offer-details';

  @override
  Widget build(BuildContext context) {
    if (viewModel != null) {
      return BlocProvider.value(
        value: viewModel!,
        child: _OfferDetailsContent(offerId: offerId),
      );
    }
    return BlocProvider(
      create: (_) =>
          getIt<OfferDetailsViewModel>()
            ..doIntent(LoadOfferDetailsEvent(offerId)),
      child: _OfferDetailsContent(offerId: offerId),
    );
  }
}

class _OfferDetailsContent extends StatefulWidget {
  const _OfferDetailsContent({required this.offerId});

  final String offerId;

  @override
  State<_OfferDetailsContent> createState() => _OfferDetailsContentState();
}

class _OfferDetailsContentState extends State<_OfferDetailsContent> {
  bool _isOfferExpired = false;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Scaffold(
      backgroundColor: color.surface,
      extendBody: true,
      appBar: CustomAppBar(
        title: locale.offer_details_title,
        showBackButton: true,
        actions: [NotificationButton(onTap: () {})],
      ),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<OfferDetailsViewModel, OfferDetailsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const OfferDetailsLoadingSkeleton();
            }

            if (state.failure != null && state.offer == null) {
              return ApiErrorWidget(
                exception: state.failure!.exception,
                onRetry: () => context.read<OfferDetailsViewModel>().doIntent(
                  LoadOfferDetailsEvent(widget.offerId),
                ),
              );
            }

            if (state.offer == null) {
              return EmptyStateWidget(
                title: locale.offer_details_title,
                description: locale.offer_browse_empty,
                icon: Icons.local_offer_outlined,
              );
            }

            final offer = state.offer!;
            final isExpired = _isOfferExpired || offer.isExpired;
            final isSoldOut = offer.isSoldOut;
            final details = _detailsFromOffer(offer, locale);

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsetsDirectional.only(
                start: Spacing.offerDetailsHorizontalPadding,
                end: Spacing.offerDetailsHorizontalPadding,
                top: Spacing.offerDetailsHeaderTopGap,
                bottom: Spacing.offerDetailsBottomNavGap,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state.failure != null) ...[
                    InlineApiErrorWidget(
                      failure: state.failure!,
                      onRetry: () => context
                          .read<OfferDetailsViewModel>()
                          .doIntent(LoadOfferDetailsEvent(widget.offerId)),
                    ),
                    const SizedBox(height: Spacing.base),
                  ],

                  // Hero Card (Figma 12.02)
                  OfferDetailsHeroCard(
                    details: details,
                    onExpired: () {
                      if (mounted) {
                        setState(() {
                          _isOfferExpired = true;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: Spacing.base),

                  if (!offer.isAvailable) ...[
                    Text(
                      ErrorMessagePresenter.mapCode(
                        context,
                        offer.availabilityReasonCode ??
                            'offers.customer.unavailable',
                      ),
                      style: getRegularStyle(
                        fontFamily: FontConstant.alexandria,
                        fontSize: FontSize.size12,
                        color: color.error,
                      ),
                    ),
                    const SizedBox(height: Spacing.sm),
                  ],

                  // Info Card with 4 rows & integrated Coupon Box (Figma 12.02)
                  OfferDetailsInfoCard(details: details),
                  const SizedBox(height: Spacing.base),

                  // "Why this offer?" Benefits Section (Figma 12.02)
                  if (details.benefits.isNotEmpty) ...[
                    OfferDetailsBenefitsSection(details: details),
                    const SizedBox(height: Spacing.lg),
                  ],

                  AppButton(
                    text: isExpired
                        ? locale.offer_status_expired
                        : (isSoldOut
                            ? locale.offer_status_sold_out
                            : (offer.isCouponOnly
                                ? locale.offers_coupon_button
                                : locale.offer_details_plan_section_title)),
                    onPressed: !offer.isAvailable ||
                            (offer.isCouponOnly &&
                                offer.promoCode?.trim().isNotEmpty != true) ||
                            isExpired ||
                            isSoldOut ||
                            offer.purchaseMode == OfferPurchaseMode.unknown
                        ? null
                        : () => _navigateToRedeemPackage(context, offer),
                    height: Spacing.offerDetailsBottomButtonHeight,
                    borderRadius: Spacing.offerDetailsBottomButtonRadius,
                    gradient: !offer.isAvailable ||
                            (offer.isCouponOnly &&
                                offer.promoCode?.trim().isNotEmpty != true) ||
                            isExpired ||
                            isSoldOut ||
                            offer.purchaseMode == OfferPurchaseMode.unknown
                        ? null
                        : LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [color.primary, color.tertiary],
                          ),
                    textColor: color.onPrimary,
                    fontSize: FontSize.size15,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  OfferDetailsData _detailsFromOffer(OfferEntity offer, dynamic locale) {
    final endsAt = offer.endsAt;
    final formattedEndsAt = endsAt != null
        ? DateFormat('d MMMM yyyy', locale.localeName).format(endsAt.toLocal())
        : locale.offer_details_hero_timer_label;

    final discountRate = offer.discountRate;
    final discountStr = discountRate != null
        ? '${(discountRate * 100).round()}%'
        : (offer.discountAmount != null
            ? '${offer.discountAmount!.round()} ${locale.currency}'
            : '20%');

    final offerName = offer.title(locale.localeName);
    final offerDesc = offer.description(locale.localeName);
    final offerTerms = offer.terms(locale.localeName);

    return OfferDetailsData(
      heroImageUrl: offer.bannerImageUrl,
      couponCode: offer.promoCode,
      discountRate: offer.discountRate,
      discountText: discountStr,
      offerHeading: discountRate != null
          ? 'خصم $discountStr على الباقات'
          : locale.offer_details_hero_heading,
      offerSubtitle: offerName.isNotEmpty
          ? offerName
          : locale.offer_details_hero_subtitle,
      endsAt: offer.endsAt,
      serverNowUtc: offer.serverNowUtc,
      isFeatured: true,
      isCodeActive: offer.isAvailable,
      infoRows: [
        OfferDetailsInfoRowData(
          label: locale.offer_details_info_offer_type,
          value: offerDesc.isNotEmpty
              ? offerDesc
              : (offerName.isNotEmpty
                  ? offerName
                  : locale.offer_details_info_summary),
          icon: OfferDetailsIconType.tag,
        ),
        if (offer.endsAt != null)
          OfferDetailsInfoRowData(
            label: locale.offer_details_info_duration_label,
            value: formattedEndsAt,
            icon: OfferDetailsIconType.calendar,
          ),
        OfferDetailsInfoRowData(
          label: locale.offer_details_valid_on_label,
          value: locale.offer_details_valid_on_all_monthly,
          icon: OfferDetailsIconType.box,
        ),
        OfferDetailsInfoRowData(
          label: locale.offer_details_info_terms_short_label,
          value: offerTerms?.isNotEmpty == true
              ? offerTerms!
              : locale.offer_details_terms_short,
          icon: OfferDetailsIconType.document,
        ),
      ],
      benefitsTitle: locale.offer_details_benefits_section_title,
      benefits: [
        OfferDetailsBenefitData(
          title: locale.offer_details_benefit_saving_title,
          description: locale.offer_details_benefit_saving_desc,
          icon: OfferDetailsIconType.money,
        ),
        OfferDetailsBenefitData(
          title: locale.offer_details_benefit_goals_title,
          description: locale.offer_details_benefit_goals_desc,
          icon: OfferDetailsIconType.target,
        ),
        OfferDetailsBenefitData(
          title: locale.offer_details_benefit_flexibility_title,
          description: locale.offer_details_benefit_flexibility_desc,
          icon: OfferDetailsIconType.sliders,
        ),
      ],
    );
  }

  void _navigateToRedeemPackage(BuildContext context, OfferEntity? offer) {
    if (offer == null) return;
    if (!offer.isAvailable) return;
    switch (offer.purchaseMode) {
      case OfferPurchaseMode.directPurchase:
        unawaited(
          Navigator.of(
            context,
          ).pushNamed(AppRoutes.redeemPackage, arguments: offer),
        );
      case OfferPurchaseMode.couponOnly:
        if (offer.promoCode != null && offer.promoCode!.isNotEmpty) {
          PromoCodeSession.setActivePromoCode(offer.promoCode);
          unawaited(
            Clipboard.setData(ClipboardData(text: offer.promoCode!)),
          );
          CustomSnackbar.showSuccess(
            context: context,
            message: context.localization.offer_details_copy_code,
          );
          unawaited(
            Navigator.of(
              context,
            ).pushNamed(AppRoutes.subscriptionProgramSelection),
          );
        }
      case OfferPurchaseMode.unknown:
        // No action - guarded against entering redeemPackage
        break;
    }
  }
}
