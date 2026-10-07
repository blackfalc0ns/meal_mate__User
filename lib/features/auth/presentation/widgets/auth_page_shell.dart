import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_form_card.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_hero_section.dart';

class AuthPageShell extends StatelessWidget {
  const AuthPageShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.footer,
    this.topOffset = Spacing.zero,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? footer;
  final double topOffset;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return LayoutBuilder(
      builder: (context, constraints) {
        final topSpacer = (constraints.maxHeight * 0.04).clamp(
          Spacing.xl,
          Spacing.xxxl,
        );

        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: EdgeInsets.only(
                left: Spacing.base,
                right: Spacing.base,
                top: Spacing.base,
                bottom: Spacing.base + bottomInset,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: topSpacer + topOffset),
                  AuthHeroSection(title: title, subtitle: subtitle),
                  const SizedBox(height: Spacing.xl + Spacing.xs),
                  AuthFormCard(child: child),
                  if (footer != null) ...[
                    const SizedBox(height: Spacing.lg),
                    footer!,
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
