import 'package:flutter/material.dart';
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
    return Stack(
      fit: StackFit.expand,
      children: [
        AbsorbPointer(absorbing: isLoading, child: child),
        if (isLoading) const Positioned.fill(child: CustomProgressIndicator()),
      ],
    );
  }
}
