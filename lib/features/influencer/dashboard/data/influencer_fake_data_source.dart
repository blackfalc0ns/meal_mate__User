import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/influencer/dashboard/domain/entities/influencer_dashboard_entity.dart';

class InfluencerFakeDataSource {
  const InfluencerFakeDataSource(this.locale);

  final AppLocalizations locale;

  InfluencerDashboardEntity loadDashboard() {
    final periodData = _loadStatisticsPeriodData();
    final selectedPeriodIndex = 3;
    final selectedPeriodData = periodData[selectedPeriodIndex];

    return InfluencerDashboardEntity(
      userName: locale.influencer_user_name,
      partnerLabel: locale.influencer_partner_label,
      heroImageAsset: AssetsFake.influencerDashboardHero,
      shareBannerAsset: AssetsFake.influencerShareBanner,
      qrAsset: AssetsFake.influencerQr,
      avatarAsset: AssetsFake.influencerDashboardAvatar,
      logoAsset: AssetsFake.influencerLogo,
      shareIconAsset: AssetsFake.influencerShareIcon,
      copyIconAsset: AssetsFake.influencerCopyIcon,
      trendIconAsset: AssetsFake.influencerTrendUp,
      metrics: [
        InfluencerMetricEntity(
          title: locale.influencer_referrals,
          value: locale.influencer_referrals_value,
          subtitle: locale.influencer_active_codes,
          iconAsset: AssetsFake.influencerMetricUsers,
          trendIconAsset: AssetsFake.influencerTrendUp,
        ),
        InfluencerMetricEntity(
          title: locale.influencer_completed_subscriptions,
          value: locale.influencer_completed_subscriptions_value,
          subtitle: locale.influencer_active_codes,
          iconAsset: AssetsFake.influencerMetricSubscriptions,
          trendIconAsset: AssetsFake.influencerTrendUp,
        ),
        InfluencerMetricEntity(
          title: locale.influencer_pending_withdrawals,
          value: locale.influencer_pending_withdrawals_value,
          subtitle: locale.influencer_under_review,
          iconAsset: AssetsFake.influencerMetricClicks,
          trendIconAsset: AssetsFake.influencerTrendUp,
        ),
        InfluencerMetricEntity(
          title: locale.influencer_conversion_rate,
          value: locale.influencer_conversion_rate_value,
          subtitle: locale.influencer_from_visits,
          iconAsset: AssetsFake.influencerMetricConversion,
          trendIconAsset: AssetsFake.influencerTrendUp,
        ),
      ],
      actions: [
        InfluencerActionEntity(
          title: locale.influencer_share_links_title,
          subtitle: locale.influencer_share_links_subtitle,
          icon: InfluencerActionIcon.share,
          routeName: AppRoutes.influencerShareLinks,
        ),
        InfluencerActionEntity(
          title: locale.influencer_social_connections_title,
          subtitle: locale.influencer_social_connections_subtitle,
          icon: InfluencerActionIcon.social,
          routeName: AppRoutes.influencerSocialConnections,
        ),
        InfluencerActionEntity(
          title: locale.influencer_wallet_title,
          subtitle: locale.influencer_wallet_subtitle,
          icon: InfluencerActionIcon.wallet,
          routeName: AppRoutes.influencerWallet,
        ),
      ],
      wallet: InfluencerWalletEntity(
        totalBalance: locale.influencer_wallet_total_balance_value,
        availableBalance: locale.influencer_total_earnings_value,
        currency: locale.influencer_currency,
        lastUpdated: locale.influencer_wallet_last_updated,
        bankAccount: InfluencerBankAccountEntity(
          accountHolder: locale.influencer_bank_account_holder_value,
          iban: locale.influencer_bank_iban_value,
          bankName: locale.influencer_bank_name_value,
        ),
        monthlySummary: [
          InfluencerWalletSummaryMetricEntity(
            title: locale.influencer_wallet_summary_withdrawn,
            value: locale.influencer_wallet_withdrawn_value,
            currency: locale.influencer_currency,
            icon: InfluencerWalletSummaryIcon.withdrawn,
          ),
          InfluencerWalletSummaryMetricEntity(
            title: locale.influencer_wallet_summary_total_earnings,
            value: locale.influencer_total_earnings_value,
            currency: locale.influencer_currency,
            icon: InfluencerWalletSummaryIcon.earnings,
          ),
        ],
        transactions: [
          InfluencerTransactionEntity(
            title: locale.influencer_transaction_new_referral,
            date: locale.influencer_transaction_25_may_2025,
            amount: locale.influencer_transaction_amount_positive_120,
            status: locale.wallet_status_completed,
          ),
          InfluencerTransactionEntity(
            title: locale.influencer_transaction_bank_withdrawal,
            date: locale.influencer_transaction_25_may_2025,
            amount: locale.influencer_transaction_amount_negative_120,
            status: locale.wallet_status_processing,
            isDebit: true,
          ),
          InfluencerTransactionEntity(
            title: locale.influencer_transaction_premium_order_completed,
            date: locale.influencer_transaction_25_may_2025,
            amount: locale.influencer_transaction_amount_positive_120,
            status: locale.wallet_status_completed,
          ),
          InfluencerTransactionEntity(
            title: locale.influencer_transaction_new_referral,
            date: locale.influencer_transaction_25_may_2025,
            amount: locale.influencer_transaction_amount_positive_120,
            status: locale.wallet_status_completed,
          ),
        ],
      ),
      socialAccounts: [
        InfluencerSocialAccountEntity(
          platform: locale.influencer_instagram,
          handle: '@mealmate.fit',
          connected: true,
        ),
        InfluencerSocialAccountEntity(
          platform: locale.influencer_tiktok,
          handle: '@mealmate.daily',
          connected: true,
        ),
        InfluencerSocialAccountEntity(
          platform: locale.influencer_snapchat,
          handle: locale.influencer_not_connected,
          connected: false,
        ),
      ],
      activities: [
        InfluencerActivityEntity(
          title: locale.influencer_activity_first_user,
          subtitle: locale.influencer_activity_first_plan,
          amount: locale.influencer_activity_amount,
          time: locale.influencer_activity_time,
          avatarAsset: AssetsFake.influencerDashboardAvatar,
        ),
        InfluencerActivityEntity(
          title: locale.influencer_activity_second_user,
          subtitle: locale.influencer_activity_second_plan,
          amount: locale.influencer_activity_amount,
          time: locale.influencer_activity_time,
          avatarAsset: AssetsFake.influencerDashboardAvatar,
        ),
        InfluencerActivityEntity(
          title: locale.influencer_activity_third_user,
          subtitle: locale.influencer_activity_third_plan,
          amount: locale.influencer_activity_amount,
          time: locale.influencer_activity_time,
          avatarAsset: AssetsFake.influencerDashboardAvatar,
        ),
      ],
      statistics: InfluencerStatisticsEntity(
        periods: [
          locale.influencer_period_year,
          locale.influencer_period_6_months,
          locale.influencer_period_90_days,
          locale.influencer_period_30_days,
          locale.influencer_period_7_days,
        ],
        selectedPeriodIndex: selectedPeriodIndex,
        summary: selectedPeriodData.summary,
        overviewMetrics: selectedPeriodData.overviewMetrics,
        revenuePoints: selectedPeriodData.revenuePoints,
        revenueBars: selectedPeriodData.revenueBars,
        periodData: periodData,
        topProduct: InfluencerTopProductEntity(
          rank: '1',
          name: locale.influencer_top_product_name,
          orders: locale.influencer_top_product_orders_value,
          ordersLabel: locale.influencer_orders_label,
          revenueLabel: locale.influencer_product_revenue_label,
          revenue: locale.influencer_top_product_revenue_value,
        ),
      ),
      shareLinks: InfluencerShareLinksEntity(
        title: 'روابط المشاركة',
        subtitle: 'شارك رابطك وكودك واحصل على عمولات أكثر',
        bannerTitle: 'كل ما تشارك أكثر',
        bannerHighlight: 'تكسب أكثر!',
        bannerSubtitle: 'شارك رابطك مع اصدقائك',
        bannerFooter: 'واحصل على عمولات من كل طلب',
        discountCodeTitle: 'كود الخصم الخاص بك',
        discountCode: 'Mealmate20',
        discountBadgePrefix: 'خصم ',
        discountBadgeValue: '20%',
        discountBadgeSuffix: ' للعملاء الجدد',
        copyCodeLabel: 'نسخ الكود',
        qrLabel: 'امسح للمشاركة',
        referralLinkTitle: 'رابط الإحالة الخاص بك',
        referralLink: 'https://mealmate.com/ref/Mealmate20',
        copyLinkLabel: 'نسخ الرابط',
        shareNowTitle: 'شارك الآن',
        shareNowSubtitle: 'شارك يسهولة عبر منصات التواصل',
        quickStatsTitle: 'مشاركة سريعة',
        quickStatsSubtitle: 'أداؤك في مشاركة الروابط',
        socialPlatforms: const [
          InfluencerShareSocialPlatformEntity(
            label: 'واتساب',
            iconAsset: AssetsFake.influencerSocialWhatsapp,
          ),
          InfluencerShareSocialPlatformEntity(
            label: 'إنستغرام',
            iconAsset: AssetsFake.influencerSocialInstagram,
          ),
          InfluencerShareSocialPlatformEntity(
            label: 'تيليجرام',
            iconAsset: AssetsFake.influencerSocialTelegram,
          ),
          InfluencerShareSocialPlatformEntity(
            label: 'تيك توك',
            iconAsset: AssetsFake.influencerSocialTiktok,
          ),
          InfluencerShareSocialPlatformEntity(
            label: 'المزيد',
            iconAsset: AssetsFake.influencerSocialMore,
            drawDotsIcon: true,
          ),
        ],
        quickStats: const [
          InfluencerShareQuickStatEntity(
            label: 'النقرات على الرابط',
            value: '520',
            iconAsset: AssetsFake.influencerQuickStatClicks,
          ),
          InfluencerShareQuickStatEntity(
            label: 'الطلبات الناتجة',
            value: '68',
            iconAsset: AssetsFake.influencerQuickStatOrders,
          ),
          InfluencerShareQuickStatEntity(
            label: 'التحويلات',
            value: '35%',
            iconAsset: AssetsFake.influencerQuickStatConversion,
          ),
        ],
      ),
    );
  }

  List<InfluencerStatisticsPeriodDataEntity> _loadStatisticsPeriodData() {
    return [
      _statisticsPeriodData(
        value: '3240',
        gain: 'KWD 420+',
        growthPercent: '+18.5%',
        comparisonLabel: 'مقارنة بالسنة السابقة',
        referrals: '920',
        orders: '310',
        withdrawals: '1240',
        conversionRate: '42%',
        points: const [
          InfluencerChartPointEntity(label: 'Jan', value: 180),
          InfluencerChartPointEntity(label: 'Mar', value: 210),
          InfluencerChartPointEntity(label: 'May', value: 230),
          InfluencerChartPointEntity(label: 'Jul', value: 260),
          InfluencerChartPointEntity(label: 'Sep', value: 240),
          InfluencerChartPointEntity(label: 'Nov', value: 280),
        ],
      ),
      _statisticsPeriodData(
        value: '1860',
        gain: 'KWD 260+',
        growthPercent: '+12.2%',
        comparisonLabel: 'مقارنة بالـ 6 أشهر السابقة',
        referrals: '510',
        orders: '168',
        withdrawals: '730',
        conversionRate: '39%',
        points: const [
          InfluencerChartPointEntity(label: 'May', value: 140),
          InfluencerChartPointEntity(label: 'Jun', value: 165),
          InfluencerChartPointEntity(label: 'Jul', value: 190),
          InfluencerChartPointEntity(label: 'Aug', value: 220),
          InfluencerChartPointEntity(label: 'Sep', value: 205),
          InfluencerChartPointEntity(label: 'Oct', value: 240),
        ],
      ),
      _statisticsPeriodData(
        value: '1245',
        gain: 'KWD 165+',
        growthPercent: '+8.1%',
        comparisonLabel: 'مقارنة بالـ 90 يوم السابقة',
        referrals: '230',
        orders: '68',
        withdrawals: '520',
        conversionRate: '35%',
        points: const [
          InfluencerChartPointEntity(label: 'Apr 20', value: 120),
          InfluencerChartPointEntity(label: 'May 4', value: 150),
          InfluencerChartPointEntity(label: 'May 18', value: 180),
          InfluencerChartPointEntity(label: 'Jun 1', value: 210),
          InfluencerChartPointEntity(label: 'Jun 15', value: 170),
          InfluencerChartPointEntity(label: 'Jun 29', value: 210),
        ],
      ),
      _statisticsPeriodData(
        value: '845',
        gain: 'KWD 35+',
        growthPercent: '+4.3%',
        comparisonLabel: 'مقارنة بالـ 30 يوم السابقة',
        referrals: '230',
        orders: '68',
        withdrawals: '520',
        conversionRate: '35%',
        points: const [
          InfluencerChartPointEntity(label: 'Apr 20', value: 120),
          InfluencerChartPointEntity(label: 'Apr 27', value: 150),
          InfluencerChartPointEntity(label: 'May 4', value: 180),
          InfluencerChartPointEntity(label: 'May 11', value: 210),
          InfluencerChartPointEntity(label: 'May 18', value: 170),
          InfluencerChartPointEntity(label: 'May 25', value: 210),
        ],
      ),
      _statisticsPeriodData(
        value: '215',
        gain: 'KWD 18+',
        growthPercent: '+2.6%',
        comparisonLabel: 'مقارنة بالـ 7 أيام السابقة',
        referrals: '64',
        orders: '19',
        withdrawals: '135',
        conversionRate: '31%',
        points: const [
          InfluencerChartPointEntity(label: 'Sat', value: 24),
          InfluencerChartPointEntity(label: 'Sun', value: 28),
          InfluencerChartPointEntity(label: 'Mon', value: 32),
          InfluencerChartPointEntity(label: 'Tue', value: 26),
          InfluencerChartPointEntity(label: 'Wed', value: 36),
          InfluencerChartPointEntity(label: 'Thu', value: 42),
        ],
      ),
    ];
  }

  InfluencerStatisticsPeriodDataEntity _statisticsPeriodData({
    required String value,
    required String gain,
    required String growthPercent,
    required String comparisonLabel,
    required String referrals,
    required String orders,
    required String withdrawals,
    required String conversionRate,
    required List<InfluencerChartPointEntity> points,
  }) {
    return InfluencerStatisticsPeriodDataEntity(
      summary: InfluencerStatisticsSummaryEntity(
        title: locale.influencer_total_earnings,
        value: value,
        currency: 'KWD',
        gain: gain,
        growthPercent: growthPercent,
        comparisonLabel: comparisonLabel,
        dateLabels: points.map((point) => point.label).toList(),
      ),
      overviewMetrics: [
        InfluencerMetricEntity(
          title: locale.influencer_referrals,
          value: referrals,
          subtitle: comparisonLabel,
          iconAsset: AssetsFake.influencerMetricUsers,
          trendIconAsset: AssetsFake.influencerTrendUp,
        ),
        InfluencerMetricEntity(
          title: locale.influencer_generated_orders,
          value: orders,
          subtitle: comparisonLabel,
          iconAsset: AssetsFake.influencerMetricSubscriptions,
          trendIconAsset: AssetsFake.influencerTrendUp,
        ),
        InfluencerMetricEntity(
          title: locale.influencer_pending_withdrawals,
          value: withdrawals,
          subtitle: comparisonLabel,
          iconAsset: AssetsFake.influencerMetricClicks,
          trendIconAsset: AssetsFake.influencerTrendUp,
        ),
        InfluencerMetricEntity(
          title: locale.influencer_conversion_rate,
          value: conversionRate,
          subtitle: comparisonLabel,
          iconAsset: AssetsFake.influencerMetricConversion,
          trendIconAsset: AssetsFake.influencerTrendUp,
        ),
      ],
      revenuePoints: points,
      revenueBars: points,
    );
  }
}
