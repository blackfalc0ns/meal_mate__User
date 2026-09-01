import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/influencer/domain/entities/influencer_dashboard_entity.dart';

class InfluencerFakeDataSource {
  const InfluencerFakeDataSource(this.locale);

  final AppLocalizations locale;

  InfluencerDashboardEntity loadDashboard() {
    return InfluencerDashboardEntity(
      userName: locale.influencer_user_name,
      partnerLabel: locale.influencer_partner_label,
      heroImageAsset: AssetsFake.influencerDashboardHero,
      shareBannerAsset: AssetsFake.influencerShareBanner,
      qrAsset: AssetsFake.influencerQr,
      metrics: [
        InfluencerMetricEntity(
          title: locale.influencer_total_earnings,
          value: locale.influencer_total_earnings_value,
          subtitle: locale.influencer_this_month,
        ),
        InfluencerMetricEntity(
          title: locale.influencer_referrals,
          value: locale.influencer_referrals_value,
          subtitle: locale.influencer_active_codes,
        ),
        InfluencerMetricEntity(
          title: locale.influencer_conversion_rate,
          value: locale.influencer_conversion_rate_value,
          subtitle: locale.influencer_from_visits,
        ),
        InfluencerMetricEntity(
          title: locale.influencer_pending_withdrawals,
          value: locale.influencer_pending_withdrawals_value,
          subtitle: locale.influencer_under_review,
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
        totalBalance: locale.influencer_total_earnings_value,
        availableBalance: locale.influencer_pending_withdrawals_value,
        currency: locale.influencer_currency,
        lastUpdated: locale.influencer_wallet_last_updated,
        bankAccount: InfluencerBankAccountEntity(
          accountHolder: locale.influencer_bank_account_holder_value,
          iban: locale.influencer_bank_iban_value,
          bankName: locale.influencer_bank_name_value,
        ),
        transactions: [
          InfluencerTransactionEntity(
            title: locale.influencer_transaction_subscription_commission,
            date: locale.influencer_transaction_today,
            amount: locale.influencer_transaction_amount_large,
            status: locale.wallet_status_completed,
          ),
          InfluencerTransactionEntity(
            title: locale.influencer_transaction_withdraw_request,
            date: locale.influencer_transaction_yesterday,
            amount: locale.influencer_transaction_amount_medium,
            status: locale.wallet_status_processing,
          ),
          InfluencerTransactionEntity(
            title: locale.influencer_transaction_referral_bonus,
            date: locale.influencer_transaction_week,
            amount: locale.influencer_transaction_amount_small,
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
    );
  }
}
