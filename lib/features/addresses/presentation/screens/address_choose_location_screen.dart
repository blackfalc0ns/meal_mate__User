import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
import 'package:meal_meat_user/core/widget/custom_back_button.dart';
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
            Positioned.fill(
              child: Semantics(
                label: locale.addresses_choose_location_title,
                child: BlocBuilder<AddressesViewModel, AddressesState>(
                  buildWhen: (previous, current) =>
                      previous.locations != current.locations,
                  builder: (context, state) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final scale =
                            constraints.maxWidth /
                            Spacing.addressesChooseLocationDesignWidth;
                        final contentHeight =
                            Spacing.addressesChooseLocationDesignHeight * scale;

                        return SingleChildScrollView(
                          child: SizedBox(
                            width: constraints.maxWidth,
                            height: contentHeight,
                            child: FittedBox(
                              alignment: Alignment.topCenter,
                              fit: BoxFit.fitWidth,
                              child: SizedBox(
                                width:
                                    Spacing.addressesChooseLocationDesignWidth,
                                height:
                                    Spacing.addressesChooseLocationDesignHeight,
                                child: AddressesFigmaFrame(
                                  locations: state.locations,
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
            CustomBackButton(onPressed: () => Navigator.maybePop(context)),
          ],
        ),
      ),
    );
  }
}
