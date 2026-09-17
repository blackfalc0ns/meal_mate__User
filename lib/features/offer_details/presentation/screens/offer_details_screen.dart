import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/notification_button.dart';
import 'package:meal_meat_user/features/offer_details/data/offer_details_fake_data_source.dart';
import 'package:meal_meat_user/features/offer_details/presentation/manager/offer_details_event.dart';
import 'package:meal_meat_user/features/offer_details/presentation/manager/offer_details_state.dart';
import 'package:meal_meat_user/features/offer_details/presentation/manager/offer_details_view_model.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_countdown_timer_widget.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_benefits_section.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_hero_card.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_info_card.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_loading_skeleton.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';

class OfferDetailsScreen extends StatelessWidget {
  const OfferDetailsScreen({super.key, this.offerId = ''});

  final String offerId;
  static const routeName = '/offer-details';

  @override
  Widget build(BuildContext context) {
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
  static const _fallbackDataSource = OfferDetailsFakeDataSource();
  bool _isOfferExpired = false;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final fallbackDetails = _fallbackDataSource.getOfferDetails();

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

            final offer = state.offer;
            final isExpired = _isOfferExpired || (offer?.isExpired ?? false);
            final isSoldOut = offer?.isSoldOut ?? false;

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
                  if (state.failure != null && state.offer != null) ...[
                    InlineApiErrorWidget(
                      failure: state.failure!,
                      onRetry: () => context
                          .read<OfferDetailsViewModel>()
                          .doIntent(LoadOfferDetailsEvent(widget.offerId)),
                    ),
                    const SizedBox(height: Spacing.base),
                  ],
                  OfferDetailsHeroCard(details: fallbackDetails),
                  const SizedBox(height: Spacing.base),

                  // Countdown Timer
                  if (offer?.endsAt != null) ...[
                    OfferCountdownTimerWidget(
                      endsAt: offer!.endsAt!,
                      onExpired: () {
                        if (mounted) {
                          setState(() {
                            _isOfferExpired = true;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: Spacing.base),
                  ],

                  // Promo code copy box if code is present
                  if (offer?.promoCode != null &&
                      offer!.promoCode!.isNotEmpty) ...[
                    _buildPromoCodeCard(context, offer.promoCode!),
                    const SizedBox(height: Spacing.base),
                  ],

                  OfferDetailsInfoCard(details: fallbackDetails),
                  const SizedBox(height: Spacing.md),
                  OfferDetailsBenefitsSection(details: fallbackDetails),
                  const SizedBox(height: Spacing.xl),
                  AppButton(
                    text: isExpired
                        ? locale.offer_status_expired
                        : (isSoldOut
                              ? locale.offer_status_sold_out
                              : locale.offer_details_plan_section_title),
                    onPressed: isExpired || isSoldOut
                        ? null
                        : () => _navigateToRedeemPackage(context, offer),
                    height: Spacing.offerDetailsBottomButtonHeight,
                    borderRadius: Spacing.offerDetailsBottomButtonRadius,
                    gradient: isExpired || isSoldOut
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

  Widget _buildPromoCodeCard(BuildContext context, String promoCode) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.md,
        vertical: Spacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Spacing.sm),
        border: Border.all(color: color.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.discount_outlined, color: color.primary, size: 20),
          const SizedBox(width: Spacing.sm),
          Text(
            '${locale.offer_details_code_label}: ',
            style: getMediumStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size13,
              color: color.onSurfaceVariant,
            ),
          ),
          Text(
            promoCode,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: color.primary,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: promoCode));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(locale.offer_details_copy_code),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(Spacing.xs),
              child: Icon(Icons.copy_rounded, color: color.primary, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToRedeemPackage(BuildContext context, OfferEntity? offer) {
    final effectiveOffer =
        offer ??
        OfferEntity(
          id: widget.offerId.isNotEmpty
              ? widget.offerId
              : '7b85f264-b040-4591-a1b7-a36f90382345',
          nameAr: 'خصم 20% على الباقات الشهرية',
          nameEn: '20% Off Monthly Packages',
          descriptionAr: 'خطط غذائية متكاملة تساعدك على تحقيق أهدافك',
          descriptionEn: 'Comprehensive nutrition plans',
          discountRate: 0.20,
          startsAt: DateTime.now().toUtc(),
          endsAt: DateTime.now().toUtc().add(const Duration(days: 14)),
          promoCode: 'SAVE20',
          minSubscriptionDays: 26,
        );

    Navigator.of(
      context,
    ).pushNamed(AppRoutes.redeemPackage, arguments: effectiveOffer);
  }
}
