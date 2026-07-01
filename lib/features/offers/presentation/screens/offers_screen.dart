import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/notification_button.dart';
import 'package:meal_meat_user/features/offers/data/offers_fake_data_source.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offer_deal_card.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_bottom_sheet.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_filter_strip.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_hero_card.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_invite_banner.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_section_header.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/restaurant_offer_card.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  static const _dataSource = OffersFakeDataSource();

  @override
  Widget build(BuildContext context) {
    final l10n = context.localization;
    final offers = _dataSource.getOffers();

    return SafeArea(
      child: Column(
        children: [CustomAppBar(showBackButton: false,
                  title: l10n.offers_title,
                  actions: [
                    NotificationButton(onTap: () {}),
                  ],
                ),
          Expanded(
            child: CustomScrollView(
              slivers: [
               
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: OffersHeroCard(hero: offers.hero),
                  ),
                ),
                SliverToBoxAdapter(
                  child: OffersFilterStrip(
                    filters: _dataSource.getOffers().filters,
                  ),
                ),
                SliverToBoxAdapter(
                  child: OffersSectionHeader(
                    actionLabel: l10n.offers_view_all,
                    onActionTap: () {},
                    title: l10n.offers_featured_section_title,
                    icon: Icons.star_rounded,
                    iconColor: const Color(0xFF0C7D37),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 188,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      scrollDirection: Axis.horizontal,
                      itemCount: offers.featuredOffers.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 15),
                      itemBuilder: (context, index) {
                        final offer = offers.featuredOffers[index];
                        return OfferDealCard(
                          offer: offer,
                          onTap: () => OfferDetailsBottomSheet.show(context, offer),
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: OffersSectionHeader(
                    title: l10n.offers_restaurants_section_title,
                    actionLabel: l10n.offers_view_all,
                    onActionTap: () {},
                    actionColor: const Color(0xFF0C7D37),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 175,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                      scrollDirection: Axis.horizontal,
                      itemCount: offers.restaurantOffers.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 13),
                      itemBuilder: (context, index) {
                        final offer = offers.restaurantOffers[index];
                        return RestaurantOfferCard(
                          offer: offer,
                          onTap: () => OfferDetailsBottomSheet.show(context, offer),
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 9),
                    child: OffersInviteBanner(banner: offers.inviteBanner),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 108)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
