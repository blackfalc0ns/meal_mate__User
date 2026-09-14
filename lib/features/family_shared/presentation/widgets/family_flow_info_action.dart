import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class FamilyFlowInfoAction extends StatefulWidget {
  const FamilyFlowInfoAction({super.key, required this.familyName});

  final String? familyName;

  @override
  State<FamilyFlowInfoAction> createState() => _FamilyFlowInfoActionState();
}

class _FamilyFlowInfoActionState extends State<FamilyFlowInfoAction> {
  static const _animationDuration = Duration(milliseconds: 200);
  static const _visibleDuration = Duration(milliseconds: 2500);

  Timer? _collapseTimer;
  bool _isExpanded = false;

  @override
  void dispose() {
    _collapseTimer?.cancel();
    super.dispose();
  }

  void _toggle() {
    _collapseTimer?.cancel();
    setState(() => _isExpanded = !_isExpanded);
    if (_isExpanded) {
      _collapseTimer = Timer(_visibleDuration, () {
        if (mounted) setState(() => _isExpanded = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = reduceMotion ? Duration.zero : _animationDuration;
    final familyName = widget.familyName?.trim();
    final displayName = familyName == null || familyName.isEmpty
        ? locale.family_name
        : familyName;

    return Tooltip(
      message: locale.family_name,
      excludeFromSemantics: true,
      child: Semantics(
        button: true,
        label: locale.family_name,
        child: Material(
          color: _isExpanded
              ? color.primaryContainer
              : color.surface.withValues(alpha: 0),
          borderRadius: BorderRadius.circular(Spacing.xxl),
          child: InkWell(
            key: const ValueKey('family-flow-info-button'),
            onTap: _toggle,
            borderRadius: BorderRadius.circular(Spacing.xxl),
            child: AnimatedSize(
              duration: duration,
              curve: Curves.easeOutCubic,
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.sm),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline_rounded, color: color.primary),
                    AnimatedSwitcher(
                      duration: duration,
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeOutCubic,
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: _isExpanded
                          ? Padding(
                              key: const ValueKey('family-flow-info-label'),
                              padding: const EdgeInsetsDirectional.only(
                                start: Spacing.xs,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.group_rounded,
                                    size: Spacing.md,
                                    color: color.primary,
                                  ),
                                  const SizedBox(width: Spacing.xs),
                                  Text(
                                    displayName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: getBoldStyle(
                                      fontFamily: FontConstant.alexandria,
                                      fontSize: FontSize.size8,
                                      color: color.onPrimaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(
                              key: ValueKey('family-flow-info-collapsed'),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
