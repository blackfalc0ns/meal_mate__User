import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/subscription_settings/data/mapper/restaurant_tier_upgrade_mapper.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_args.dart';
import 'package:meal_meat_user/features/subscription_settings/domain/entities/restaurant_tier_upgrade_entity.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/restaurant_tier_upgrade_event.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/restaurant_tier_upgrade_state.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/manager/restaurant_tier_upgrade_view_model.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_details_section.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_payment_section.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_quick_comparison_section.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_upgrade_actions.dart';
import 'package:meal_meat_user/features/subscription_settings/presentation/widgets/restaurant_tier_upgrade_hero_card.dart';

class RestaurantTierUpgradeConfirmationScreen extends StatefulWidget {
  const RestaurantTierUpgradeConfirmationScreen({super.key, this.args});

  final RestaurantTierUpgradeConfirmationArgs? args;

  @override
  State<RestaurantTierUpgradeConfirmationScreen> createState() =>
      _RestaurantTierUpgradeConfirmationScreenState();
}

class _RestaurantTierUpgradeConfirmationScreenState
    extends State<RestaurantTierUpgradeConfirmationScreen> {
  late final RestaurantTierUpgradeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<RestaurantTierUpgradeViewModel>();

    final args = widget.args;
    if (args != null) {
      _viewModel.doIntent(InitUpgradeConfirmationEvent(args));
    }
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final args = widget.args;

    if (args == null) {
      return Scaffold(
        appBar: CustomAppBar(
          elevation: Spacing.zero,
          title: 'تأكيد ترقية التصنيف',
        ),
        body: const EmptyStateWidget(
          title: 'تأكيد ترقية التصنيف',
          description: 'لا توجد بيانات متاحة لطلب الترقية.',
          icon: Icons.error_outline_rounded,
        ),
      );
    }

    return BlocProvider<RestaurantTierUpgradeViewModel>.value(
      value: _viewModel,
      child: BlocConsumer<RestaurantTierUpgradeViewModel,
          RestaurantTierUpgradeState>(
        listenWhen: (previous, current) =>
            previous.isUpgradeSuccess != current.isUpgradeSuccess ||
            previous.upgradeRequestResult != current.upgradeRequestResult ||
            previous.submitFailure != current.submitFailure,
        listener: (context, state) {
          if (state.isUpgradeSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'تمت ترقية التصنيف بنجاح وتفعيل الاشتراك المحدث فوراً',
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).popUntil((route) => route.isFirst);
            return;
          }

          final requestResult = state.upgradeRequestResult;
          if (requestResult != null &&
              requestResult.paymentUrl != null &&
              requestResult.paymentUrl!.isNotEmpty) {
            context.pushNamed(
              AppRoutes.restaurantTierUpgradeWebView,
              arguments: RestaurantTierUpgradeWebViewArgs(
                subscriptionId: state.subscriptionId,
                upgradeId: requestResult.upgradeId,
                paymentUrl: requestResult.paymentUrl!,
              ),
            );
            return;
          }

          if (state.submitFailure != null) {
            final failure = state.submitFailure!;
            final message = _mapErrorCodeToMessage(
              failure.code.isNotEmpty
                  ? failure.code
                  : failure.exception.backendErrorCode,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final data = state.uiData ??
              RestaurantTierUpgradeMapper.toUiEntity(
                optionsEntity: args.optionsEntity,
                selectedOption: args.selectedOption,
                programName: args.programName,
                bundleName: args.bundleName,
              );

          return Semantics(
            label: locale.nav_subscription,
            child: Scaffold(
              appBar: CustomAppBar(elevation: Spacing.zero, title: data.title),
              body: SafeArea(
                top: false,
                child: Stack(
                  children: [
                    CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.screenH,
                          ),
                          sliver: SliverList.list(
                            children: _confirmationChildren(
                              context,
                              data,
                              state,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (state.isSubmitting)
                      ColoredBox(
                        color: Colors.black26,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _confirmationChildren(
    BuildContext context,
    RestaurantTierUpgradeEntity data,
    RestaurantTierUpgradeState state,
  ) {
    return [
      const SizedBox(height: Spacing.lg),
      RestaurantTierUpgradeHeroCard(data: data),
      const SizedBox(height: Spacing.lg),
      RestaurantTierQuickComparisonSection(data: data),
      const SizedBox(height: Spacing.lg),
      RestaurantTierDetailsSection(data: data),
      const SizedBox(height: Spacing.lg),
      RestaurantTierPaymentSection(data: data),
      const SizedBox(height: Spacing.lg),
      RestaurantTierUpgradeActions(
        confirmLabel: state.isSubmitting
            ? 'جاري المعالجة...'
            : data.confirmLabel,
        backLabel: data.backLabel,
        onConfirm: state.isSubmitting
            ? () {}
            : () => _viewModel.doIntent(const SubmitUpgradeRequestEvent()),
        onBack: () => context.pop(),
      ),
      SizedBox(height: MediaQuery.paddingOf(context).bottom + Spacing.xl),
    ];
  }

  String _mapErrorCodeToMessage(String? code) {
    switch (code) {
      case 'subscription.upgrade_target_invalid':
        return 'الطبقة المختارة غير صالحة للترقية.';
      case 'upgrade.redirect_urls_required':
        return 'بيانات إعادة التوجيه للدفع غير مكتملة.';
      case 'upgrade.customer_not_found':
        return 'بيانات العميل غير مكتملة لعملية الدفع.';
      case 'subscription.upgrade_not_available':
        return 'الاشتراك غير متاح للترقية حالياً.';
      case 'subscription.upgrade_request_already_pending':
        return 'يوجد طلب ترقية معلق قيد المتابعة بالفعل.';
      case 'subscription.not_found':
        return 'لم يتم العثور على الاشتراك.';
      default:
        return 'حدث خطأ أثناء بدء عملية الترقية، يرجى المحاولة مرة أخرى.';
    }
  }
}
