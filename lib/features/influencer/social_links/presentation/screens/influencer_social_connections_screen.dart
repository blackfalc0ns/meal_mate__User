import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/constants/assets_fake.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_message_presenter.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import '../../../dashboard/presentation/widgets/influencer_header_card.dart';
import '../../domain/entities/influencer_social_links_entity.dart';
import '../manager/influencer_social_links_event.dart';
import '../manager/influencer_social_links_state.dart';
import '../manager/influencer_social_links_view_model.dart';
import '../models/influencer_social_item_view_data.dart';
import '../widgets/influencer_social_action_buttons.dart';
import '../widgets/influencer_social_connection_card.dart';
import '../widgets/influencer_social_connections_loading_skeleton.dart';
import '../widgets/influencer_social_input_sheet.dart';
import '../widgets/influencer_social_privacy_card.dart';
import '../widgets/influencer_social_title_section.dart';

class InfluencerSocialConnectionsScreen extends StatefulWidget {
  const InfluencerSocialConnectionsScreen({
    super.key,
    this.showScaffold = true,
    this.viewModel,
  });

  final bool showScaffold;
  final InfluencerSocialLinksViewModel? viewModel;

  @override
  State<InfluencerSocialConnectionsScreen> createState() =>
      _InfluencerSocialConnectionsScreenState();
}

class _InfluencerSocialConnectionsScreenState
    extends State<InfluencerSocialConnectionsScreen> {
  late final InfluencerSocialLinksViewModel _viewModel;
  final ValueNotifier<String?> _tiktokHandle = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _instagramHandle = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _whatsappHandle = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _telegramHandle = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _youtubeHandle = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _snapchatHandle = ValueNotifier<String?>(null);
  var _initialized = false;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? getIt<InfluencerSocialLinksViewModel>()
      ..doIntent(const LoadInfluencerSocialLinksEvent());
  }

  @override
  void dispose() {
    _tiktokHandle.dispose();
    _instagramHandle.dispose();
    _whatsappHandle.dispose();
    _telegramHandle.dispose();
    _youtubeHandle.dispose();
    _snapchatHandle.dispose();
    _viewModel.close();
    super.dispose();
  }

  void _onSave() {
    _viewModel.doIntent(
      SaveInfluencerSocialLinksEvent(
        InfluencerSocialLinksEntity(
          tiktok: _normalize(_tiktokHandle.value),
          instagram: _normalize(_instagramHandle.value),
          whatsapp: _normalize(_whatsappHandle.value),
          telegram: _normalize(_telegramHandle.value),
          youtube: _normalize(_youtubeHandle.value),
          snapchat: _normalize(_snapchatHandle.value),
        ),
      ),
    );
  }

  void _onSkip() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  String? _normalize(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return trimmed.startsWith('@') ? trimmed.substring(1) : trimmed;
  }

  void _openInputSheet(
    BuildContext context,
    InfluencerSocialItemViewData item,
    ValueNotifier<String?> notifier,
  ) {
    InfluencerSocialInputSheet.show(
      context: context,
      item: item,
      initialValue: notifier.value ?? '',
      onSaved: (value) => notifier.value = _normalize(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider.value(
      value: _viewModel,
      child:
          BlocConsumer<
            InfluencerSocialLinksViewModel,
            InfluencerSocialLinksState
          >(
            listenWhen: (previous, current) {
              if (!_initialized && current.profile != null) return true;
              if (!previous.isSuccess && current.isSuccess) return true;
              if (previous.failure != current.failure &&
                  current.failure != null)
                return true;
              return false;
            },
            listener: (context, state) {
              if (!_initialized && state.profile != null) {
                final links = state.profile!.links;
                _tiktokHandle.value = links.tiktok;
                _instagramHandle.value = links.instagram;
                _whatsappHandle.value = links.whatsapp;
                _telegramHandle.value = links.telegram;
                _youtubeHandle.value = links.youtube;
                _snapchatHandle.value = links.snapchat;
                _initialized = true;
              }
              if (state.failure != null &&
                  (state.profile != null || !state.isSaving)) {
                CustomSnackbar.showError(
                  context: context,
                  message: ErrorMessagePresenter.fromFailure(
                    context,
                    state.failure!,
                  ),
                );
              }
              if (state.isSuccess && Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              final content = _content(context, state);
              if (!widget.showScaffold) return content;
              return Scaffold(
                backgroundColor: color.surface,
                appBar: InfluencerHeaderCard(
                  userName: locale.influencer_header_greeting,
                  partnerLabel: locale.influencer_partner_label,
                  avatarAsset: AssetsFake.influencerDashboardAvatar,
                  logoAsset: AssetsFake.influencerLogo,
                ),
                body: content,
              );
            },
          ),
    );
  }

  Widget _content(BuildContext context, InfluencerSocialLinksState state) {
    final locale = context.localization;

    if (state.isLoading && state.profile == null) {
      return const InfluencerSocialConnectionsLoadingSkeleton();
    }
    if (state.failure != null && state.profile == null) {
      return ApiErrorWidget(
        exception: state.failure!.exception,
        onRetry: () => _viewModel.doIntent(
          const LoadInfluencerSocialLinksEvent(forceRefresh: true),
        ),
      );
    }

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.only(
          start: Spacing.screenH,
          top: Spacing.md,
          end: Spacing.screenH,
          bottom: Spacing.xxxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InfluencerSocialTitleSection(
              title: locale.influencer_social_connections_header,
              subtitle: locale.influencer_social_connections_body,
            ),
            const SizedBox(height: Spacing.lg),
            ValueListenableBuilder<String?>(
              valueListenable: _tiktokHandle,
              builder: (context, handle, _) {
                final item = InfluencerSocialItemViewData(
                  platform: InfluencerSocialPlatform.tiktok,
                  title: locale.influencer_tiktok,
                  subtitle: locale.influencer_tiktok_subtitle,
                  iconAsset: AssetsFake.influencerSocialTiktok,
                  handle: handle,
                  onTap: () => _openInputSheet(
                    context,
                    InfluencerSocialItemViewData(
                      platform: InfluencerSocialPlatform.tiktok,
                      title: locale.influencer_tiktok,
                      subtitle: locale.influencer_tiktok_subtitle,
                      iconAsset: AssetsFake.influencerSocialTiktok,
                      handle: handle,
                    ),
                    _tiktokHandle,
                  ),
                );
                return InfluencerSocialConnectionCard(item: item);
              },
            ),
            const SizedBox(height: Spacing.influencerSocialCardsGap),
            ValueListenableBuilder<String?>(
              valueListenable: _instagramHandle,
              builder: (context, handle, _) {
                final item = InfluencerSocialItemViewData(
                  platform: InfluencerSocialPlatform.instagram,
                  title: locale.influencer_instagram,
                  subtitle: locale.influencer_instagram_subtitle,
                  iconAsset: AssetsFake.influencerSocialInstagram,
                  handle: handle,
                  onTap: () => _openInputSheet(
                    context,
                    InfluencerSocialItemViewData(
                      platform: InfluencerSocialPlatform.instagram,
                      title: locale.influencer_instagram,
                      subtitle: locale.influencer_instagram_subtitle,
                      iconAsset: AssetsFake.influencerSocialInstagram,
                      handle: handle,
                    ),
                    _instagramHandle,
                  ),
                );
                return InfluencerSocialConnectionCard(item: item);
              },
            ),
            const SizedBox(height: Spacing.influencerSocialCardsGap),
            ValueListenableBuilder<String?>(
              valueListenable: _whatsappHandle,
              builder: (context, handle, _) {
                final item = InfluencerSocialItemViewData(
                  platform: InfluencerSocialPlatform.whatsapp,
                  title: locale.influencer_whatsapp,
                  subtitle: locale.influencer_whatsapp_subtitle,
                  iconAsset: AssetsFake.influencerSocialWhatsapp,
                  handle: handle,
                  onTap: () => _openInputSheet(
                    context,
                    InfluencerSocialItemViewData(
                      platform: InfluencerSocialPlatform.whatsapp,
                      title: locale.influencer_whatsapp,
                      subtitle: locale.influencer_whatsapp_subtitle,
                      iconAsset: AssetsFake.influencerSocialWhatsapp,
                      handle: handle,
                    ),
                    _whatsappHandle,
                  ),
                );
                return InfluencerSocialConnectionCard(item: item);
              },
            ),
            const SizedBox(height: Spacing.influencerSocialCardsGap),
            ValueListenableBuilder<String?>(
              valueListenable: _telegramHandle,
              builder: (context, handle, _) {
                final item = InfluencerSocialItemViewData(
                  platform: InfluencerSocialPlatform.telegram,
                  title: locale.influencer_telegram,
                  subtitle: locale.influencer_telegram_subtitle,
                  iconAsset: AssetsFake.influencerSocialTelegram,
                  handle: handle,
                  onTap: () => _openInputSheet(
                    context,
                    InfluencerSocialItemViewData(
                      platform: InfluencerSocialPlatform.telegram,
                      title: locale.influencer_telegram,
                      subtitle: locale.influencer_telegram_subtitle,
                      iconAsset: AssetsFake.influencerSocialTelegram,
                      handle: handle,
                    ),
                    _telegramHandle,
                  ),
                );
                return InfluencerSocialConnectionCard(item: item);
              },
            ),
            const SizedBox(height: Spacing.influencerSocialCardsGap),
            ValueListenableBuilder<String?>(
              valueListenable: _youtubeHandle,
              builder: (context, handle, _) {
                final item = InfluencerSocialItemViewData(
                  platform: InfluencerSocialPlatform.youtube,
                  title: locale.influencer_youtube,
                  subtitle: locale.influencer_youtube_subtitle,
                  iconAsset: AssetsFake.influencerSocialYoutube,
                  handle: handle,
                  onTap: () => _openInputSheet(
                    context,
                    InfluencerSocialItemViewData(
                      platform: InfluencerSocialPlatform.youtube,
                      title: locale.influencer_youtube,
                      subtitle: locale.influencer_youtube_subtitle,
                      iconAsset: AssetsFake.influencerSocialYoutube,
                      handle: handle,
                    ),
                    _youtubeHandle,
                  ),
                );
                return InfluencerSocialConnectionCard(item: item);
              },
            ),
            const SizedBox(height: Spacing.influencerSocialCardsGap),
            ValueListenableBuilder<String?>(
              valueListenable: _snapchatHandle,
              builder: (context, handle, _) {
                final item = InfluencerSocialItemViewData(
                  platform: InfluencerSocialPlatform.snapchat,
                  title: locale.influencer_snapchat,
                  subtitle: locale.influencer_snapchat_subtitle,
                  iconAsset: AssetsFake.influencerSocialSnapchat,
                  handle: handle,
                  onTap: () => _openInputSheet(
                    context,
                    InfluencerSocialItemViewData(
                      platform: InfluencerSocialPlatform.snapchat,
                      title: locale.influencer_snapchat,
                      subtitle: locale.influencer_snapchat_subtitle,
                      iconAsset: AssetsFake.influencerSocialSnapchat,
                      handle: handle,
                    ),
                    _snapchatHandle,
                  ),
                );
                return InfluencerSocialConnectionCard(item: item);
              },
            ),
            const SizedBox(height: Spacing.md),
            const InfluencerSocialPrivacyCard(),
            const SizedBox(height: Spacing.xl),
            BlocSelector<
              InfluencerSocialLinksViewModel,
              InfluencerSocialLinksState,
              bool
            >(
              selector: (state) => state.isSaving,
              builder: (context, isSaving) {
                return InfluencerSocialActionButtons(
                  isLoading: isSaving,
                  onSave: _onSave,
                  onSkip: _onSkip,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
