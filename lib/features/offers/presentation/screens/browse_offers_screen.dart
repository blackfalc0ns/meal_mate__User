import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/offers/domain/entities/offer_entity.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offers_event.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offers_state.dart';
import 'package:meal_meat_user/features/offers/presentation/manager/offers_view_model.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/browse_offers_loading_skeleton.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offer_browse_card.dart';
import 'package:meal_meat_user/features/offers/presentation/widgets/offer_quick_preview_sheet.dart';

class BrowseOffersScreen extends StatelessWidget {
  const BrowseOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OffersViewModel>()..doIntent(const GetOffersEvent()),
      child: const _BrowseOffersContent(),
    );
  }
}

class _BrowseOffersContent extends StatelessWidget {
  const _BrowseOffersContent();

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final tabLabels = [
      locale.offer_browse_tab_all,
      locale.offer_browse_tab_subscriptions,
      locale.offer_browse_tab_restaurants,
      locale.offer_browse_tab_offers,
    ];

    return Scaffold(
      backgroundColor: color.surface,
      appBar: CustomAppBar(
        title: locale.offer_browse_title,
        showBackButton: true,
      ),
      body: BlocBuilder<OffersViewModel, OffersState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const BrowseOffersLoadingSkeleton();
          }

          if (state.failure != null && state.allOffers.isEmpty) {
            return ApiErrorWidget(
              exception: state.failure!.exception,
              onRetry: () => context.read<OffersViewModel>().doIntent(
                const GetOffersEvent(),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<OffersViewModel>().doIntent(
                const RefreshOffersEvent(),
              );
            },
            child: CustomScrollView(
              slivers: [
                // Filter Tabs Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.md,
                      vertical: Spacing.sm,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(tabLabels.length, (index) {
                          final isSelected =
                              state.selectedCategoryIndex == index;
                          return Padding(
                            padding: const EdgeInsetsDirectional.only(
                              end: Spacing.sm,
                            ),
                            child: ChoiceChip(
                              label: Text(
                                tabLabels[index],
                                style: getMediumStyle(
                                  fontFamily: FontConstant.alexandria,
                                  fontSize: FontSize.size13,
                                  color: isSelected
                                      ? color.onPrimary
                                      : color.onSurfaceVariant,
                                ),
                              ),
                              selected: isSelected,
                              selectedColor: color.primary,
                              backgroundColor: color.surfaceContainerLow,
                              showCheckmark: false,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Spacing.sm),
                                side: BorderSide(
                                  color: isSelected
                                      ? color.primary
                                      : color.outlineVariant,
                                ),
                              ),
                              onSelected: (_) {
                                context.read<OffersViewModel>().doIntent(
                                  SelectOfferCategoryEvent(index),
                                );
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),

                if (state.failure != null && state.allOffers.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.md,
                        vertical: Spacing.xs,
                      ),
                      child: InlineApiErrorWidget(
                        failure: state.failure!,
                        onRetry: () => context.read<OffersViewModel>().doIntent(
                          const RefreshOffersEvent(),
                        ),
                      ),
                    ),
                  ),

                if (state.filteredOffers.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyStateWidget(
                      title: locale.offer_browse_title,
                      description: locale.offer_browse_empty,
                      icon: Icons.local_offer_outlined,
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(Spacing.md),
                    sliver: SliverList.separated(
                      itemCount: state.filteredOffers.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: Spacing.md),
                      itemBuilder: (context, index) {
                        final offer = state.filteredOffers[index];
                        return OfferBrowseCard(
                          offer: offer,
                          onTap: () => _openOfferDetails(context, offer),
                          onActionTap: () => _openQuickSheet(context, offer),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _openOfferDetails(BuildContext context, OfferEntity offer) {
    Navigator.of(
      context,
    ).pushNamed(AppRoutes.offerDetails, arguments: offer.id);
  }

  void _openQuickSheet(BuildContext context, OfferEntity offer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OfferQuickPreviewSheet(offer: offer),
    );
  }
}
