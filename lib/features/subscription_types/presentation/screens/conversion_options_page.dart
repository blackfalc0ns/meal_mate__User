import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/app_button.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/subscription_types/domain/entities/conversion_options_model.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/manager/subscription_types_event.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/manager/subscription_types_state.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/manager/subscription_types_view_model.dart';
import 'package:meal_meat_user/features/subscription_types/presentation/widgets/conversion_option_card.dart';

class ConversionOptionsPage extends StatelessWidget {
  const ConversionOptionsPage({super.key, required this.options});

  final ConversionOptionsModel options;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<SubscriptionTypesViewModel>(
      create: (_) =>
          getIt<SubscriptionTypesViewModel>()
            ..doIntent(InitializeConversionOptionSelectionEvent(options)),
      child: Scaffold(
        appBar: CustomAppBar(
          showBackButton: true,
          title: locale.subscription_conversion_title,
          titleFontSize: FontSize.size16,
        ),
        body: SafeArea(
          child:
              BlocConsumer<SubscriptionTypesViewModel, SubscriptionTypesState>(
                listenWhen: (previous, current) =>
                    previous.isConvertFromIndividualSuccess !=
                        current.isConvertFromIndividualSuccess ||
                    previous.convertFromIndividualFailure !=
                        current.convertFromIndividualFailure,
                listener: (context, state) {
                  if (state.isConvertFromIndividualSuccess) {
                    unawaited(
                      context.pushReplacementNamed(
                        AppRoutes.familySubscriptionSetup,
                      ),
                    );
                    return;
                  }

                  final message =
                      state.convertFromIndividualFailure?.errorMessage;
                  if (message != null && message.isNotEmpty) {
                    CustomSnackbar.showError(
                      context: context,
                      message: message,
                    );
                  }
                },
                builder: (context, state) {
                  final selectedOption = state.selectedConversionOption;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacing.screenH,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: Spacing.md),
                        Text(
                          locale.subscription_conversion_subtitle,
                          style: getRegularStyle(
                            fontFamily: FontConstant.alexandria,
                            fontSize: FontSize.size12,
                            color: color.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: Spacing.lg),
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: options.options.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: Spacing.sm),
                            itemBuilder: (context, index) {
                              final option = options.options[index];
                              return ConversionOptionCard(
                                option: option,
                                title: _titleForOption(context, option),
                                subtitle: _subtitleForOption(context, option),
                                icon: _iconForOption(option),
                                isSelected: selectedOption?.code == option.code,
                                onTap: () => context
                                    .read<SubscriptionTypesViewModel>()
                                    .doIntent(
                                      SelectConversionOptionEvent(option),
                                    ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: Spacing.md),
                        AppButton.filled(
                          text: locale.family_package_continue_button,
                          isLoading: state.isConvertFromIndividualLoading,
                          onPressed:
                              selectedOption == null ||
                                  !selectedOption.isConvertToFamilyManager ||
                                  state.isConvertFromIndividualLoading
                              ? null
                              : () => context
                                    .read<SubscriptionTypesViewModel>()
                                    .doIntent(
                                      const ConvertFromIndividualEvent(),
                                    ),
                          borderRadius: Spacing.radiusPill,
                          textColor: color.onPrimary,
                          fontSize: FontSize.size12,
                          iconWidget: Icon(
                            Directionality.of(context) == TextDirection.rtl
                                ? Icons.chevron_left_rounded
                                : Icons.chevron_right_rounded,
                            color: color.onPrimary,
                            size: Spacing.iconMd,
                          ),
                        ),
                        const SizedBox(height: Spacing.base),
                      ],
                    ),
                  );
                },
              ),
        ),
      ),
    );
  }

  String _titleForOption(BuildContext context, ConversionOptionModel option) {
    final locale = context.localization;
    final title = option.title(locale.localeName);
    if (title.isNotEmpty) return title;

    if (option.isConvertToFamilyManager) {
      return locale.subscription_conversion_create_family_manager;
    }

    return locale.subscription_conversion_change_individual_plan;
  }

  String _subtitleForOption(
    BuildContext context,
    ConversionOptionModel option,
  ) {
    final locale = context.localization;

    if (option.available) {
      return option.isConvertToFamilyManager
          ? locale.subscription_conversion_create_family_manager_subtitle
          : '';
    }

    final disabledReason = option.disabledReason;
    if (disabledReason == 'change_individual_plan.not_available') {
      return locale.subscription_conversion_coming_soon;
    }

    if (disabledReason != null && disabledReason.isNotEmpty) {
      return disabledReason;
    }

    return locale.subscription_conversion_unavailable;
  }

  IconData _iconForOption(ConversionOptionModel option) {
    if (option.isConvertToFamilyManager) return Icons.groups_2_rounded;
    return Icons.person_rounded;
  }
}
