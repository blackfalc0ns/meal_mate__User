import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/routing/app_routes.dart';
import 'package:meal_meat_user/config/routing/routing_extensions.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_event.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_state.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/manager/family_checkout_view_model.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_payment_content.dart';
import 'package:meal_meat_user/features/family_checkout/presentation/widgets/family_payment_setup_loading_skeleton.dart';
import 'package:meal_meat_user/features/payment/domain/entities/payment_args.dart';

class FamilyPaymentSetupScreen extends StatelessWidget {
  const FamilyPaymentSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<FamilyCheckoutViewModel>(
      create: (_) => getIt<FamilyCheckoutViewModel>()
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
          child: BlocConsumer<FamilyCheckoutViewModel, FamilyPlanState>(
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
                  onRetry: () => context
                      .read<FamilyCheckoutViewModel>()
                      .doIntent(const GetFamilySummaryEvent()),
                );
              }

              return FamilyPaymentContent(state: state);
            },
          ),
        ),
      ),
    );
  }
}
