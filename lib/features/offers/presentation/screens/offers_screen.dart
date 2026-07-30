import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/notification_button.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_bottom_sheet.dart';
import 'package:meal_meat_user/features/offers/data/offers_fake_data_source.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/animated_offer_row.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offer_deal_card.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_coupon_banner.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_filter_strip.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_hero_card.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_invite_banner.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_page_indicator.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_section_header.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  static const _dataSource = OffersFakeDataSource();
  var _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final offers = _dataSource.getOffers(locale);
    final filters = List.generate(offers.filters.length, (index) {
      final filter = offers.filters[index];
      return OfferFilterEntity(
        label: filter.label,
        icon: filter.icon,
        isSelected: index == _selectedFilterIndex,
      );
    });
    final featuredOffers = _filterOffers(
      offers.featuredOffers,
      _selectedCategory,
    );

    return ColoredBox(
      color: color.surface,
      child: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              showBackButton: false,
              title: locale.offers_title,
              leading: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: color.onSurface,
                  size: Spacing.iconMd,
                  semanticLabel: locale.go_back,
                ),
              ),
              actions: [NotificationButton(onTap: () {})],
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.offersHorizontalPadding,
                      ),
                      child: OffersHeroCard(hero: offers.hero),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(top: Spacing.md),
                      child: OffersPageIndicator(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: OffersFilterStrip(
                      filters: filters,
                      onTap: (index) {
                        if (index == _selectedFilterIndex) return;
                        setState(() => _selectedFilterIndex = index);
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: OffersSectionHeader(
                      title: locale.offers_featured_section_title,
                      icon: Icons.star_rounded,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: AnimatedOfferRow(
                      itemCount: featuredOffers.length,
                      itemBuilder: (context, index) {
                        final offer = featuredOffers[index];
                        return OfferDealCard(
                          key: ValueKey(offer.couponCode ?? offer.title),
                          offer: offer,
                          onTap: () =>
                              OfferDetailsBottomSheet.show(context, offer),
                        );
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        top: Spacing.base,
                      ),
                      child: OffersCouponBanner(banner: offers.couponBanner),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        top: Spacing.base,
                      ),
                      child: OffersInviteBanner(banner: offers.inviteBanner),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: Spacing.xxxl * 3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  OfferCategory? get _selectedCategory {
    return switch (_selectedFilterIndex) {
      1 => OfferCategory.offer,
      3 => OfferCategory.meal,
      _ => null,
    };
  }

  List<OfferDealEntity> _filterOffers(
    List<OfferDealEntity> offers,
    OfferCategory? category,
  ) {
    if (category == null) return offers;
    return offers.where((offer) => offer.category == category).toList();
  }
}
