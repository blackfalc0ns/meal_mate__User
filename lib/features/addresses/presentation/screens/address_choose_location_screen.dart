import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_back_button.dart';
import 'package:meal_meat_user/core/widget/custom_snak_bar.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_event.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_state.dart';
import 'package:meal_meat_user/features/addresses/presentation/manager/addresses_view_model.dart';
import 'package:meal_meat_user/features/addresses/presentation/widgets/addresses_figma_frame.dart';

class AddressChooseLocationScreen extends StatelessWidget {
  const AddressChooseLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider<AddressesViewModel>(
      create: (_) =>
          getIt<AddressesViewModel>()
            ..doIntent(const GetLocationsCatalogEvent()),
      child: Scaffold(
        backgroundColor: color.surfaceContainerHighest,
        drawerScrimColor: color.scrim,
        extendBody: true,
        body: Stack(
          children: [
            Column(
              children: [
                const SafeArea(
                  bottom: false,
                  child: SizedBox(
                    height: Spacing.addressesChooseLocationScreenTopGap,
                  ),
                ),
                Expanded(
                  child: Semantics(
                    label: locale.addresses_choose_location_title,
                    child: BlocConsumer<AddressesViewModel, AddressesState>(
                      listenWhen: (previous, current) =>
                          previous.action != current.action,
                      listener: (context, state) {
                        final errorMessage =
                            state.action.errorMessage ??
                            state.action.failure?.errorMessage;
                        if (errorMessage != null && errorMessage.isNotEmpty) {
                          CustomSnackbar.showError(
                            context: context,
                            message: errorMessage,
                          );
                        }

                        if (state.action.isSuccess) {
                          Navigator.of(context).pop(true);
                        }
                      },
                      buildWhen: (previous, current) =>
                          previous.locations != current.locations ||
                          previous.action != current.action,
                      builder: (context, state) {
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final scale =
                                constraints.maxWidth /
                                Spacing.addressesChooseLocationDesignWidth;
                            final contentHeight =
                                AddressesFigmaFrame.frameHeight * scale;

                            return SingleChildScrollView(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.paddingOf(context).bottom,
                              ),
                              child: SizedBox(
                                width: constraints.maxWidth,
                                height: contentHeight,
                                child: FittedBox(
                                  alignment: Alignment.topCenter,
                                  fit: BoxFit.fitWidth,
                                  child: SizedBox(
                                    width: Spacing
                                        .addressesChooseLocationDesignWidth,
                                    height: AddressesFigmaFrame.frameHeight,
                                    child: AddressesFigmaFrame(
                                      locations: state.locations,
                                      isSubmitting: state.action.isLoading,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            CustomBackButton(onPressed: () => Navigator.maybePop(context)),
          ],
        ),
      ),
    );
  }
}
