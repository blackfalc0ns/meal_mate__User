import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/api_error_type.dart';
import 'package:meal_meat_user/core/errors/api_exception.dart';
import 'package:meal_meat_user/core/errors/error_widgets/api_error_widget.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/errors/failures.dart';
import 'package:meal_meat_user/core/widget/custom_progress_indecator.dart';
import 'package:meal_meat_user/core/widget/shimmer_widget.dart';
import 'package:meal_meat_user/core/address/domain/entities/customer_address_entity.dart';
import 'package:meal_meat_user/core/address/presentation/widgets/address_coverage_restaurants_list.dart';

void main() {
  const sampleRestaurants = [
    ServingRestaurantEntity(
      id: 'rest-1',
      nameAr: 'مطعم أ',
      nameEn: 'Restaurant A',
      logoUrl: 'https://example.com/a.png',
      rating: 4.5,
    ),
    ServingRestaurantEntity(
      id: 'rest-2',
      nameAr: 'مطعم ب',
      nameEn: 'Restaurant B',
      logoUrl: 'https://example.com/b.png',
      rating: 4.8,
    ),
  ];

  Widget buildTestWidget({
    required List<ServingRestaurantEntity> restaurants,
    bool isLoadingMore = false,
    bool hasMoreRestaurants = false,
    Failure? loadMoreFailure,
    VoidCallback? onLoadMoreRestaurants,
    Locale locale = const Locale('en'),
    double width = 300,
  }) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: width,
            height: 500,
            child: SingleChildScrollView(
              child: AddressCoverageRestaurantsList(
                restaurants: restaurants,
                isLoadingMore: isLoadingMore,
                hasMoreRestaurants: hasMoreRestaurants,
                loadMoreFailure: loadMoreFailure,
                onLoadMoreRestaurants: onLoadMoreRestaurants,
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'real restaurant cards remain visible while isLoadingMore is true and shimmer is shown',
    (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          restaurants: sampleRestaurants,
          isLoadingMore: true,
          hasMoreRestaurants: true,
        ),
      );
      // Bounded pump for looping shimmer animation
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Restaurant A'), findsOneWidget);
      expect(find.text('Restaurant B'), findsOneWidget);
      expect(find.byType(ShimmerWidget), findsWidgets);
      expect(find.byType(CustomProgressIndicator), findsNothing);
    },
  );

  testWidgets('scrolling near end calls onLoadMoreRestaurants once in LTR', (
    tester,
  ) async {
    var loadMoreCalls = 0;
    final manyRestaurants = List.generate(
      10,
      (i) => ServingRestaurantEntity(
        id: 'rest-$i',
        nameAr: 'مطعم $i',
        nameEn: 'Restaurant $i',
        logoUrl: 'https://example.com/$i.png',
        rating: 4.0,
      ),
    );

    await tester.pumpWidget(
      buildTestWidget(
        restaurants: manyRestaurants,
        isLoadingMore: false,
        hasMoreRestaurants: true,
        onLoadMoreRestaurants: () => loadMoreCalls++,
        locale: const Locale('en'),
      ),
    );
    await tester.pumpAndSettle();

    expect(loadMoreCalls, 0);

    // Drag horizontally far enough to cross the viewport dimension threshold
    await tester.drag(find.byType(ListView), const Offset(-250, 0));
    await tester.pump();
    await tester.drag(find.byType(ListView), const Offset(-250, 0));
    await tester.pump();
    await tester.drag(find.byType(ListView), const Offset(-250, 0));
    await tester.pump();

    expect(loadMoreCalls, 1);
  });

  testWidgets('scrolling near end calls onLoadMoreRestaurants once in RTL', (
    tester,
  ) async {
    var loadMoreCalls = 0;
    final manyRestaurants = List.generate(
      10,
      (i) => ServingRestaurantEntity(
        id: 'rest-$i',
        nameAr: 'مطعم $i',
        nameEn: 'Restaurant $i',
        logoUrl: 'https://example.com/$i.png',
        rating: 4.0,
      ),
    );

    await tester.pumpWidget(
      buildTestWidget(
        restaurants: manyRestaurants,
        isLoadingMore: false,
        hasMoreRestaurants: true,
        onLoadMoreRestaurants: () => loadMoreCalls++,
        locale: const Locale('ar'),
      ),
    );
    await tester.pumpAndSettle();

    expect(loadMoreCalls, 0);

    // In RTL, dragging in positive direction scrolls toward the end
    await tester.drag(find.byType(ListView), const Offset(250, 0));
    await tester.pump();
    await tester.drag(find.byType(ListView), const Offset(250, 0));
    await tester.pump();
    await tester.drag(find.byType(ListView), const Offset(250, 0));
    await tester.pump();

    expect(loadMoreCalls, 1);
  });

  testWidgets(
    'short list that fits viewport triggers onLoadMoreRestaurants once via post-frame check',
    (tester) async {
      var loadMoreCalls = 0;

      await tester.pumpWidget(
        buildTestWidget(
          restaurants: sampleRestaurants,
          isLoadingMore: false,
          hasMoreRestaurants: true,
          onLoadMoreRestaurants: () => loadMoreCalls++,
          width: 800, // Wide viewport so 2 cards fit easily
        ),
      );
      await tester.pumpAndSettle();

      expect(loadMoreCalls, 1);
    },
  );

  testWidgets('no continuation triggered when hasMoreRestaurants is false', (
    tester,
  ) async {
    var loadMoreCalls = 0;

    await tester.pumpWidget(
      buildTestWidget(
        restaurants: sampleRestaurants,
        isLoadingMore: false,
        hasMoreRestaurants: false,
        onLoadMoreRestaurants: () => loadMoreCalls++,
        width: 800,
      ),
    );
    await tester.pumpAndSettle();

    expect(loadMoreCalls, 0);
  });

  testWidgets(
    'loadMoreFailure displays ApiErrorWidget without removing restaurant cards and retries on press',
    (tester) async {
      var retryCalls = 0;
      final failure = Failure(
        errorMessage: 'Network error',
        exception: const ApiException(
          errorType: ApiErrorType.noInternetConnection,
          message: 'No internet',
        ),
      );

      await tester.pumpWidget(
        buildTestWidget(
          restaurants: sampleRestaurants,
          isLoadingMore: false,
          hasMoreRestaurants: true,
          loadMoreFailure: failure,
          onLoadMoreRestaurants: () => retryCalls++,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Restaurant A'), findsOneWidget);
      expect(find.text('Restaurant B'), findsOneWidget);
      expect(find.byType(ApiErrorWidget), findsOneWidget);

      // Tap retry button in ApiErrorWidget
      final retryFinder = find.text('Retry');
      expect(retryFinder, findsOneWidget);
      await tester.ensureVisible(retryFinder);
      await tester.tap(retryFinder);
      await tester.pump();

      expect(retryCalls, 1);
    },
  );
}
