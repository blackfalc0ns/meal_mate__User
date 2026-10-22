import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/inline_api_error_widget.dart';
import 'package:meal_meat_user/core/errors/error_widgets/empty_state_widget.dart';
import '../manager/compensations_view_model.dart';
import '../manager/compensations_state.dart';
import '../manager/compensations_event.dart';
import 'compensation_card.dart';

class CompensationsContent extends StatelessWidget {
  const CompensationsContent({super.key});
  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    return BlocBuilder<CompensationsViewModel, CompensationsState>(
      buildWhen: (a, b) =>
          a.items != b.items ||
          a.isLoading != b.isLoading ||
          a.failure != b.failure ||
          a.hasLoaded != b.hasLoaded,
      builder: (context, state) {
        final vm = context.read<CompensationsViewModel>();
        if ((!state.hasLoaded || state.isLoading) && state.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.failure case final failure? when state.items.isEmpty) {
          return ApiErrorWidget(
            exception: failure.exception,
            onRetry: () => vm.doIntent(const LoadCompensationsEvent()),
          );
        }
        if (state.items.isEmpty) {
          return EmptyStateWidget(
            title: locale.compensations_empty_title,
            description: locale.compensations_empty_description,
            icon: Icons.redeem_rounded,
          );
        }
        return ListView(
          padding: const EdgeInsets.all(Spacing.screenH),
          children: [
            if (state.isLoading) const LinearProgressIndicator(),
            if (state.failure case final failure?)
              InlineApiErrorWidget(
                failure: failure,
                onRetry: () => vm.doIntent(const LoadCompensationsEvent()),
              ),
            for (final item in state.items)
              Padding(
                padding: const EdgeInsets.only(bottom: Spacing.base),
                child: CompensationCard(
                  key: item.id.isEmpty ? null : ValueKey(item.id),
                  item: item,
                ),
              ),
          ],
        );
      },
    );
  }
}
