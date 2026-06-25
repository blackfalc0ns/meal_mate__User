import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/notification_button.dart';
import 'package:meal_meat_user/features/offers/data/offers_fake_data_source.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offer_deal_card.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_hero_card.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_section_header.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/restaurant_offer_card.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  static const _dataSource = OffersFakeDataSource();

  @override
  Widget build(BuildContext context) {
    final offers = _dataSource.getOffers();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF4FBF5), Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: CustomAppBar(
                title: 'العروض',
               leading:NotificationButton( onTap: () {}),
              ),
            ),
            SliverToBoxAdapter(
              child: OffersHeroCard(hero: offers.hero),
            ),
            SliverToBoxAdapter(
              child: OffersSectionHeader(actionLabel: 'عرض الكل', onActionTap: () {},
                title: 'عروض مميزة',
                icon: Icons.star_rounded,
                iconColor: const Color(0xFF0C7D37),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 250,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: offers.featuredOffers.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 6),
                  itemBuilder: (context, index) {
                    return OfferDealCard(offer: offers.featuredOffers[index]);
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: OffersSectionHeader(
                title: 'عروض المطاعم',
                actionLabel: 'عرض الكل',
                onActionTap: () {},
                actionColor: const Color(0xFF0C7D37),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 217,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: offers.restaurantOffers.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 6),
                  itemBuilder: (context, index) {
                    return RestaurantOfferCard(
                      offer: offers.restaurantOffers[index],
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 110)),
          ],
        ),
      ),
    );
  }
}
