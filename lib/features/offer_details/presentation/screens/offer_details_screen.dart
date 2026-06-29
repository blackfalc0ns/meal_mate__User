import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/offer_details/data/offer_details_fake_data_source.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_info_card.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_plan_option_card.dart';
import 'package:meal_meat_user/features/offer_details/presentation/widgets/offer_details_summary_card.dart';

class OfferDetailsScreen extends StatefulWidget {
  const OfferDetailsScreen({super.key});

  static const routeName = '/offer-details';

  @override
  State<OfferDetailsScreen> createState() => _OfferDetailsScreenState();
}

class _OfferDetailsScreenState extends State<OfferDetailsScreen> {
  int _selectedPlanIndex = 0;

  static const _dataSource = OfferDetailsFakeDataSource();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final plans = _dataSource.getPlans(l10n);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(l10n),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeroBanner(),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildInfoSection(l10n),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildPlanSection(l10n, plans),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildBottomSummary(l10n, plans),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations l10n) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.close, color: AppColors.textPrimary),
      ),
      title: Text(
        l10n.offer_details_title,
        style: getBoldStyle(
          fontFamily: FontConstant.ibmPlexSansArabic,
          fontSize: FontSize.size16,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/offers/banner_offfer.png',
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildInfoSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.offer_details_info_title,
          style: getBoldStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: FontSize.size16,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        OfferDetailsInfoCard(
          summaryText: l10n.offer_details_info_summary,
          durationText: 'ينتهي خلال 02 يوم : 14 ساعة',
          couponCode: 'SAVE20',
          termsText: l10n.offer_details_info_terms_description,
          accentColor: AppColors.primary,
          onCopyCode: () async {
            await Clipboard.setData(const ClipboardData(text: 'SAVE20'));
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تم نسخ الرمز بنجاح',
                    style: getMediumStyle(
                      fontFamily: FontConstant.ibmPlexSansArabic,
                      fontSize: FontSize.size13,
                      color: AppColors.white,
                    ),
                  ),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildPlanSection(AppLocalizations l10n, List<OfferDetailsPlanData> plans) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.offer_details_plan_section_title,
          style: getBoldStyle(
            fontFamily: FontConstant.ibmPlexSansArabic,
            fontSize: FontSize.size16,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        ...List.generate(plans.length, (index) {
          final plan = plans[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OfferDetailsPlanOptionCard(
              title: plan.title,
              duration: plan.duration,
              meals: plan.meals,
              originalPrice: plan.originalPrice,
              discountedPrice: plan.discountedPrice,
              isSelected: _selectedPlanIndex == index,
              accentColor: AppColors.primary,
              imageAsset: plan.imageAsset,
              onTap: () => setState(() => _selectedPlanIndex = index),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBottomSummary(AppLocalizations l10n, List<OfferDetailsPlanData> plans) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.base),
      child: OfferDetailsSummaryCard(
        title: l10n.offer_details_summary_title,
        totalPrice: plans[_selectedPlanIndex].discountedPrice,
        buttonLabel: l10n.offer_details_summary_button,
        securePaymentLabel: l10n.offer_details_summary_secure_payment,
        onPrimaryPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.offerActivated);
        },
      ),
    );
  }
}
