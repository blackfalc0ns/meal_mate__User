import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_app_bar.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/customer_orders/presentation/manager/customer_orders_state.dart';
import 'package:meal_meat_user/features/customer_orders/presentation/manager/customer_orders_view_model.dart';
import 'package:meal_meat_user/features/customer_orders/presentation/widgets/delivered_order_card.dart';
import 'package:meal_meat_user/features/profile/presentation/support/screens/profile_complaints_screen.dart';

class DeliveredOrdersScreen extends StatelessWidget {
  const DeliveredOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;
    return BlocProvider<CustomerOrdersViewModel>(
      create: (_) {
        final viewModel = getIt<CustomerOrdersViewModel>();
        unawaited(viewModel.loadBoxes());
        return viewModel;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: locale.customer_orders_title,
          titleFontSize: FontSize.size15,
          backgroundColor: color.surface,
          showShadow: false,
        ),
        body: BlocBuilder<CustomerOrdersViewModel, CustomerOrdersState>(
          buildWhen: (previous, current) =>
              previous.boxes != current.boxes ||
              previous.loading != current.loading ||
              previous.errorMessage != current.errorMessage,
          builder: (context, state) {
            if (state.loading && state.boxes.isEmpty) {
              return ListView.separated(
                padding: const EdgeInsets.all(Spacing.screenH),
                itemCount: 4,
                separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
                itemBuilder: (_, _) => ShimmerWidget(
                  child: Container(
                    height: 125,
                    decoration: BoxDecoration(
                      color: color.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(Spacing.cardRadius),
                    ),
                  ),
                ),
              );
            }
            if (state.errorMessage != null && state.boxes.isEmpty) {
              return Center(
                child: TextButton(
                  onPressed: () =>
                      context.read<CustomerOrdersViewModel>().loadBoxes(),
                  child: Text(locale.customer_support_retry),
                ),
              );
            }
            if (state.boxes.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.xl),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: Spacing.avatarLg,
                        height: Spacing.avatarLg,
                        decoration: BoxDecoration(
                          color: color.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.inventory_2_outlined,
                          size: Spacing.iconLg,
                          color: color.primary,
                        ),
                      ),
                      const SizedBox(height: Spacing.base),
                      Text(
                        locale.customer_orders_empty_title,
                        style: getBoldStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size15,
                          color: color.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        locale.customer_orders_empty_subtitle,
                        style: getRegularStyle(
                          fontFamily: FontConstant.alexandria,
                          fontSize: FontSize.size12,
                          color: color.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<CustomerOrdersViewModel>().loadBoxes(),
              child: ListView.separated(
                padding: const EdgeInsets.all(Spacing.screenH),
                itemCount:
                    state.boxes.length +
                    (state.boxes.length < state.total ? 1 : 0),
                separatorBuilder: (_, _) => const SizedBox(height: Spacing.md),
                itemBuilder: (context, index) {
                  if (index == state.boxes.length) {
                    return TextButton(
                      onPressed: state.loading
                          ? null
                          : () => context
                                .read<CustomerOrdersViewModel>()
                                .loadBoxes(next: true),
                      child: Text(locale.customer_support_load_more),
                    );
                  }
                  final box = state.boxes[index];
                  return DeliveredOrderCard(
                    box: box,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            ProfileComplaintsScreen(initialBox: box),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
