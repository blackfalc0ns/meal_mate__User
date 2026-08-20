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
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_event.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_state.dart';
import 'package:meal_meat_user/features/family_plans/presentation/manager/family_plan_view_model.dart';
import 'package:meal_meat_user/features/family_plans/presentation/models/family_ui_models.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_actions.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_confirmation_summary_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_methods_section.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_overview_section.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_price_details_card.dart';
import 'package:meal_meat_user/features/family_plans/presentation/widgets/family_payment_setup_loading_skeleton.dart';
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
                return const FamilyPaymentSetupLoadingSkeleton();
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
    final languageCode = Localizations.localeOf(context).languageCode;

    final summary = state.summary;
    final currency = summary?.currencyCode.isNotEmpty == true
        ? summary!.currencyCode
        : locale.currency;

    final activeMemberId = state.selectedSummaryMemberId ??
        summary?.selectedMember?.memberId;

    final summaryMembers = summary?.members ?? const [];
    final fallbackMembers = state.members;

    final displayedMembers = summaryMembers.isNotEmpty
        ? summaryMembers.map((m) {
            final isSelected = activeMemberId != null
                ? m.memberId == activeMemberId
                : m.isManager;
            final isReady = m.isReady || m.setupStatus == 3;
            return FamilyProgramMemberUiModel(
              name: m.displayName,
              imageAsset: '',
              status: isReady
                  ? locale.family_member_completed
                  : locale.family_member_in_progress,
              isSelected: isSelected,
              isInProgress: !isReady,
            );
          }).toList()
        : fallbackMembers.asMap().entries.map((entry) {
            final index = entry.key;
            final m = entry.value;
            final isSelected = index == state.selectedMemberIndex;
            final isReady = m.setupStatus == 3;
            return FamilyProgramMemberUiModel(
              name: m.displayName,
              imageAsset: '',
              status: isReady
                  ? locale.family_member_completed
                  : locale.family_member_in_progress,
              isSelected: isSelected,
              isInProgress: !isReady,
            );
          }).toList();

    final selectedMemberSummary = summary?.selectedMember;
    final activeMemberDetails = selectedMemberSummary != null
        ? FamilyProgramMemberDetailsUiModel(
            name: selectedMemberSummary.displayName,
            imageAsset: '',
            age: '',
            gender: '',
            roleLabel: selectedMemberSummary.roleAr ??
                (selectedMemberSummary.isManager
                    ? locale.family_primary_member
                    : ''),
          )
        : (fallbackMembers.isNotEmpty
            ? FamilyProgramMemberDetailsUiModel(
                name: fallbackMembers.first.displayName,
                imageAsset: '',
                age: '',
                gender: '',
                roleLabel: fallbackMembers.first.isManager
                    ? locale.family_primary_member
                    : '',
              )
            : null);

    final List<FamilySelectionSummaryRowData> memberSummaryRows = [];
    if (selectedMemberSummary != null) {
      final progName = selectedMemberSummary.programName(languageCode);
      if (progName.isNotEmpty) {
        memberSummaryRows.add(
          FamilySelectionSummaryRowData(
            icon: FamilySelectionSummaryIcon.check,
            label: locale.family_subscription_program_label,
            value: progName,
          ),
        );
      }

      final bName = selectedMemberSummary.bundleName(languageCode);
      if (bName.isNotEmpty) {
        memberSummaryRows.add(
          FamilySelectionSummaryRowData(
            icon: FamilySelectionSummaryIcon.cutlery,
            label: locale.family_subscription_package_label,
            value: bName,
          ),
        );
      }

      final dText = selectedMemberSummary.durationText(languageCode);
      if (dText.isNotEmpty) {
        memberSummaryRows.add(
          FamilySelectionSummaryRowData(
            icon: FamilySelectionSummaryIcon.calendar,
            label: locale.family_subscription_days_label,
            value: dText,
          ),
        );
      }

      final tText = selectedMemberSummary.tierText(languageCode);
      if (tText.isNotEmpty) {
        memberSummaryRows.add(
          FamilySelectionSummaryRowData(
            icon: FamilySelectionSummaryIcon.balance,
            label: locale.subscription_summary_restaurant_tier_label,
            value: tText,
          ),
        );
      }

      if (selectedMemberSummary.memberPrice > 0) {
        memberSummaryRows.add(
          FamilySelectionSummaryRowData(
            icon: FamilySelectionSummaryIcon.receipt,
            label: locale.family_weekly_price,
            value:
                '${selectedMemberSummary.memberPrice.toStringAsFixed(3)} $currency',
            isPrice: true,
          ),
        );
      }
    }

    final selectionSummary = memberSummaryRows.isNotEmpty
        ? FamilySelectionSummaryData(
            title: locale.family_subscription_summary,
            rows: memberSummaryRows,
          )
        : null;

    final discountPercentInt = summary != null
        ? (summary.familyDiscountPercent * 100).round()
        : 0;
    final discountLabel = discountPercentInt > 0
        ? locale.family_package_discount_badge('$discountPercentInt%')
        : '';

    final priceDetails = summary != null
        ? FamilyPaymentPriceDetailsUiModel(
            badge: discountLabel,
            note: locale.family_payment_note,
            totalLabel: locale.family_total,
            totalValue: '${summary.finalPrice.toStringAsFixed(3)} $currency',
            rows: [
              FamilyPaymentPriceRowUiModel(
                label: locale.family_price_duration_total,
                value: '${summary.subtotal.toStringAsFixed(3)} $currency',
              ),
              if (summary.familyDiscountAmount > 0)
                FamilyPaymentPriceRowUiModel(
                  label: discountPercentInt > 0
                      ? locale.family_package_discount_badge('$discountPercentInt%')
                      : locale.family_price_discount,
                  value:
                      '-${summary.familyDiscountAmount.toStringAsFixed(3)} $currency',
                  isDiscount: true,
                ),
              FamilyPaymentPriceRowUiModel(
                label: locale.family_total,
                value: '${summary.finalPrice.toStringAsFixed(3)} $currency',
                isStrong: true,
              ),
            ],
          )
        : null;

    final mealOverviewMembers = summary != null && summary.mealOverview.isNotEmpty
        ? summary.mealOverview.map((item) {
            final mealsCount = item.mealsPerDay > 0
                ? '+${item.mealsPerDay} ${locale.family_manage_meals}'
                : '';
            return FamilyPlanMemberUiModel(
              name: item.displayName,
              imageAsset: '',
              isOwner: item.isManager,
              mealChecks: item.mealChecks,
              mealsCount: mealsCount,
            );
          }).toList()
        : <FamilyPlanMemberUiModel>[];

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
                FamilyProgramMemberStrip(
                  members: displayedMembers,
                  onSelectMember: (index) {
                    if (summaryMembers.isNotEmpty &&
                        index >= 0 &&
                        index < summaryMembers.length) {
                      final memberId = summaryMembers[index].memberId;
                      context.read<FamilyPlanViewModel>().doIntent(
                        GetFamilySummaryEvent(memberId: memberId),
                      );
                    } else if (fallbackMembers.isNotEmpty &&
                        index >= 0 &&
                        index < fallbackMembers.length) {
                      final memberId = fallbackMembers[index].memberId;
                      context.read<FamilyPlanViewModel>().doIntent(
                        GetFamilySummaryEvent(memberId: memberId),
                      );
                    }
                  },
                ),
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
              if (mealOverviewMembers.isNotEmpty) ...[
                const SizedBox(height: Spacing.lg),
                FamilyPaymentOverviewSection(members: mealOverviewMembers),
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
                checkoutBlockReason: summary?.checkoutBlockReason,
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
