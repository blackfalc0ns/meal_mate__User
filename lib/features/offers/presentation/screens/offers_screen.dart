import 'dart:async';

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
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/core/widget/notification_button.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offers_event.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offers_state.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offers_view_model.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/animated_offer_row.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/campaign_banner_card.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offer_deal_card.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offer_quick_preview_sheet.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_coupon_banner.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_filter_strip.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_hero_card.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_invite_banner.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_loading_skeleton.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_page_indicator.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_section_header.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key, this.viewModel});

  final OffersViewModel? viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel != null) {
      return BlocProvider.value(
        value: viewModel!,
        child: const _OffersContent(),
      );
    }
    return BlocProvider(
      create: (_) =>
          getIt<OffersViewModel>()
            ..doIntent(const GetOffersEvent(includeCampaigns: false)),
      child: const _OffersContent(),
    );
  }
}

class _OffersContent extends StatefulWidget {
  const _OffersContent();

  @override
  State<_OffersContent> createState() => _OffersContentState();
}

class _OffersContentState extends State<_OffersContent> {
  final ValueNotifier<int> _campaignPage = ValueNotifier(0);

  @override
  void dispose() {
    _campaignPage.dispose();
    super.dispose();
  }

  void _onOfferTap(BuildContext context, OfferEntity offer) {
    if (!offer.isAvailable) return;
    if (offer.sourceType == 'Campaign') return;
    switch (offer.purchaseMode) {
      case OfferPurchaseMode.directPurchase:
        unawaited(
          Navigator.of(
            context,
          ).pushNamed(AppRoutes.offerDetails, arguments: offer.id),
        );
      case OfferPurchaseMode.couponOnly:
        if (offer.promoCode?.trim().isNotEmpty != true) return;
        _openQuickSheet(context, offer);
      case OfferPurchaseMode.unknown:
        // No navigation: neither an offer ID nor a coupon flow is guaranteed.
        break;
    }
  }

  void _openQuickSheet(BuildContext context, OfferEntity offer) {
    if (offer.purchaseMode == OfferPurchaseMode.unknown) return;
    unawaited(
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => OfferQuickPreviewSheet(offer: offer),
      ),
    );
  }

  Widget _buildSectionEmpty(BuildContext context, String message) {
    final color = context.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.offersHorizontalPadding,
        vertical: Spacing.sm,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: color.surfaceContainerLow,
          borderRadius: BorderRadius.circular(Spacing.sm),
          border: Border.all(
            color: color.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Center(
          child: Text(
            message,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return ColoredBox(
      color: color.surface,
      child: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              showBackButton: false,
              title: locale.nav_offers,
              leading: IconButton(
                icon: Icon(
                  Icons.confirmation_number_outlined,
                  color: color.onSurface,
                  size: Spacing.iconMd,
                ),
                tooltip: locale.offers_coupon_highlight,
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.promoCodeInput),
              ),
              actions: [
                NotificationButton(
                  hasNotification: true,
                  badgeColor: color.tertiary,
                  onTap: () {},
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<OffersViewModel, OffersState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const OffersLoadingSkeleton();
                  }

                  if (state.failure != null && state.allOffers.isEmpty) {
                    return ApiErrorWidget(
                      exception: state.failure!.exception,
                      onRetry: () => context.read<OffersViewModel>().doIntent(
                        const GetOffersEvent(includeCampaigns: false),
                      ),
                    );
                  }

                  final heroOffer = state.heroOffers.isNotEmpty
                      ? state.heroOffers.first
                      : (state.allOffers.isNotEmpty
                            ? state.allOffers.first
                            : null);

                  final filters = [
                    OfferFilterEntity(
                      label: locale.offers_filter_all,
                      icon: Icons.local_offer_rounded,
                      isSelected: state.selectedCategoryIndex == 0,
                    ),
                    OfferFilterEntity(
                      label: locale.offers_filter_offers,
                      icon: Icons.inventory_2_outlined,
                      isSelected: state.selectedCategoryIndex == 1,
                    ),
                    OfferFilterEntity(
                      label: locale.offers_filter_restaurants,
                      icon: Icons.confirmation_number_outlined,
                      isSelected: state.selectedCategoryIndex == 2,
                    ),
                    OfferFilterEntity(
                      label: locale.offers_filter_meals,
                      icon: Icons.access_time_rounded,
                      isSelected: state.selectedCategoryIndex == 3,
                    ),
                    OfferFilterEntity(
                      label: locale.offers_filter_gifts,
                      icon: Icons.card_giftcard_rounded,
                      isSelected: state.selectedCategoryIndex == 4,
                    ),
                  ];

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<OffersViewModel>().doIntent(
                        const RefreshOffersEvent(includeCampaigns: false),
                      );
                    },
                    child: CustomScrollView(
                      slivers: [
                        if (state.failure != null && state.allOffers.isNotEmpty)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.offersHorizontalPadding,
                                vertical: Spacing.xs,
                              ),
                              child: InlineApiErrorWidget(
                                failure: state.failure!,
                                onRetry: () =>
                                    context.read<OffersViewModel>().doIntent(
                                      const RefreshOffersEvent(
                                        includeCampaigns: false,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        if (state.campaignBanners.isNotEmpty) ...[
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: Spacing.offersHeroHeight,
                              child: PageView.builder(
                                itemCount: state.campaignBanners.length,
                                onPageChanged: (index) =>
                                    _campaignPage.value = index,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Spacing.offersHorizontalPadding,
                                  ),
                                  child: CampaignBannerCard(
                                    offer: state.campaignBanners[index],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                top: Spacing.sm,
                              ),
                              child: ValueListenableBuilder<int>(
                                valueListenable: _campaignPage,
                                builder: (context, index, _) =>
                                    OffersPageIndicator(
                                      itemCount: state.campaignBanners.length,
                                      activeIndex: index.clamp(
                                        0,
                                        state.campaignBanners.length - 1,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: Spacing.sm),
                          ),
                        ] else ...[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.offersHorizontalPadding,
                              ),
                              child: OffersHeroCard(
                                offer: heroOffer,
                                onTap: heroOffer != null
                                    ? () => _onOfferTap(context, heroOffer)
                                    : null,
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(
                                top: Spacing.sm,
                              ),
                              child: OffersPageIndicator(itemCount: 4),
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: Spacing.sm),
                          ),
                        ],
                        SliverToBoxAdapter(
                          child: OffersFilterStrip(
                            filters: filters,
                            onTap: (index) {
                              context.read<OffersViewModel>().doIntent(
                                SelectOfferCategoryEvent(index),
                              );
                            },
                          ),
                        ),
                        // Featured Offers Section (★ عروض مميزة)
                        SliverToBoxAdapter(
                          child: OffersSectionHeader(
                            title: locale.offers_featured_section_title,
                            icon: Icons.star_rounded,
                            iconColor: color.primary,
                          ),
                        ),
                        if (state.readyOffers.isEmpty)
                          SliverToBoxAdapter(
                            child: _buildSectionEmpty(
                              context,
                              locale.offers_ready_empty,
                            ),
                          )
                        else
                          SliverToBoxAdapter(
                            child: AnimatedOfferRow(
                              itemCount: state.readyOffers.length,
                              itemBuilder: (context, index) {
                                final offer = state.readyOffers[index];
                                return OfferDealCard(
                                  key: ValueKey(offer.id),
                                  offer: offer,
                                  onTap: () => _onOfferTap(context, offer),
                                );
                              },
                            ),
                          ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: Spacing.md),
                        ),
                        // Coupon Offers Section (كوبونات الخصم)
                        SliverToBoxAdapter(
                          child: OffersSectionHeader(
                            title: locale.offers_coupons_section_title,
                            icon: Icons.confirmation_number_outlined,
                            iconColor: color.secondary,
                          ),
                        ),
                        if (state.couponOffers.isEmpty)
                          SliverToBoxAdapter(
                            child: _buildSectionEmpty(
                              context,
                              locale.offers_coupons_empty,
                            ),
                          )
                        else
                          SliverToBoxAdapter(
                            child: AnimatedOfferRow(
                              itemCount: state.couponOffers.length,
                              itemBuilder: (context, index) {
                                final offer = state.couponOffers[index];
                                return OfferDealCard(
                                  key: ValueKey(offer.id),
                                  offer: offer,
                                  onTap: () => _onOfferTap(context, offer),
                                );
                              },
                            ),
                          ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: Spacing.base),
                        ),
                        SliverToBoxAdapter(
                          child: OffersCouponBanner(
                            onTap: () => unawaited(
                              Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.promoCodeInput),
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: Spacing.md),
                        ),
                        SliverToBoxAdapter(
                          child: OffersInviteBanner(
                            code: state.referralCode,
                            rewardRate: state.referralRewardRate,
                            onTap: () {
                              final textToShare =
                                  state.referralLink ??
                                  state.referralCode ??
                                  locale.offer_hub_share_message;
                              unawaited(
                                Clipboard.setData(
                                  ClipboardData(text: textToShare),
                                ),
                              );
                              CustomSnackbar.showSuccess(
                                context: context,
                                message:
                                    locale.subscription_success_referral_copied,
                              );
                            },
                          ),
                        ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: Spacing.xxxl * 2),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
