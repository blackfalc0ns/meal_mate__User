import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/notification_button.dart';
import 'package:meal_meat_user/features/offers/data/offers_fake_data_source.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offers_page_entity.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offer_deal_card.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_bottom_sheet.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_filter_strip.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_hero_card.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_invite_banner.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offers_section_header.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/restaurant_offer_card.dart';

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
    final l10n = context.localization;
    final offers = _dataSource.getOffers();
    final filters = List.generate(offers.filters.length, (index) {
      final filter = offers.filters[index];
      return OfferFilterEntity(
        label: filter.label,
        isSelected: index == _selectedFilterIndex,
      );
    });
    final selectedCategory = _selectedCategory;
    final featuredOffers = _filterOffers(
      offers.featuredOffers,
      selectedCategory,
    );
    final restaurantOffers = _filterOffers(
      offers.restaurantOffers,
      selectedCategory,
    );
    final showFeatured = featuredOffers.isNotEmpty;
    final showRestaurants = restaurantOffers.isNotEmpty;

    return SafeArea(
      child: Column(
        children: [
          CustomAppBar(
            showBackButton: false,
            title: l10n.offers_title,
            actions: [NotificationButton(onTap: () {})],
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
                    filters: filters,
                    onTap: (index) {
                      if (index == _selectedFilterIndex) return;
                      setState(() => _selectedFilterIndex = index);
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 320),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: _buildTabTransition,
                    child: Column(
                      key: ValueKey(_selectedFilterIndex),
                      children: [
                        if (showFeatured) ...[
                          OffersSectionHeader(
                            actionLabel: l10n.offers_view_all,
                            onActionTap: () {},
                            title: _featuredSectionTitle(l10n),
                            icon: Icons.star_rounded,
                            iconColor: const Color(0xFF0C7D37),
                          ),
                          _AnimatedOfferRow(
                            height: 188,
                            itemCount: featuredOffers.length,
                            horizontalPadding: 14,
                            spacing: 15,
                            itemBuilder: (context, index) {
                              final offer = featuredOffers[index];
                              return OfferDealCard(
                                key: ValueKey(offer.couponCode ?? offer.title),
                                offer: offer,
                                onTap: () => OfferDetailsBottomSheet.show(
                                  context,
                                  offer,
                                ),
                              );
                            },
                          ),
                        ],
                        if (showRestaurants) ...[
                          OffersSectionHeader(
                            title: l10n.offers_restaurants_section_title,
                            actionLabel: l10n.offers_view_all,
                            onActionTap: () {},
                            actionColor: const Color(0xFF0C7D37),
                          ),
                          _AnimatedOfferRow(
                            height: 175,
                            itemCount: restaurantOffers.length,
                            horizontalPadding: 9,
                            spacing: 13,
                            itemBuilder: (context, index) {
                              final offer = restaurantOffers[index];
                              return RestaurantOfferCard(
                                key: ValueKey(offer.couponCode ?? offer.title),
                                offer: offer,
                                onTap: () => OfferDetailsBottomSheet.show(
                                  context,
                                  offer,
                                ),
                              );
                            },
                          ),
                        ],
                        if (!showFeatured && !showRestaurants)
                          const SizedBox(height: 80),
                      ],
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

  OfferCategory? get _selectedCategory {
    return switch (_selectedFilterIndex) {
      1 => OfferCategory.offer,
      2 => OfferCategory.restaurant,
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

  String _featuredSectionTitle(AppLocalizations l10n) {
    return _selectedFilterIndex == 3
        ? l10n.offers_filter_meals
        : l10n.offers_featured_section_title;
  }

  Widget _buildTabTransition(Widget child, Animation<double> animation) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.05, 0),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

class _AnimatedOfferRow extends StatefulWidget {
  const _AnimatedOfferRow({
    required this.height,
    required this.itemCount,
    required this.itemBuilder,
    required this.horizontalPadding,
    required this.spacing,
  });

  final double height;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double horizontalPadding;
  final double spacing;

  @override
  State<_AnimatedOfferRow> createState() => _AnimatedOfferRowState();
}

class _AnimatedOfferRowState extends State<_AnimatedOfferRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    )..forward();
  }

  @override
  void didUpdateWidget(covariant _AnimatedOfferRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemCount != widget.itemCount ||
        oldWidget.height != widget.height) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
        scrollDirection: Axis.horizontal,
        itemCount: widget.itemCount,
        separatorBuilder: (_, _) => SizedBox(width: widget.spacing),
        itemBuilder: (context, index) {
          final start = (index * 0.08).clamp(0.0, 0.48);
          final animation = CurvedAnimation(
            parent: _controller,
            curve: Interval(start, 1, curve: Curves.easeOutBack),
          );

          return AnimatedBuilder(
            animation: animation,
            child: widget.itemBuilder(context, index),
            builder: (context, child) {
              final value = animation.value;
              return Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset((1 - value) * 30, 0),
                  child: Transform.scale(
                    scale: 0.92 + (value * 0.08),
                    child: child,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
