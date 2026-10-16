import 'dart:async';

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
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_state.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_view_model.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/widgets/family_addresses_body.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/widgets/family_addresses_loading_skeleton.dart';
import 'package:meal_meat_user/features/family_shared/presentation/widgets/family_flow_scope.dart';

class FamilyAddressesScreen extends StatelessWidget {
  const FamilyAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final isInFamilyFlow = FamilyFlowScope.isActive(context);

    return BlocProvider(
      create: (_) {
        final vm = getIt<FamilyAddressesViewModel>();
        unawaited(vm.load(memberId: FamilyFlowScope.targetMemberIdOf(context)));
        return vm;
      },
      child: BlocConsumer<FamilyAddressesViewModel, FamilyAddressesState>(
        listenWhen: (previous, current) =>
            (previous.familyName != current.familyName &&
                current.familyName != null) ||
            (current.completed &&
                previous.addressSaveRevision != current.addressSaveRevision),
        listener: (context, state) {
          if (isInFamilyFlow && state.familyName != null) {
            FamilyFlowScope.updateFamilyName(context, state.familyName);
          }
          if (state.completed) {
            unawaited(context.pushNamed(AppRoutes.familyAllergies));
          }
        },
        buildWhen: (previous, current) {
          final prevFailedEmpty =
              previous.failure != null && previous.members.isEmpty;
          final currFailedEmpty =
              current.failure != null && current.members.isEmpty;
          if (prevFailedEmpty != currFailedEmpty) return true;

          final prevLoading =
              previous.isLoading || previous.currentMember == null;
          final currLoading =
              current.isLoading || current.currentMember == null;
          return prevLoading != currLoading;
        },
        builder: (context, state) {
          if (state.failure != null && state.members.isEmpty) {
            final errorWidget = ApiErrorWidget(
              exception: state.failure!.exception,
              onRetry: () => context.read<FamilyAddressesViewModel>().load(
                memberId: FamilyFlowScope.targetMemberIdOf(context),
              ),
            );
            if (isInFamilyFlow) return errorWidget;

            return Scaffold(
              backgroundColor: color.surfaceContainerHighest,
              appBar: _buildAppBar(context),
              body: errorWidget,
            );
          }

          if (state.isLoading || state.currentMember == null) {
            const loading = FamilyAddressesLoadingSkeleton();
            if (isInFamilyFlow) return loading;

            return Scaffold(
              backgroundColor: color.surfaceContainerHighest,
              appBar: _buildAppBar(context),
              body: loading,
            );
          }

          const content = FamilyAddressesBody();
          if (isInFamilyFlow) {
            return ColoredBox(
              color: color.surfaceContainerHighest,
              child: content,
            );
          }

          return Scaffold(
            backgroundColor: color.surfaceContainerHighest,
            appBar: _buildAppBar(context),
            body: content,
          );
        },
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return CustomAppBar(
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
    );
  }
}
