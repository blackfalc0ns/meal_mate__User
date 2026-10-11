import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/network/failures.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/features/calendar/domain/entities/calendar_restaurant_option_entity.dart';
import 'package:meal_meat_user/features/calendar/presentation/widgets/calendar_restaurant_picker_sheet.dart';

CalendarRestaurantOptionEntity _makeOption(String id, String name) {
  return CalendarRestaurantOptionEntity(
    id: id,
    name: name,
    description: 'Desc',
    mealCount: 3,
    rating: '4.5',
    logoType: CalendarRestaurantLogoType.healthyBowl,
  );
}

Widget _wrapWidget({required Widget child}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('en'),
    home: Scaffold(body: child),
  );
}

void main() {
  group('CalendarRestaurantPickerSheet Pagination Widgets', () {
    testWidgets('Displays footer shimmer when isLoadingMore is true', (
      tester,
    ) async {
      final items = [_makeOption('r0', 'Restaurant 0')];

      await tester.pumpWidget(
        _wrapWidget(
          child: CalendarRestaurantPickerSheet(
            restaurants: items,
            isLoadingMore: true,
            onRestaurantSelected: (_) {},
            onSearchChanged: (_) {},
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.byType(ShimmerWidget), findsWidgets);
    });

    testWidgets(
      'Displays retry button when loadMoreFailure is present and calls onRetryLoadMore',
      (tester) async {
        final items = [_makeOption('r0', 'Restaurant 0')];
        var retryCalled = false;

        await tester.pumpWidget(
          _wrapWidget(
            child: CalendarRestaurantPickerSheet(
              restaurants: items,
              loadMoreFailure: Failure(
                errorMessage: 'Network failed',
                code: 'net_err',
              ),
              onRetryLoadMore: () {
                retryCalled = true;
              },
              onRestaurantSelected: (_) {},
              onSearchChanged: (_) {},
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 600));

        final retryFinder = find.byIcon(Icons.refresh_rounded);
        expect(retryFinder, findsOneWidget);

        await tester.tap(retryFinder);
        await tester.pump(const Duration(milliseconds: 600));

        expect(retryCalled, isTrue);
      },
    );

    testWidgets('Calls onLoadMore when scrolled near end', (tester) async {
      final items = List.generate(
        4,
        (i) => _makeOption('r$i', 'Restaurant $i'),
      );
      var loadMoreCalled = false;

      await tester.pumpWidget(
        _wrapWidget(
          child: CalendarRestaurantPickerSheet(
            restaurants: items,
            hasNextPage: true,
            onLoadMore: () {
              loadMoreCalled = true;
            },
            onRestaurantSelected: (_) {},
            onSearchChanged: (_) {},
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));

      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pump(const Duration(milliseconds: 600));

      expect(loadMoreCalled, isTrue);
    });
  });
}
