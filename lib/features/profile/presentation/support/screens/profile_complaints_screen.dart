import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/profile/data/repo/profile_support_fake_repository.dart';
import 'package:meal_meat_user/features/profile/domain/entities/profile_support_message_entity.dart';
import 'package:meal_meat_user/features/profile/domain/usecase/submit_profile_support_message_usecase.dart';
import 'package:meal_meat_user/features/profile/presentation/support/manager/profile_support_form_view_model.dart';
import 'package:meal_meat_user/features/profile/presentation/support/widgets/profile_support_intro_card.dart';
import 'package:meal_meat_user/features/profile/presentation/support/widgets/profile_support_message_form.dart';

class ProfileComplaintsScreen extends StatelessWidget {
  const ProfileComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<ProfileSupportFormViewModel>(
      create: (_) => ProfileSupportFormViewModel(
        const SubmitProfileSupportMessageUseCase(
          ProfileSupportFakeRepository(),
        ),
      ),
      child: Scaffold(
        appBar: CustomAppBar(
          title: locale.profile_support_complaints_title,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileSupportIntroCard(
                  icon: Icons.warning_rounded,
                  title: locale.profile_support_complaints_title,
                  description: locale.profile_support_complaints_intro,
                ),
                const SizedBox(height: Spacing.md),
                const ProfileSupportMessageForm(
                  kind: ProfileSupportMessageKind.complaint,
                ),
                const SizedBox(height: Spacing.xxxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
