import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/core/di/di.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';
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
        body: Column(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(
                top: MediaQuery.paddingOf(context).top + Spacing.lg,
                end: Spacing.xl,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Material(
                    color: color.surface,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: () => Navigator.maybePop(context),
                      customBorder: const CircleBorder(),
                      child: SizedBox(
                        width: Spacing.xxl,
                        height: Spacing.xxl,
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          size: Spacing.iconMd,
                          color: color.onSurface,
                          semanticLabel: locale.go_back,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
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
                                width:
                                    Spacing.addressesChooseLocationDesignWidth,
                                height: AddressesFigmaFrame.frameHeight,
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
          ],
        ),
      ),
    );
  }
}
