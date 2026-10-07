import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';

class AuthLoadingOverlay extends StatelessWidget {
  const AuthLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return PopScope(
      canPop: !isLoading,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AbsorbPointer(
            absorbing: isLoading,
            child: child,
          ),
          if (isLoading)
            Positioned.fill(
              child: ModalBarrier(
                color: color.scrim.withValues(alpha: 0.08),
                dismissible: false,
              ),
            ),
          if (isLoading)
            const Positioned.fill(
              child: CustomProgressIndicator(),
            ),
        ],
      ),
    );
  }
}

