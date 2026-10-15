import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meal_meat_user/core/errors/subscription_error_codes.dart';
import 'package:meal_meat_user/core/l10n/translations/app_localizations.dart';
import 'package:meal_meat_user/core/errors/failure_mapper.dart';

void main() {
  const expectedEnglish = <String, String>{
    SubscriptionErrorCodes.addressRequired:
        'Please add a delivery address before checkout.',
    'addressRequired': 'Please add a delivery address before checkout.',
    SubscriptionErrorCodes.noDelivery:
        'No restaurants currently deliver to this address.',
    'noDelivery': 'No restaurants currently deliver to this address.',
    SubscriptionErrorCodes.optionUncovered:
        'No restaurants for these options deliver to your address.',
    'optionUncovered':
        'No restaurants for these options deliver to your address.',
    SubscriptionErrorCodes.noPreparedRestaurants:
        'No restaurants currently have prepared meals or valid pricing for these options.',
    'noPreparedRestaurants':
        'No restaurants currently have prepared meals or valid pricing for these options.',
    SubscriptionErrorCodes.periodUnavailable:
        'No restaurants can serve the entire period with these options. Change your options and try again.',
    'periodUnavailable':
        'No restaurants can serve the entire period with these options. Change your options and try again.',
    SubscriptionErrorCodes.selectionRequired:
        'Choose the duration and start date to check the entire period.',
    'selectionRequired':
        'Choose the duration and start date to check the entire period.',
    SubscriptionErrorCodes.fridayUnavailable:
        'Friday service is unavailable for this tier.',
    'fridayUnavailable': 'Friday service is unavailable for this tier.',
    SubscriptionErrorCodes.pricingUnavailable:
        'Pricing is currently unavailable for these options.',
    'pricingUnavailable': 'Pricing is currently unavailable for these options.',
    SubscriptionErrorCodes.deadlinePassed:
        'The editing deadline for this day has passed.',
    SubscriptionErrorCodes.selectionDeadlinePassed:
        'The editing deadline for this day has passed.',
    SubscriptionErrorCodes.firstDayDeadline:
        'You can edit the first day within 24 hours of payment, subject to the displayed deadline.',
    SubscriptionErrorCodes.ordinaryDeadline:
        'Complete selections for later days at least 72 hours before service.',
    SubscriptionErrorCodes.fulfillmentPending:
        'Your subscription is being prepared. The calendar will appear when preparation is complete.',
    SubscriptionErrorCodes.autoSelectionFailed:
        'Automatic selection could not be completed. Review the day’s status before continuing.',
    SubscriptionErrorCodes.freezePreparationFailed:
        'Replacement days could not be prepared. The change was not approved.',
    SubscriptionErrorCodes.replacementCapacityUnavailable:
        'Replacement days do not have enough capacity. The change was not approved.',
    SubscriptionErrorCodes.replacementRestaurantsUnavailable:
        'No eligible restaurant can serve the replacement days. The change was not approved.',
    SubscriptionErrorCodes.emptyOptions: 'No options are currently available.',
    SubscriptionErrorCodes.loading: 'Loading…',
    SubscriptionErrorCodes.requestFailed:
        'Data could not be loaded. Try again.',
    SubscriptionErrorCodes.calendarRestaurantCoverageUnavailable:
        'No eligible restaurant covers your delivery address for this day.',
    SubscriptionErrorCodes.calendarBoxNotReady:
        'This restaurant does not have an approved menu for the delivery day.',
    SubscriptionErrorCodes.restaurantCapacityFull:
        'Restaurant capacity is full or unavailable for the delivery day.',
    SubscriptionErrorCodes.calendarNoSafeBox:
        'No full allergy-safe box is available for this day.',
    SubscriptionErrorCodes.calendarRestaurantBusy:
        'The selected restaurant is busy on the delivery day.',
    SubscriptionErrorCodes.calendarQuotaExhausted:
        'The selected restaurant has reached its selection repetition limit.',
    SubscriptionErrorCodes.dayLocked: 'Editing is closed for this day.',
    SubscriptionErrorCodes.dayFrozen:
        'This day is frozen as part of your subscription freeze.',
    SubscriptionErrorCodes.dayCancelled: 'This day was cancelled.',
    SubscriptionErrorCodes.freezeReplacementPoolUnavailable:
        'No replacement restaurants are available for freeze.',
    SubscriptionErrorCodes.freezeNoServiceDays:
        'No service days available to freeze.',
    SubscriptionErrorCodes.freezeLockedDaysCannotBeFrozen:
        'Locked days cannot be frozen. Choose later dates.',
  };

  const expectedArabic = <String, String>{
    SubscriptionErrorCodes.addressRequired: 'أضف عنوان توصيل قبل الدفع.',
    'addressRequired': 'أضف عنوان توصيل قبل الدفع.',
    SubscriptionErrorCodes.noDelivery:
        'لا توجد مطاعم توصل إلى هذا العنوان حاليًا.',
    'noDelivery': 'لا توجد مطاعم توصل إلى هذا العنوان حاليًا.',
    SubscriptionErrorCodes.optionUncovered:
        'لا توجد مطاعم لهذه الخيارات توصل إلى عنوانك.',
    'optionUncovered': 'لا توجد مطاعم لهذه الخيارات توصل إلى عنوانك.',
    SubscriptionErrorCodes.noPreparedRestaurants:
        'لا توجد مطاعم جاهزة بوجبات مؤهلة وأسعار صالحة لهذه الخيارات حاليًا.',
    'noPreparedRestaurants':
        'لا توجد مطاعم جاهزة بوجبات مؤهلة وأسعار صالحة لهذه الخيارات حاليًا.',
    SubscriptionErrorCodes.periodUnavailable:
        'لا توجد مطاعم تستطيع خدمة كامل الفترة بهذه الخيارات. غيّر الخيارات وحاول مجددًا.',
    'periodUnavailable':
        'لا توجد مطاعم تستطيع خدمة كامل الفترة بهذه الخيارات. غيّر الخيارات وحاول مجددًا.',
    SubscriptionErrorCodes.selectionRequired:
        'اختر المدة وتاريخ البداية للتحقق من كامل الفترة.',
    'selectionRequired': 'اختر المدة وتاريخ البداية للتحقق من كامل الفترة.',
    SubscriptionErrorCodes.fridayUnavailable:
        'لا تتوفر خدمة الجمعة لهذه الفئة.',
    'fridayUnavailable': 'لا تتوفر خدمة الجمعة لهذه الفئة.',
    SubscriptionErrorCodes.pricingUnavailable:
        'السعر غير متاح لهذه الخيارات حاليًا.',
    'pricingUnavailable': 'السعر غير متاح لهذه الخيارات حاليًا.',
    SubscriptionErrorCodes.deadlinePassed: 'انتهت مهلة تعديل هذا اليوم.',
    SubscriptionErrorCodes.firstDayDeadline:
        'يمكنك تعديل اليوم الأول خلال 24 ساعة من الدفع، وفق المهلة المعروضة.',
    SubscriptionErrorCodes.ordinaryDeadline:
        'يجب إكمال اختيار الأيام التالية قبل الخدمة بـ72 ساعة على الأقل.',
    SubscriptionErrorCodes.fulfillmentPending:
        'جارٍ تجهيز اشتراكك. سنعرض التقويم عند اكتمال التجهيز.',
    SubscriptionErrorCodes.autoSelectionFailed:
        'تعذر إكمال الاختيار التلقائي. راجع حالة اليوم قبل المتابعة.',
    SubscriptionErrorCodes.freezePreparationFailed:
        'تعذر تجهيز أيام التعويض. لم يُعتمد التغيير.',
    SubscriptionErrorCodes.replacementCapacityUnavailable:
        'لا تتوفر سعة كافية لأيام التعويض. لم يُعتمد التغيير.',
    SubscriptionErrorCodes.replacementRestaurantsUnavailable:
        'لا يوجد مطعم مؤهل لخدمة أيام التعويض. لم يُعتمد التغيير.',
    SubscriptionErrorCodes.emptyOptions: 'لا توجد خيارات متاحة حاليًا.',
    SubscriptionErrorCodes.loading: 'جارٍ التحميل…',
    SubscriptionErrorCodes.requestFailed: 'تعذر تحميل البيانات. حاول مجددًا.',
    SubscriptionErrorCodes.calendarRestaurantCoverageUnavailable:
        'لا يوجد مطعم مؤهل يغطي عنوان التوصيل لهذا اليوم.',
    SubscriptionErrorCodes.calendarBoxNotReady:
        'لا توجد قائمة معتمدة لهذا المطعم في يوم التوصيل.',
    SubscriptionErrorCodes.restaurantCapacityFull:
        'سعة المطاعم ممتلئة أو غير متاحة في يوم التوصيل.',
    SubscriptionErrorCodes.calendarNoSafeBox:
        'لا توجد وجبات كاملة آمنة للحساسية لهذا اليوم.',
    SubscriptionErrorCodes.calendarRestaurantBusy:
        'المطعم المختار مشغول في يوم التوصيل.',
    SubscriptionErrorCodes.calendarQuotaExhausted:
        'وصل المطعم المختار إلى حد تكرار الاختيار.',
    SubscriptionErrorCodes.dayLocked: 'تم إغلاق التعديل لهذا اليوم.',
    SubscriptionErrorCodes.dayFrozen:
        'هذا اليوم مجمّد ضمن فترة تجميد الاشتراك.',
    SubscriptionErrorCodes.dayCancelled: 'تم إلغاء هذا اليوم.',
    SubscriptionErrorCodes.freezeReplacementPoolUnavailable:
        'لا توجد مطاعم بديلة متاحة للتجميد.',
    SubscriptionErrorCodes.freezeNoServiceDays:
        'لا توجد أيام خدمة متاحة للتجميد.',
    SubscriptionErrorCodes.freezeLockedDaysCannotBeFrozen:
        'لا يمكن تجميد الأيام المقفولة. اختر تواريخ لاحقة.',
  };

  testWidgets('maps subscription backend contract codes in English', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (ctx) {
            context = ctx;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    for (final entry in expectedEnglish.entries) {
      expect(
        mapFailureMessage(context, entry.key),
        entry.value,
        reason: 'Failed mapping for key: ${entry.key}',
      );
    }
  });

  testWidgets('maps subscription backend contract codes in Arabic', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (ctx) {
            context = ctx;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    for (final entry in expectedArabic.entries) {
      expect(
        mapFailureMessage(context, entry.key),
        entry.value,
        reason: 'Failed mapping for key: ${entry.key}',
      );
    }
  });
}
