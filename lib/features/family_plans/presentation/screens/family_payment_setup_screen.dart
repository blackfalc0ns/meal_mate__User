import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/loading_widget.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_event.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_state.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_view_model.dart';
import 'package:meal_meat_user/features/family_plans/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_actions.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_confirmation_summary_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_methods_section.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_price_details_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_member_strip.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_program_stepper.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_setup_header_badge.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';

class FamilyPaymentSetupScreen extends StatelessWidget {
  const FamilyPaymentSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<FamilyPlanViewModel>(
      create: (_) => getIt<FamilyPlanViewModel>()
        ..doIntent(const GetFamilySubscriptionCurrentEvent())
        ..doIntent(const GetFamilySummaryEvent()),
      child: Scaffold(
        appBar: CustomAppBar(
          showBackButton: true,
          titleWidget: Column(
            children: [
              Text(
                locale.family_setup_title,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size13,
                  color: color.onSurface,
                ),
              ),
              Text(
                locale.family_setup_subtitle,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size9,
                  color: color.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: BlocConsumer<FamilyPlanViewModel, FamilyPlanState>(
            listener: (context, state) {
              if (state.checkoutResult != null) {
                context.pushNamed(
                  AppRoutes.paymentWebView,
                  arguments: PaymentWebViewArgs(
                    checkout: state.checkoutResult!,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state.isSummaryLoading && state.summary == null) {
                return const Center(child: LoadingWidget());
              }

              if (state.failure != null && state.summary == null) {
                return ApiErrorWidget(
                  exception: state.failure!.exception,
                  onRetry: () => context.read<FamilyPlanViewModel>().doIntent(
                    const GetFamilySummaryEvent(),
                  ),
                );
              }

              return _buildPaymentContent(context, state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentContent(BuildContext context, FamilyPlanState state) {
    final color = context.colorScheme;
    final locale = context.localization;

    final summary = state.summary;
    final members = state.members;

    final displayedMembers = members
        .map(
          (m) => FamilyProgramMemberUiModel(
            name: m.displayName,
            imageAsset: '',
            status: m.isReady
                ? locale.family_member_completed
                : locale.family_member_in_progress,
            isSelected: false,
            isInProgress: !m.isReady,
          ),
        )
        .toList();

    final selectedMember = state.selectedMember;
    final activeMemberDetails = selectedMember != null
        ? FamilyProgramMemberDetailsUiModel(
            name: selectedMember.displayName,
            imageAsset: '',
            age: '${selectedMember.ageYears}',
            gender: selectedMember.gender == 2
                ? locale.family_gender_female
                : locale.family_gender_male,
            goal: '',
            activityLevel: '',
          )
        : (members.isNotEmpty
              ? FamilyProgramMemberDetailsUiModel(
                  name: members.first.displayName,
                  imageAsset: '',
                  age: '${members.first.ageYears}',
                  gender: members.first.gender == 2
                      ? locale.family_gender_female
                      : locale.family_gender_male,
                  goal: '',
                  activityLevel: '',
                )
              : null);

    final selectionSummary = summary != null
        ? FamilySelectionSummaryData(
            title: locale.family_subscription_summary,
            rows: [
              FamilySelectionSummaryRowData(
                icon: FamilySelectionSummaryIcon.balance,
                label: locale.family_base_price_two_members,
                value: '${summary.subtotal.toStringAsFixed(3)} KWD',
              ),
              if (summary.familyDiscountAmount > 0)
                FamilySelectionSummaryRowData(
                  icon: FamilySelectionSummaryIcon.check,
                  label: locale.family_price_discount,
                  value:
                      '-${summary.familyDiscountAmount.toStringAsFixed(3)} KWD',
                ),
              FamilySelectionSummaryRowData(
                icon: FamilySelectionSummaryIcon.receipt,
                label: locale.family_total,
                value: '${summary.finalPrice.toStringAsFixed(3)} KWD',
                isPrice: true,
              ),
            ],
          )
        : null;

    final priceDetails = summary != null
        ? FamilyPaymentPriceDetailsUiModel(
            badge: locale.family_package_discount_badge(summary.discountLabel),
            note: locale.family_payment_note,
            totalLabel: locale.family_total,
            totalValue: '${summary.finalPrice.toStringAsFixed(3)} KWD',
            rows: [
              FamilyPaymentPriceRowUiModel(
                label: locale.family_price_duration_total,
                value: '${summary.subtotal.toStringAsFixed(3)} KWD',
              ),
              if (summary.familyDiscountAmount > 0)
                FamilyPaymentPriceRowUiModel(
                  label: locale.family_price_discount,
                  value:
                      '-${summary.familyDiscountAmount.toStringAsFixed(3)} KWD',
                  isDiscount: true,
                ),
              FamilyPaymentPriceRowUiModel(
                label: locale.family_total,
                value: '${summary.finalPrice.toStringAsFixed(3)} KWD',
                isStrong: true,
              ),
            ],
          )
        : null;

    final paymentMethods = state.paymentMethods
        .map(
          (m) => FamilyPaymentMethodUiModel(
            label: m.title,
            imageAsset: '',
            selected: state.selectedPaymentMethod?.id == m.id,
          ),
        )
        .toList();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.familySetupHorizontalPadding,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate.fixed([
              const FamilySetupHeaderBadge(),
              const SizedBox(height: Spacing.familyProgramProgressTopGap),
              const FamilyProgramStepper(
                currentStep: 3,
                includeFamilyCreationStep: true,
              ),
              const SizedBox(height: Spacing.familyProgramMemberTopGap),
              if (displayedMembers.isNotEmpty)
                FamilyProgramMemberStrip(members: displayedMembers),
              const SizedBox(height: Spacing.md),
              Text(
                locale.family_payment_confirm_title,
                style: getBoldStyle(
                  fontFamily: FontConstant.alexandria,
                  fontSize: FontSize.size12,
                  color: color.onSurface,
                ),
              ),
              if (activeMemberDetails != null && selectionSummary != null) ...[
                const SizedBox(height: Spacing.md),
                FamilyPaymentConfirmationSummaryCard(
                  member: activeMemberDetails,
                  summary: selectionSummary,
                ),
              ],
              if (priceDetails != null) ...[
                const SizedBox(height: Spacing.lg),
                FamilyPaymentPriceDetailsCard(details: priceDetails),
              ],
              if (paymentMethods.isNotEmpty) ...[
                const SizedBox(height: Spacing.md),
                FamilyPaymentMethodsSection(
                  methods: paymentMethods,
                  onSelectMethod: (index) {
                    if (index >= 0 && index < state.paymentMethods.length) {
                      context.read<FamilyPlanViewModel>().doIntent(
                        SelectFamilyPaymentMethodEvent(
                          state.paymentMethods[index],
                        ),
                      );
                    }
                  },
                ),
              ],
              const SizedBox(height: Spacing.lg),
              FamilyPaymentActions(
                canCheckout: summary?.canCheckout ?? false,
                isLoading: state.isCheckoutLoading,
                onConfirmPayment: () {
                  final methodId = state.selectedPaymentMethod?.id ?? 1;
                  context.read<FamilyPlanViewModel>().doIntent(
                    CheckoutFamilySubscriptionEvent(
                      callbackUrl: 'mealmate://checkout/success',
                      errorUrl: 'mealmate://checkout/error',
                      paymentMethodId: methodId,
                    ),
                  );
                },
              ),
              const SizedBox(height: Spacing.xxxl),
            ]),
          ),
        ),
      ],
    );
  }
}
