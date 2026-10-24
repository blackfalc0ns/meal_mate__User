import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/customer_orders/domain/entities/delivered_box_entity.dart';
import 'package:meal_meat_user/features/customer_support/presentation/manager/customer_support_view_model.dart';
import 'package:meal_meat_user/features/customer_support/presentation/widgets/customer_issue_form.dart';
import 'package:meal_meat_user/features/profile/presentation/support/widgets/profile_support_intro_card.dart';

class ProfileComplaintsScreen extends StatelessWidget {
  const ProfileComplaintsScreen({super.key, this.initialBox});

  final DeliveredBoxEntity? initialBox;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    final isGeneralComplaint = initialBox == null;
    final screenTitle = isGeneralComplaint
        ? locale.customer_support_general_complaint_title
        : locale.customer_support_order_complaint_title;
    final introDesc = isGeneralComplaint
        ? locale.customer_support_general_complaint_desc
        : locale.customer_support_order_complaint_desc;

    return BlocProvider<CustomerSupportViewModel>(
      create: (_) {
        final viewModel = getIt<CustomerSupportViewModel>();
        unawaited(viewModel.loadOptions());
        return viewModel;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: screenTitle,
          titleFontSize: FontSize.size15,
          backgroundColor: color.surface,
          showShadow: false,
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.screenH,
            ).copyWith(top: Spacing.profilePrivacyContentTopPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileSupportIntroCard(
                  icon: isGeneralComplaint
                      ? Icons.chat_bubble_outline_rounded
                      : Icons.report_problem_outlined,
                  title: screenTitle,
                  description: introDesc,
                ),
                const SizedBox(height: Spacing.md),
                CustomerIssueForm(initialBox: initialBox),
                const SizedBox(height: Spacing.xxxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
