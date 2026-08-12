import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_back_button.dart';
import 'package:meal_meat_user/features/subscription_programs/presentation/widgets/subscription_program_selection_view.dart';

class SubscriptionProgramSelectionScreen extends StatefulWidget {
  const SubscriptionProgramSelectionScreen({super.key});

  @override
  State<SubscriptionProgramSelectionScreen> createState() =>
      _SubscriptionProgramSelectionScreenState();
}

class _SubscriptionProgramSelectionScreenState
    extends State<SubscriptionProgramSelectionScreen> {
  int? _selectedProgramIndex;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Semantics(
      label: locale.nav_subscription,
      child: Scaffold(
        backgroundColor: color.surface,
        body: Stack(
          children: [
            SubscriptionProgramSelectionView(
              showBottomSpace: true,
              onProgramSelected: _selectProgram,
            ),
            CustomBackButton(
              top: MediaQuery.paddingOf(context).top + Spacing.base,
              onPressed: () => Navigator.maybePop(context),
            ),
            PositionedDirectional(
              start: Spacing.subscriptionProgramsHorizontalPadding,
              end: Spacing.subscriptionProgramsHorizontalPadding,
              bottom: Spacing.lg,
              child: SafeArea(
                top: false,
                child: AppButton.filled(
                  text: locale.family_next_package_days,
                  onPressed: _selectedProgramIndex == null
                      ? null
                      : _openPackageSelection,
                  borderRadius: Spacing.radiusPill,
                  textColor: color.onPrimary,
                  fontSize: FontSize.size12,
                  iconWidget: Icon(
                    Icons.chevron_right_rounded,
                    color: color.onPrimary,
                    size: Spacing.iconMd,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectProgram(int index) {
    setState(() => _selectedProgramIndex = index);
  }

  void _openPackageSelection() {
    final selectedProgramIndex = _selectedProgramIndex;
    if (selectedProgramIndex == null) return;

    context.pushNamed(
      AppRoutes.subscriptionPackageSelection,
      arguments: selectedProgramIndex.clamp(0, 2),
    );
  }
}
