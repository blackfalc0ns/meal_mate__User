import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/profile/data/fake/profile_information_fake_data.dart';
import 'package:meal_meat_user/features/profile/presentation/information/widgets/profile_information_document.dart';

class ProfileTermsScreen extends StatelessWidget {
  const ProfileTermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return Scaffold(
      appBar: CustomAppBar(
        title: locale.profile_settings_terms,
        titleFontSize: FontSize.size15,
        backgroundColor: color.surface,
        showShadow: false,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.profilePrivacyScreenHorizontalPadding,
          ).copyWith(top: Spacing.profilePrivacyContentTopPadding),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileInformationDocument(
                document: ProfileInformationFakeData.termsDocument,
              ),
              SizedBox(height: Spacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }
}
