import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import '../../../dashboard/presentation/widgets/influencer_primary_button.dart';
import '../../domain/entities/influencer_social_links_entity.dart';
import '../manager/influencer_social_links_event.dart';
import '../manager/influencer_social_links_state.dart';
import '../manager/influencer_social_links_view_model.dart';

class InfluencerSocialConnectionsScreen extends StatefulWidget {
  const InfluencerSocialConnectionsScreen({
    super.key,
    this.showScaffold = true,
  });
  final bool showScaffold;
  @override
  State<InfluencerSocialConnectionsScreen> createState() =>
      _InfluencerSocialConnectionsScreenState();
}

class _InfluencerSocialConnectionsScreenState
    extends State<InfluencerSocialConnectionsScreen> {
  late final InfluencerSocialLinksViewModel _viewModel;
  late final TextEditingController _instagram;
  late final TextEditingController _tiktok;
  late final TextEditingController _snapchat;
  InfluencerSocialLinksEntity _links = const InfluencerSocialLinksEntity();
  var _initialized = false;
  @override
  void initState() {
    super.initState();
    _viewModel = getIt<InfluencerSocialLinksViewModel>()
      ..doIntent(const LoadInfluencerSocialLinksEvent());
    _instagram = TextEditingController();
    _tiktok = TextEditingController();
    _snapchat = TextEditingController();
  }

  @override
  void dispose() {
    _viewModel.close();
    _instagram.dispose();
    _tiktok.dispose();
    _snapchat.dispose();
    super.dispose();
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
            listenWhen: (_, current) =>
                !_initialized && current.profile != null,
            listener: (_, state) {
              _links = state.profile!.links;
              _instagram.text = _links.instagram ?? '';
              _tiktok.text = _links.tiktok ?? '';
              _snapchat.text = _links.snapchat ?? '';
              _initialized = true;
            },
            builder: (context, state) {
              final content = _content(context, state);
              if (!widget.showScaffold) return content;
              return Scaffold(
                backgroundColor: color.surface,
                appBar: CustomAppBar(
                  title: locale.influencer_social_connections_title,
                  titleFontSize: FontSize.size17,
                  backgroundColor: color.surface,
                  showShadow: false,
                ),
                body: content,
              );
            },
          ),
    );
  }

  Widget _content(BuildContext context, InfluencerSocialLinksState state) {
    final color = context.colorScheme;
    final locale = context.localization;
    if (state.isLoading && state.profile == null) {
      return Center(child: CircularProgressIndicator(color: color.primary));
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
            _field(context, locale.influencer_instagram, _instagram),
            const SizedBox(height: Spacing.sm),
            _field(context, locale.influencer_tiktok, _tiktok),
            const SizedBox(height: Spacing.sm),
            _field(context, locale.influencer_snapchat, _snapchat),
            const SizedBox(height: Spacing.xl),
            InfluencerPrimaryButton(
              label: locale.influencer_save_continue,
              isLoading: state.isSaving,
              onPressed: state.isSaving
                  ? null
                  : () => _viewModel.doIntent(
                      SaveInfluencerSocialLinksEvent(
                        InfluencerSocialLinksEntity(
                          instagram: _normalize(_instagram.text),
                          tiktok: _normalize(_tiktok.text),
                          snapchat: _normalize(_snapchat.text),
                          whatsapp: _links.whatsapp,
                          telegram: _links.telegram,
                          youtube: _links.youtube,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    BuildContext context,
    String label,
    TextEditingController controller,
  ) {
    final color = context.colorScheme;
    return TextFormField(
      controller: controller,
      style: getRegularStyle(
        fontFamily: FontConstant.alexandria,
        fontSize: FontSize.size12,
        color: color.onSurface,
      ),
      decoration: InputDecoration(labelText: label),
    );
  }

  String? _normalize(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return trimmed.startsWith('@') ? trimmed.substring(1) : trimmed;
  }
}
