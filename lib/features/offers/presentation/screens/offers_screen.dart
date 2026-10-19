import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/core/widget/notification_button.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offers_event.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offers_state.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offers_view_model.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/animated_offer_row.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offer_deal_card.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_coupon_banner.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_filter_strip.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_hero_card.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_invite_banner.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_loading_skeleton.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_page_indicator.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_section_header.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OffersViewModel>()..doIntent(const GetOffersEvent()),
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
              actions: [NotificationButton(onTap: () {})],
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
                        const GetOffersEvent(),
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
                      label: locale.offer_browse_tab_all,
                      icon: Icons.dashboard_outlined,
                      isSelected: state.selectedCategoryIndex == 0,
                    ),
                    OfferFilterEntity(
                      label: locale.offer_browse_tab_subscriptions,
                      icon: Icons.card_membership_rounded,
                      isSelected: state.selectedCategoryIndex == 1,
                    ),
                    OfferFilterEntity(
                      label: locale.offer_browse_tab_restaurants,
                      icon: Icons.restaurant_rounded,
                      isSelected: state.selectedCategoryIndex == 2,
                    ),
                    OfferFilterEntity(
                      label: locale.offer_browse_tab_offers,
                      icon: Icons.timer_outlined,
                      isSelected: state.selectedCategoryIndex == 3,
                    ),
                  ];

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<OffersViewModel>().doIntent(
                        const RefreshOffersEvent(),
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
                                onRetry: () => context
                                    .read<OffersViewModel>()
                                    .doIntent(const RefreshOffersEvent()),
                              ),
                            ),
                          ),
                        if (heroOffer != null) ...[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.offersHorizontalPadding,
                              ),
                              child: OffersHeroCard(
                                offer: heroOffer,
                                onTap: () => Navigator.of(context).pushNamed(
                                  AppRoutes.offerDetails,
                                  arguments: heroOffer.id,
                                ),
                              ),
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsetsDirectional.only(
                                top: Spacing.md,
                              ),
                              child: OffersPageIndicator(),
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(height: Spacing.base),
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
                        SliverToBoxAdapter(
                          child: OffersSectionHeader(
                            title: locale.offer_browse_title,
                            actionLabel: locale.offer_hub_view_all,
                            onActionTap: () => Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.browseOffers),
                            icon: Icons.star_rounded,
                          ),
                        ),
                        if (state.filteredOffers.isEmpty)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.offersHorizontalPadding,
                                vertical: Spacing.xl,
                              ),
                              child: EmptyStateWidget(
                                title: locale.offer_browse_empty,
                                description: locale.offer_promo_subtitle,
                                icon: Icons.local_offer_outlined,
                              ),
                            ),
                          )
                        else
                          SliverToBoxAdapter(
                            child: AnimatedOfferRow(
                              itemCount: state.filteredOffers.length,
                              itemBuilder: (context, index) {
                                final offer = state.filteredOffers[index];
                                return OfferDealCard(
                                  key: ValueKey(offer.id),
                                  offer: offer,
                                  onTap: () => Navigator.of(context).pushNamed(
                                    AppRoutes.offerDetails,
                                    arguments: offer.id,
                                  ),
                                );
                              },
                            ),
                          ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: Spacing.lg),
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
                        SliverToBoxAdapter(
                          child: OffersInviteBanner(
                            code: state.referralCode,
                            rewardRate: state.referralRewardRate,
                            onTap: () {
                              final textToShare = state.referralLink ??
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
                          child: SizedBox(height: Spacing.xxxl * 3),
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
