import 'package:flutter/material.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';

class LoadingPreviewScreen extends StatelessWidget {
  const LoadingPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: const SafeArea(child: CustomProgressIndicator()),
    );
  }
}
