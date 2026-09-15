import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import '../models/influencer_social_item_view_data.dart';

class InfluencerSocialInputSheet extends StatefulWidget {
  const InfluencerSocialInputSheet({
    super.key,
    required this.item,
    required this.initialValue,
    required this.onSaved,
  });

  final InfluencerSocialItemViewData item;
  final String initialValue;
  final ValueChanged<String> onSaved;

  static Future<void> show({
    required BuildContext context,
    required InfluencerSocialItemViewData item,
    required String initialValue,
    required ValueChanged<String> onSaved,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Spacing.radiusLg),
        ),
      ),
      builder: (_) => InfluencerSocialInputSheet(
        item: item,
        initialValue: initialValue,
        onSaved: onSaved,
      ),
    );
  }

  @override
  State<InfluencerSocialInputSheet> createState() =>
      _InfluencerSocialInputSheetState();
}

class _InfluencerSocialInputSheetState
    extends State<InfluencerSocialInputSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    widget.onSaved(text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: Spacing.screenH,
        end: Spacing.screenH,
        top: Spacing.lg,
        bottom: Spacing.lg + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                widget.item.iconAsset,
                width: Spacing.influencerSocialIconSize,
                height: Spacing.influencerSocialIconSize,
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: Text(
                  widget.item.title,
                  style: getBoldStyle(
                    fontFamily: FontConstant.alexandria,
                    fontSize: FontSize.size16,
                    color: color.onSurface,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: color.onSurfaceVariant,
                  size: Spacing.iconSm,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            widget.item.subtitle,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size12,
              color: color.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.md),
          TextFormField(
            controller: _controller,
            autofocus: true,
            style: getRegularStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size14,
              color: color.onSurface,
            ),
            decoration: InputDecoration(
              hintText: locale.influencer_enter_account,
              hintStyle: getRegularStyle(
                fontFamily: FontConstant.alexandria,
                fontSize: FontSize.size12,
                color: color.onSurfaceVariant,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: Spacing.md,
                vertical: Spacing.sm,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Spacing.radiusSm),
                borderSide: BorderSide(color: color.outlineVariant),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Spacing.radiusSm),
                borderSide: BorderSide(color: color.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Spacing.radiusSm),
                borderSide: BorderSide(color: color.primary),
              ),
            ),
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: Spacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: color.onSurfaceVariant,
                    side: BorderSide(color: color.outlineVariant),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Spacing.influencerSocialAddButtonRadius,
                      ),
                    ),
                  ),
                  child: Text(
                    locale.influencer_cancel,
                    style: getMediumStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color.primary,
                    foregroundColor: color.onPrimary,
                    elevation: Spacing.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Spacing.influencerSocialAddButtonRadius,
                      ),
                    ),
                  ),
                  child: Text(
                    locale.influencer_confirm,
                    style: getBoldStyle(
                      fontFamily: FontConstant.alexandria,
                      fontSize: FontSize.size12,
                      color: color.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
