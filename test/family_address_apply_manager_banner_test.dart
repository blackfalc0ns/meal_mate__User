import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/config/theme/app_theme.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/constants/assets.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_state.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/manager/family_addresses_view_model.dart';
import 'package:meal_meat_user/features/family_addresses/presentation/widgets/family_address_apply_manager_banner.dart';
import 'package:meal_meat_user/features/family_subscription_setup/domain/entities/family_member_entity.dart';

class _FakeFamilyAddressesViewModel extends Cubit<FamilyAddressesState>
    implements FamilyAddressesViewModel {
  _FakeFamilyAddressesViewModel(super.initialState);

  int toggleCallCount = 0;

  @override
  Future<void> toggleApplyManagerAddress() async {
    toggleCallCount++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  Widget buildTestWidget({
    required Widget child,
    required _FakeFamilyAddressesViewModel viewModel,
    Locale locale = const Locale('ar'),
    TextDirection textDirection = TextDirection.rtl,
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Directionality(
        textDirection: textDirection,
        child: Scaffold(
          body: BlocProvider<FamilyAddressesViewModel>.value(
            value: viewModel,
            child: child,
          ),
        ),
      ),
    );
  }

  const managerAddress = CustomerAddressEntity(
    addressId: 'addr-1',
    label: 'Home',
    addressLine: 'Kuwait City',
    latitude: 29.3759,
    longitude: 47.9774,
    isDefault: true,
    notifyOnDelivery: true,
  );

  const managerMember = FamilyMemberEntity(
    memberId: 'm-1',
    displayName: 'أحمد',
    role: 1, // Manager
    relationshipCode: 'self',
    gender: 1,
    ageYears: 35,
    setupStatus: 2,
    includeFriday: false,
    isCurrentUser: true,
    deliveryAddress: managerAddress,
    deliveryAddressId: 'addr-1',
  );

  const memberWithSameAddress = FamilyMemberEntity(
    memberId: 'm-2',
    displayName: 'سارة',
    role: 2,
    relationshipCode: 'spouse',
    gender: 2,
    ageYears: 30,
    setupStatus: 2,
    includeFriday: false,
    isCurrentUser: false,
    deliveryAddress: managerAddress,
    deliveryAddressId: 'addr-1',
  );

  const memberWithoutAddress = FamilyMemberEntity(
    memberId: 'm-2',
    displayName: 'سارة',
    role: 2,
    relationshipCode: 'spouse',
    gender: 2,
    ageYears: 30,
    setupStatus: 1,
    includeFriday: false,
    isCurrentUser: false,
  );

  group('FamilyAddressApplyManagerBanner Figma 3615-8513 Widget Tests', () {
    testWidgets('renders exactly as Figma design when multiple members exist', (
      tester,
    ) async {
      final viewModel = _FakeFamilyAddressesViewModel(
        const FamilyAddressesState(
          members: [managerMember, memberWithSameAddress],
          isApplyingManagerAddress: false,
        ),
      );

      await tester.pumpWidget(
        buildTestWidget(
          viewModel: viewModel,
          child: const FamilyAddressApplyManagerBanner(),
        ),
      );
      await tester.pumpAndSettle();

      // Verified title & subtitle
      expect(find.text('تطبيق عنوان المدير'), findsOneWidget);
      expect(
        find.text('استخدم عنوان أحمد كعنوان مدير العائلة لجميع الأفراد'),
        findsOneWidget,
      );

      // Verified crown asset image from Figma
      final imageFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName ==
                Assets.familyApplyManagerCrown,
      );
      expect(imageFinder, findsOneWidget);

      // Verified checked icon when address is applied
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });

    testWidgets('hides when only one member exists', (tester) async {
      final viewModel = _FakeFamilyAddressesViewModel(
        const FamilyAddressesState(
          members: [managerMember],
        ),
      );

      await tester.pumpWidget(
        buildTestWidget(
          viewModel: viewModel,
          child: const FamilyAddressApplyManagerBanner(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('تطبيق عنوان المدير'), findsNothing);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('shows loading spinner when isApplyingManagerAddress is true', (
      tester,
    ) async {
      final viewModel = _FakeFamilyAddressesViewModel(
        const FamilyAddressesState(
          members: [managerMember, memberWithSameAddress],
          isApplyingManagerAddress: true,
        ),
      );

      await tester.pumpWidget(
        buildTestWidget(
          viewModel: viewModel,
          child: const FamilyAddressApplyManagerBanner(),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsNothing);
    });

    testWidgets('calls toggleApplyManagerAddress when tapped', (tester) async {
      final viewModel = _FakeFamilyAddressesViewModel(
        const FamilyAddressesState(
          members: [managerMember, memberWithoutAddress],
          isApplyingManagerAddress: false,
        ),
      );

      await tester.pumpWidget(
        buildTestWidget(
          viewModel: viewModel,
          child: const FamilyAddressApplyManagerBanner(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FamilyAddressApplyManagerBanner));
      await tester.pump();

      expect(viewModel.toggleCallCount, 1);
    });
  });
}
