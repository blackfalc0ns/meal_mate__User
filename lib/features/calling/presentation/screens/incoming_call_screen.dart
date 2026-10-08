import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/colors.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/features/calling/data/fake/calling_fake_data.dart';
import 'package:meal_meat_user/features/calling/domain/entities/call_driver_entity.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_background_decoration.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_driver_avatar_rings.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_driver_role_badge.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_header_brand.dart';
import 'package:meal_meat_user/features/calling/presentation/widgets/calling_incoming_actions.dart';

class IncomingCallScreen extends StatelessWidget {
  const IncomingCallScreen({
    super.key,
    this.driver = CallingFakeData.defaultDriver,
  });

  final CallDriverEntity driver;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Scaffold(
      backgroundColor: color.surface,
      body: Stack(
        children: [
          const CallingBackgroundDecoration(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.md,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: Spacing.lg),
                            CallingHeaderBrand(
                              title: locale.calling_incoming_title,
                            ),
                            const Spacer(),
                            CallingDriverAvatarRings(
                              avatarAsset: driver.avatarAsset,
                            ),
                            const SizedBox(height: Spacing.md),
                            Text(
                              driver.name,
                              style: getBoldStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size28,
                                color: color.callDriverNameGreen,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: Spacing.xs),
                            CallingDriverRoleBadge(
                              role: driver.role,
                            ),
                            const SizedBox(height: Spacing.sm),
                            Text(
                              locale.calling_calling_now,
                              style: getRegularStyle(
                                fontFamily: FontConstant.alexandria,
                                fontSize: FontSize.size14,
                                color: color.callSubtitleGrey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            CallingIncomingActions(
                              onAccept: () {
                                unawaited(
                                  context.pushReplacementNamed(
                                    AppRoutes.activeCall,
                                    arguments: driver,
                                  ),
                                );
                              },
                              onDecline: () {
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                            const SizedBox(height: Spacing.xxl),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
