# Calendar Pagination and Customer Notifications — Gemini Implementation Plan

> **For agentic workers:** Execute this plan task-by-task using `superpowers:executing-plans` when available. Steps use checkboxes for tracking. This document is a handoff to Gemini, not an instruction for Codex to implement now.

**Goal:** ربط Pagination مطاعم اليوم وصندوق إشعارات العميل وجرس غير المقروء، مع الحفاظ على الواجهة الحالية واستخدام أخطاء Core وShimmer.

**Architecture:** حافظ على Feature-Based Clean Architecture الموجودة: Widget → Event → ViewModel → UseCase → Repository → RemoteDataSource → ApiServices. العودة عبر DTO → Mapper → Entity → ApiResult → State. وسّع Calendar وNotifications الحاليين؛ لا تنشئ networking أو push service جديدين.

**Tech Stack:** Flutter، flutter_bloc/Cubit باسم ViewModel، Dio، Retrofit، json_serializable، Injectable/GetIt، intl، ShimmerWidget الموجود، Flutter test.

**Spec:** دليل المستخدم «Pagination لمطاعم اليوم + إشعارات العميل ومؤشر غير المقروء»؛ النص محفوظ أيضًا في `C:/Users/orignal store/.codex/attachments/88586111-1f20-4d60-90f9-8907a80f2b62/Pasted text.txt`. على جهاز آخر استخدم نسخة الدليل المرفقة مع هذه الخطة. العقود المهمة منقولة أدناه حتى يكون التنفيذ ممكنًا دون الاعتماد على مسار جهاز Codex.

## 1. تعليمات ملزمة لجيميناي

- اقرأ `AGENTS.md` إن وجد، و`rules/ui_rules.md` و`rules/rules_backend.md` بالكامل قبل التنفيذ.
- اسم ملف الباك الموجود فعليًا هو `rules/rules_backend.md`؛ لو تعليمات قديمة تشير إلى `rules/backend_rules.md` فابحث عنه واتبع الموجود ولا تنشئ ملف قواعد بديلًا.
- اقرأ `lib/core/errors` و`lib/core/network/api_results.dart` و`failures.dart` قبل تصميم الأخطاء.
- استخدم `ApiServices` وDio و`safeApiCall` و`ApiResult` الموجودة؛ لا تضف Either أو Result جديدًا.
- Response DTO fields nullable؛ احتفظ بالـnull عندما له معنى مثل rating/readAtUtc/subscriptionId.
- لا تعدّل generated files يدويًا. ولّد Retrofit/JSON/Injectable بالـbuild_runner وlocalization بالطريقة الحالية.
- لا تغيّر تصميم الشاشات أو spacing أو الأصول. استعمل الموجود؛ لأي عنصر تصميم جديد غير محدد اطلب الـFigma node طبقًا لقواعد UI. لا تدّعِ فحص Figma دون فحصه.
- استخدم `lib/core/widget/shimmer_widget.dart` لكل تحميل محتوى أولي أو صفحات إضافية. لا تضف package جديدة ولا spinner بدل skeleton للمحتوى.
- لا تغيّر منطق `canEdit` أو الـ72 ساعة؛ الباك لم يوضح المشكلة بعد. القيمة القادمة من السيرفر هي المرجع.
- لا تستنتج حساسية من اسم الوجبة، ولا تعرض المصفوفة الفارغة على أنها خلو مؤكد.
- لا تضع token/UUID اشتراك تجريبي أو base URL جديدة في التنفيذ أو الاختبارات الحية.
- قبل البدء سجّل `git status --short`؛ يوجد مسبقًا تعديل في `test/address_coverage_preview_test.dart` وقت إعداد الخطة: اتركه كما هو.
- الخطة لا تعني تفويض publish أو deploy أو push أو تعديل backend. نفّذ محليًا واكتب تقرير التحقق، ولا تعمل commit إلا حسب تعليمات صاحب المشروع.

## 2. الواقع الحالي المثبت من الكود

| الجزء | الوضع الحالي | التغيير المطلوب |
|---|---|---|
| مطاعم اليوم API | `getSubscriptionCalendarDayRestaurants` يأخذ subscriptionId/date/query فقط | أضف optional page/pageSize |
| مطاعم اليوم datasource | `CalendarRemoteDataSourceImpl.getRestaurants` يرجع `response.restaurants` فقط | الاحتفاظ بالمغلف والـmetadata |
| مطاعم اليوم domain | UseCase/Repository يرجعان List فقط | نتيجة page entity مستقلة |
| RestaurantPickerViewModel | generation guard موجود، تحميل قائمة واحدة | تمديده لتحميل صفحات متسلسل وإعادة ضبط |
| CalendarResponseDto | لا يحتوي حقول غير المقروء | إضافة الحقلين ومَابنج حتى الجرس |
| CalendarScreenBody | يبني CalendarHeader دون تمرير unread | ربط انتقائي لحالة الجرس |
| NotificationsScreen | StatefulWidget وNotificationsFakeDataSource وقراءة/مسح محلي | ربط ViewModel وAPI دون إعادة تصميم |
| NotificationsRepository | تسجيل وإلغاء device token موجودان | إضافة inbox/read/read-all مع إبقاء token operations |
| Push | PushNotificationService وPushNotificationPayload موجودان | إعادة استخدامهما وتوحيد resolver والتنبيه لإعادة الجلب |
| Navigation | `mealmate://orders` يُحوَّل إلى calendar؛ Calendar route يقبل String فقط | إصلاح نقل arguments وحسم الوجهة وفق الموجود |
| rating | `4.5` في calendar_restaurant_mapper/day_mapper/meal_mapper | الحفاظ على null وعرض نص عدم التقييم |

## 3. العقود التي يجب تنفيذها حرفيًا

### مطاعم اليوم

```text
GET /api/v1/customer/subscriptions/{subscriptionId}/days/{date}/restaurants
query: optional String
page: optional int, يبدأ من 1
pageSize: optional int, الافتراضي 20، أقصى 100

response:
serviceDate, limit, adminCeiling, restaurants,
page, pageSize, totalCount, totalPages, hasNextPage, hasPreviousPage
```

الصفحة الأولى في الـpicker: page=1/pageSize=20. الـAPI يحافظ على الوضع القديم عند غياب المعاملين، فلا تجعل الـoptional defaults في جميع المستهلكين 1/20. أرسلها صراحة من الـpicker فقط.

الترتيب من السيرفر؛ لا تعمل sorting محليًا. `limit` حد استخدام المطعم، وليس pageSize. لا تعِد حساب `isEnabled` بالاعتماد على المطاعم الموجودة في الصفحة أو نتيجة البحث. صفحة بعد النهاية 200 بقائمة فارغة تعني توقف التحميل.

### التقويم وجرس الحساب

```text
GET /api/v1/customer/subscriptions/{subscriptionId}/calendar
root:
hasUnreadNotifications: bool
unreadNotificationsCount: int
```

العد للحساب بالكامل وليس الاشتراك. `GET calendar` لا يقرأ الإشعارات. المصدر الدقيق للعدد هنا فقط؛ Notifications Paged المذكور لا يحتوي unread count، وtotalCount هو عدد جميع الإشعارات.

### Inbox

```text
GET /api/v1/customers/me/notifications?page=1&pageSize=20
response: items, totalCount, page, pageSize, totalPages,
          hasNextPage, hasPreviousPage
item: id, eventKey, subjectId, subscriptionId?,
      titleAr, titleEn, bodyAr, bodyEn, deepLink,
      createdAtUtc, readAtUtc?

PUT /api/v1/customers/me/notifications/{id}/read -> 204, no body
PUT /api/v1/customers/me/notifications/read-all -> 204, no body
```

غير المقروء = readAtUtc == null. لا تتحول الحالة قبل نجاح PUT. القراءة idempotent. 401/403/404 وProblemDetails.code تمر عبر Core. ليس هناك DELETE أو endpoint للفئات أو إعدادات التفضيلات في هذا الدليل.

### الأحداث

| eventKey | category UI | icon موجود مقترح | deepLink | subjectId |
|---|---|---|---|---|
| subscription.payment_confirmed | subscription | packageCard | mealmate://calendar | subscriptionId |
| order.locked_72h | meals | mealCloche | mealmate://calendar | subscriptionDayId |
| order.confirmed_by_restaurant | meals | mealCheck | mealmate://orders | subscriptionDayId |
| delivery.prep_24h | meals | deliveryTruck | mealmate://calendar | subscriptionDayId |
| delivery.out_for_delivery | meals | deliveryTruck | mealmate://orders | subscriptionDayId |
| delivery.delivered | meals | mealCheck | mealmate://orders | subscriptionDayId |
| influencer.promoted | system | systemRefresh | mealmate://influencer-portal | userId |
| order.replaced | meals | mealCloche | /orders/{dayId} | subscriptionDayId |

هذا mapping عرض مقترح باستخدام enums الموجودة، وليس API filter. الحدث المجهول category=system/icon=systemRefresh مع إظهار النص الفعلي وعدم crash. لا تفترض subscriptionId في الإشعار العام.

## 4. مراحل التنفيذ وترتيبها

نفّذ A ثم B ثم C ثم D ثم E ثم F ثم G. كل مرحلة لها اختبارات مستقلة؛ لا تربط اكتمال مرحلة برفع السيرفر إن كان mock contract يكفي، لكن ميّز بين mocked verification والاختبار الحي.

### A — Pagination مطاعم اليوم عبر جميع الطبقات

**Modify:**

```text
lib/core/network/api_services.dart
lib/features/calendar/data/models/response/calendar_day_response_dto.dart
lib/features/calendar/data/data_source/calendar_remote_data_source.dart
lib/features/calendar/data/data_source/calendar_remote_data_source_impl.dart
lib/features/calendar/data/mapper/calendar_mapper.dart
lib/features/calendar/data/repo/calendar_repository_impl.dart
lib/features/calendar/domain/repo/calendar_repository.dart
lib/features/calendar/domain/usecase/get_calendar_restaurants_usecase.dart
```

**Create:**

```text
lib/features/calendar/domain/entities/calendar_restaurants_page_entity.dart
lib/features/calendar/data/mapper/calendar_restaurants_page_mapper.dart
test/calendar_restaurants_pagination_contract_test.dart
```

- [ ] قبل التغيير ابحث بـ`rg -n 'getRestaurants|getSubscriptionCalendarDayRestaurants|CalendarRestaurantsResponseDto' lib test` وحدد كل المستهلكين والمزيّفات.
- [ ] أضف حقول nullable الستة في `CalendarRestaurantsResponseDto` الموجود. لا تحذف restaurantCount أو أي حقول قديمة يستخدمها endpoint آخر.
- [ ] أضف named optional page/pageSize إلى Retrofit بعد positional arguments الحالية للحفاظ على calls القديمة.
- [ ] غيّر datasource `getRestaurants` ليرجع `Future<CalendarRestaurantsResponseDto>` بدل List، ويُمرر query/page/pageSize.
- [ ] أنشئ domain page entity وmapper خاصًا بالمغلف؛ لا تضع DTO في State.

**Domain interface:**

```dart
class CalendarRestaurantsPageEntity {
  const CalendarRestaurantsPageEntity({
    required this.restaurants,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });
  final List<CalendarRestaurantOptionEntity> restaurants;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;
}

// Identical parameters at Repository and UseCase.call:
Future<ApiResult<CalendarRestaurantsPageEntity>> getRestaurants({
  required String subscriptionId,
  required String date,
  required String localeName,
  String? query,
  int? page,
  int? pageSize,
});
```

تعريف entity يتطلب import للـoption entity. UseCase يستخدم `call` بنفس parameters وreturn type، وRepositoryImpl يلف remote+mapper بـsafeApiCall.

- [ ] Mapper يحافظ على metadata؛ لو response قديم لا يحتويها: page=1، pageSize=max(1, raw restaurants count)، totalCount=raw count، totalPages=القائمة فارغة؟0:1، hasNext=false، hasPrevious=false. هذا توافق مع النسخة القديمة وليس دليل نجاح نشر pagination.
- [ ] حوّل items بالطريقة الحالية واستبعد IDs الفارغة، ولا تغيّر totalCount حسب عدد العناصر بعد تنقية IDs.
- [ ] لا تغيّر endpoint غير المرتبط بتاريخ أو تفرض paging عليه.
- [ ] اكتب اختبار adapter مثل `test/calendar_restaurants_request_test.dart` يثبت path/query وmetadata؛ وعدّل الاختبار القديم ليفحص `response.restaurants` بعد تغيير datasource type.
- [ ] اختبر response ناقص fields، response فارغ بعد النهاية، disabled restaurant في صفحة بها مطعم واحد، وعدم إرسال page/pageSize في legacy call.

### B — Pagination في الـpicker مع Shimmer وأخطاء مستقلة

**Modify:**

```text
lib/features/calendar/presentation/manager/restaurant_picker/restaurant_picker_event.dart
lib/features/calendar/presentation/manager/restaurant_picker/restaurant_picker_state.dart
lib/features/calendar/presentation/manager/restaurant_picker/restaurant_picker_view_model.dart
lib/features/calendar/presentation/widgets/calendar_restaurant_selection_sheet.dart
lib/features/calendar/presentation/widgets/calendar_restaurant_picker_sheet.dart
lib/features/calendar/presentation/widgets/calendar_restaurant_picker_loading_skeleton.dart
lib/features/calendar/presentation/screens/calendar_navigation_coordinator.dart
```

عدّل الـcoordinator/selection sheet فقط حيث تمرير state/callbacks الفعلي، بعد القراءة. `calendar_restaurant_picker_loading_skeleton.dart` وملفات أخرى هنا تستخدم `part of`؛ لا تحولها إلى مكتبات مستقلة بدون داعٍ.

**Create:** `test/calendar_restaurants_pagination_view_model_test.dart`، `test/calendar_restaurants_pagination_widget_test.dart`.

- [ ] أضف State: page=0، pageSize=20، totalCount=0، hasNextPage=false، isLoadingMore=false، loadMoreFailure nullable. أبقِ isLoading/selection fields الموجودة.
- [ ] أضف `LoadMoreRestaurantsEvent` و`RetryRestaurantsPageEvent`؛ `loadMore()` و`retryLoadMore()` بلا parameters تستخدم context المحفوظ للتحميل الحالي.
- [ ] context في ViewModel: subscriptionId، date formatted، localeName، normalized query. أي تغيير بينها reset كامل وgeneration جديد.
- [ ] عند `load` reset restaurants/page/metadata/loadMoreFailure. query الفارغة تمسح السابقة صراحة (`clearQuery`)؛ لا تترك copyWith يحتفظ ببحث قديم.
- [ ] احتفظ بالـ300ms debounce الموجود؛ لا تضف debounce آخر. عند تغيير النص فورًا أبطل responses القديمة ومنع loadMore لبحث قديم خلال انتظار debounce، ثم أرسل query بعد الـ300ms.
- [ ] عند scroll near end استخدم controller أو ScrollNotification الموجود؛ trigger عند extentAfter <= 200 logical pixels. هذا threshold سلوك تحميل، وليس تغيير تصميم. لا تطلب من داخل build.
- [ ] loadMore guard: loading initial/loading more/hasNext=false/context غير جاهز تمنع الطلب. retry بعد خطأ لا يزيد رقم الصفحة قبل النجاح.
- [ ] emit isLoadingMore=true قبل await؛ اطلب page+1/pageSize=20؛ ثم افحص isClosed/generation/context قبل تغيير أي state.
- [ ] merge بترتيب السيرفر وبمفتاح id؛ تجاهل التكرار بدون إعادة ترتيب. لا تستخدم sort حسب quota/rating/name.
- [ ] عند نجاح الصفحة حدّث page من response.page، totalCount وhasNextPage. القائمة الخام الفارغة توقف next حتى لو metadata متناقضة لمنع loop.
- [ ] فشل loadMore يحافظ على rows/page ويعرض footer retry من Core. فشل initial يظهر ApiErrorWidget في مساحة القائمة. empty بعد نجاح initial يعرض empty widget الحالي.
- [ ] initial loading يستخدم skeleton الموجود؛ loadMore يستخدم جزء skeleton صغير في footer. عند selection loading لا تستبدل القائمة كلها؛ امنع النقر المتكرر فقط.
- [ ] تغيير التاريخ/الاشتراك/locale أو clear/close يُبطل initial وloadMore. لا تُرجع نتيجة قديمة لتصبح failure أو تطفئ loading الجديد.
- [ ] اختبر: trigger مكرر=طلب واحد؛ pages 1 ثم2؛ IDs مكررة؛ search/date reset؛ old success/old failure ignored؛ retry نفس الصفحة؛ clear أثناء طلب؛ no next؛ 200 empty.

**المقصود بالتسلسل:** لا يوجد أكثر من طلب صفحات نشط لنفس context. عند تغيير context يمكن أن يكون طلب قديم على الشبكة لكن نتيجته مهملة؛ لا تضف CancelToken architecture جديدة إذا generation guard يكفي.

### C — صندوق الإشعارات: DTO، Domain، Mapper وUseCases

**Modify:**

```text
lib/core/network/network_constants.dart
lib/core/network/api_services.dart
lib/features/notifications/data/data_source/notifications_remote_data_source.dart
lib/features/notifications/data/data_source/notifications_remote_data_source_impl.dart
lib/features/notifications/data/repo/notifications_repository_impl.dart
lib/features/notifications/domain/repo/notifications_repository.dart
lib/features/notifications/domain/entities/notification_item_entity.dart
```

**Create:**

```text
lib/features/notifications/data/models/response/notification_item_response_dto.dart
lib/features/notifications/data/models/response/notifications_page_response_dto.dart
lib/features/notifications/data/mapper/notifications_mapper.dart
lib/features/notifications/domain/entities/notifications_page_entity.dart
lib/features/notifications/domain/usecase/get_notifications_usecase.dart
lib/features/notifications/domain/usecase/mark_notification_read_usecase.dart
lib/features/notifications/domain/usecase/mark_all_notifications_read_usecase.dart
test/notifications_api_contract_test.dart
test/notifications_mapper_test.dart
```

**Interfaces:**

```dart
// Repository:
Future<ApiResult<NotificationsPageEntity>> getNotifications({
  required int page,
  required int pageSize,
});
Future<ApiResult<void>> markNotificationRead(String id);
Future<ApiResult<void>> markAllNotificationsRead();

// ApiServices uses endpoint constants, not literal URLs here:
@GET(EndPoints.customerNotifications)
Future<NotificationsPageResponseDto> getCustomerNotifications(
  @Query('page') int page,
  @Query('pageSize') int pageSize,
);
@PUT(EndPoints.customerNotificationRead)
Future<void> markCustomerNotificationRead(@Path('id') String id);
@PUT(EndPoints.customerNotificationsReadAll)
Future<void> markAllCustomerNotificationsRead();
```

Endpoint constant values: `/api/v1/customers/me/notifications`، `/api/v1/customers/me/notifications/{id}/read`، `/api/v1/customers/me/notifications/read-all`، حسب أسلوب constants الحالي. UseCases.call تعكس signatures بنفس types. Datasource يرجع DTO أو void، repository يرجع ApiResult.

- [ ] DTO item يحتوي جميع fields المذكورة، String? للنصوص والمعرّفات وDateTime? للتواريخ، مع JsonSerializable. المغلف items nullable وmetadata nullable.
- [ ] Domain raw item يحتفظ بـtitleAr/titleEn/bodyAr/bodyEn/eventKey/subjectId/subscriptionId/deepLink/createdAtUtc/readAtUtc. وسّع entity الموجودة دون جعل enum UI أو BuildContext جزءًا من JSON mapper.
- [ ] حافظ على compatibility constructors للـfake datasource/اختباراته إلى أن ينتهي نقل كل usages. `isRead` مشتق من timestamp أو علامة acknowledgment للـPUT الناجح؛ لا تحتفظ بقيمتين متناقضتين.
- [ ] API لا يعيد readAtUtc مع 204؛ عند النجاح timestamp محلي UTC يمثل acknowledgment مؤقتًا فقط، ثم يستبدله الجلب التالي بقيمة السيرفر. لا تقدمه كتوقيت القراءة الأصلي الدقيق.
- [ ] انسخ كِلا اللغتين للـdomain. اختيار اللغة وتنسيق timeText/isToday/category/icon يتم في presentation mapper مستقل، فلا يحتاج locale change لطلب آخر.
- [ ] entity page: items، page، pageSize، totalCount، totalPages، hasNextPage، hasPreviousPage. لا تضف unreadCount مشتقًا من هذه الصفحة.
- [ ] Mapper يستبعد item بدون id ولا يغيّر totalCount. createdAtUtc المفقود لا يصير الآن تلقائيًا؛ اعرض بدون وقت بدل تاريخ مزيف. استخدم سياسة التوافق القديمة A فقط إذا fields pagination مفقودة وسجّل أن metadata غير مؤكدة.
- [ ] كلا PUT يرجعان void ويعملان مع empty body؛ لا تحاول JSON parsing لرد 204.
- [ ] جميع عمليات repository عبر safeApiCall، وإبقاء registerDeviceToken/unregisterDeviceToken كما هما.
- [ ] اختبارات adapter: GET query parameters، PUT exact path/method/no body، repeated PUT success، 401/403/404/500 ProblemDetails.code يصل إلى Failure.

### D — جرس الحساب: مصدر واحد ومزامنة آمنة

**Modify:**

```text
lib/features/calendar/data/models/response/calendar_response_dto.dart
lib/features/calendar/domain/entities/calendar_subscription_entity.dart
lib/features/calendar/data/mapper/calendar_mapper.dart
lib/features/calendar/presentation/manager/overview/calendar_overview_view_model.dart
lib/features/calendar/presentation/screens/calendar_screen_body.dart
lib/features/calendar/presentation/widgets/calendar_header.dart
```

**Create:**

```text
lib/features/notifications/presentation/manager/notification_badge_state.dart
lib/features/notifications/presentation/manager/notification_badge_view_model.dart
test/notification_badge_view_model_test.dart
```

الاختيار المعتمد: Badge ViewModel واحد account-scoped عبر Injectable/GetIt، لأن NotificationsScreen route مستقل عن Calendar providers. الـCalendarOverview ينشر count إليه؛ الـNotifications ViewModel ينشر acknowledgments إليه. لا تجعل screen-scoped cubit آخر يمثل مصدر العدد.

**Interfaces المقترحة:**

```dart
void acceptCalendarCount(int count, {required int requestVersion});
int beginCalendarCountRequest();
void acknowledgeRead(String notificationId);
void acknowledgeReadAll();
void resetForAccountChange();
Future<void> refreshCount({required String subscriptionId,
  required String localeName});
```

- [ ] Calendar DTO: bool? hasUnreadNotifications/int? unreadNotificationsCount. Domain يحافظ على count nullable للتفريق بين missing و0؛ hasUnread مشتق من count عند توفره.
- [ ] BadgeState: int? unreadCount وbool isRefreshing وFailure? refreshFailure. null=غير معروف وليس صفرًا مؤكدًا. getter hasUnread = (unreadCount ?? 0)>0.
- [ ] حقن badge في CalendarOverview وNotificationsViewModel عبر constructor. Singleton له عمر session/app؛ لا يغلقه CalendarScreen.dispose.
- [ ] كل request للعد يلتقط version قبل الشبكة. زيادة version بعد نجاح read/read-all/account change تُبطل snapshots القديمة. لا يمكن لرد calendar قديم أن يعيد الجرس بعد قراءة الكل.
- [ ] `acknowledgeRead`: بعد PUT success لإشعار كان unread فعلًا، decrement مرة واحدة وبحد أدنى صفر إذا العدد معروف. IDs التي طُبقت عليها العملية محفوظة لمنع تكرار النقص، وتمسح بعد authoritative refresh مناسب أو تبديل الحساب.
- [ ] عند count unknown لا تحوّله إلى صفر بسبب قراءة عنصر. read-all الناجح يسمح count=0. الفشل لا يغيّر count.
- [ ] `refreshCount` يعيد استخدام GetCalendarUseCase. احفظ active subscription من calendar bootstrap. لا تبنِ URL جديدًا ولا تحسب count من inbox loaded items.
- [ ] تجنّب refresh count الموازي لـcalendar load: نتيجة التقويم العادي تكفي. coalesce requests الجرس؛ mutation أثناء refresh يُبطل نتيجته ويتبعها refresh واحد بعد هدوء العمليات.
- [ ] لو count missing في نسخة السيرفر القديمة لا تمسح قيمة معروفة. لا تعرض رقمًا جديدًا على الجرس إن التصميم الحالي يعرض dot فقط؛ مرّر hasNotification إلى NotificationButton الموجود.
- [ ] اربط CalendarHeader بBlocSelector للـbool فقط؛ تغيير badge لا يعيد بناء CalendarContent أو اختيار الوجبات.
- [ ] عند logout/account change clear count/IDs/subscription/version؛ استخدم مسار session/logout الحالي بعد البحث عنه. لا تعرض بيانات مستخدم سابق للمستخدم الجديد.
- [ ] لا اشتراك صالح؟ inbox يعمل لأنه account-level، لكن العدد الدقيق غير متاح من العقد الحالي؛ حافظ على unknown واطلب backend unread-count endpoint إن كان الجرس مطلوبًا لهذه الحالة. لا تضع اشتراك وهميًا ولا تجلب كل الصفحات لحساب العدد.

### E — شاشة الإشعارات الحقيقية مع Shimmer

**Modify:**

```text
lib/features/notifications/presentation/screens/notifications_screen.dart
lib/features/notifications/presentation/widgets/notification_card.dart
lib/features/notifications/presentation/widgets/notification_section_action_row.dart
lib/features/notifications/presentation/widgets/notification_clear_all_button.dart
lib/config/routing/routing_generator.dart
lib/core/l10n/app_ar.arb
lib/core/l10n/app_en.arb
```

**Create:**

```text
lib/features/notifications/presentation/manager/notifications_event.dart
lib/features/notifications/presentation/manager/notifications_state.dart
lib/features/notifications/presentation/manager/notifications_view_model.dart
lib/features/notifications/presentation/mapper/notification_presentation_mapper.dart
lib/features/notifications/presentation/widgets/notifications_loading_skeleton.dart
test/notifications_view_model_test.dart
test/notifications_screen_api_test.dart
```

State: raw items، visible presentation items، selectedCategory، page/pageSize/totalCount/hasNextPage، isLoading/isRefreshing/isLoadingMore، Failure? initialFailure/refreshFailure/loadMoreFailure، Set<String> readingIds، bool isMarkingAllRead، one-shot action failure/navigation effect وفق pattern المشروع. لا تضع BuildContext في ViewModel.

Events: LoadNotifications، RefreshNotifications، LoadMoreNotifications، SelectNotificationCategory، MarkNotificationRead(id)، MarkAllNotificationsRead، LocaleChanged. استخدم doIntent مثل ViewModels الحالية؛ signatures تتحدد بهذه البيانات فقط.

- [ ] افتح route مع injected screen-scoped ViewModel؛ init يرسل page1/pageSize20 مرة واحدة. لا API في build. screen dispose يغلق المملوك فقط، وليس singleton badge.
- [ ] pagination/race guards مثل B؛ refresh يبقي rows إلى النجاح ويعيد page1؛ فشله يبقي البيانات ويعرض error صغير مع retry.
- [ ] initial Shimmer يعكس أبعاد notification cards الحالية باستخدام ShimmerWidget/ShimmerPlaceholder، بدون fake text. loadMore Shimmer footer لا يمسح المحتوى.
- [ ] لا تُصفّر unread ولا تطلب PUT لمجرد فتح قائمة الإشعارات.
- [ ] عند tap: امنع double tap لنفس id باستخدام readingIds؛ إذا already read تنقّل مباشرة. إذا unread نفّذ PUT أولًا؛ عند success حدّث row/badge ثم navigation؛ عند failure ابقِ unread ولا تنقّل في هذا الفلو، وأظهر Core message مع إمكانية إعادة الضغط.
- [ ] mark-all يعمل على الحساب كله بما فيه عناصر خارج الصفحة/الفئة. امنع بدء read-single أثناء read-all، وانتظر single reads النشطة قبل تنفيذ read-all لمنع double decrement. بعد success حدّث loaded rows وصفر badge ثم silent refresh واحد.
- [ ] GET بدأ قبل PUT success لا يعيد row لغير مقروء: epoch guard أو merge acknowledgment overlay، ثم re-fetch. لا تعرض نتيجة query أقدم من mutation.
- [ ] زر NotificationClearAllButton حاليًا يحذف القائمة محليًا. لا توصله بـread-all لأن القراءة ليست حذفًا. لا يوجد DELETE endpoint: أخفِ هذا control غير المدعوم في الربط الحقيقي وسجّل الأمر في التقرير؛ لو يلزم بقاؤه وفق Figma اطلب عقد الحذف قبل تفعيله.
- [ ] حافظ على category tabs؛ التصفية للـloaded items فقط ولا تغيّر API query ولا global badge. الترتيب newest first من السيرفر.
- [ ] إن فئة مختارة بلا visible items ومع hasNext=true، أبقِ footer/load-more reachable لطلب الصفحات التالية؛ لا تعرض empty نهائيًا حتى انتهاء الصفحة الأخيرة. auto-load يكون متسلسلًا أثناء هذه الحالة ولا ينشئ loop على response فارغ.
- [ ] لا تعرض كل تاريخ أقدم تحت Yesterday كما يفعل fake screen. كوّن Today/Yesterday/Earlier من createdAtUtc.toLocal() وحدود اليوم المحلي؛ اعرض مفتاح Earlier مترجمًا من tokens الحالية بلا redesign.
- [ ] presentation mapper يختار ar/en من لغة التطبيق ويعمل fallback إلى اللغة الأخرى فقط لو النص المطلوب فارغ. locale change يعيد projection من raw texts دون network request.
- [ ] استخدم localized relative time الموجود إن وجد، وإلا intl formatting مترجم؛ لا تُفرّغ UTC Z ولا تعامل التاريخ كتوقيت محلي قبل parsing.
- [ ] إعدادات notification preferences خارج العقد هنا: أبقِ navigation الموجود، ولا تدّعِ ربط preferences backend أو تضف endpoints من عندك.
- [ ] في build استعمل projections المعدّة في state/mapper؛ BlocSelector/buildWhen للقائمة والأزرار. قراءة row لا تعيد بناء الهيدر والـtabs بلا داعٍ.

### F — Deep links، الـPush، والعودة للمقدمة

**Modify:**

```text
lib/core/services/push_notification_payload.dart
lib/core/services/push_notification_service.dart
lib/config/routing/routing_generator.dart
lib/features/calendar/presentation/screens/calendar_screen.dart
lib/features/calendar/presentation/manager/overview/calendar_overview_view_model.dart
```

**Create:** `test/notification_deep_links_test.dart`، `test/notifications_resume_refresh_test.dart`.

- [ ] اقرأ NavigatorService والـroute args الفعلية قبل التعديل. PushNotificationPayload حاليًا يرسل Map لكن Calendar route يقبل String فقط؛ لا يكفي إضافة URI mapping دون إصلاح استهلاك arguments.
- [ ] استخدم resolver مشترك داخل PushNotificationPayload أو helper صغير واحد بين inbox والـpush؛ لا تبنِ جدولين مختلفين.
- [ ] URI parse يدعم mealmate://calendar، mealmate://orders، mealmate://influencer-portal، والمسار النسبي `/orders/{dayId}`. المسار الأخير يستخرج dayId وليس date.
- [ ] مرّر subscriptionId nullable وsubjectId/eventKey/dayId إلى route args typed إن لزم، مع backward compatibility للـString القديم.
- [ ] calendar notification بدون subscriptionId يحل current subscription بالطريقة الموجودة؛ influencer route لا يعتمد على subscription، ويتحقق من access الحالي.
- [ ] لا تفسّر subjectId دومًا كـdayId: payment_confirmed subject اشتراك، وinfluencer.promoted subject مستخدم.
- [ ] ميّز بين subscriptionDayId وserviceDate؛ endpoint getDay الحالي يحتاج date. لو route اليوم المطلوب لا يملك dayId→date resolver، لا تحوّل UUID إلى date ولا تختار اليوم الحالي وتدّعي فتح الطلب المحدد. اطلب عقد lookup/route مناسب، ويمكن فتح الوجهة العامة مع توضيح هذا القيد في تقرير التنفيذ.
- [ ] `mealmate://orders` موجود حاليًا كـcalendar alias ولا يوجد AppRoutes.orders في الملف المقروء؛ راجع بقية project أولًا. لا تنشئ Orders feature ضمن هذه الخطة. الحفاظ على alias ممكن للتنقل العام فقط، أما طلب محدد فله blocker منفصل أعلاه.
- [ ] unknown/malformed link لا يسبب crash أو pushNamed لمسار غير مسجل؛ احتفظ بقراءة الإشعار الناجحة وأبقِ المستخدم على inbox مع message مترجم إذا لزم.
- [ ] لا تمرر raw route من data بدون allowlist للـroutes الموجودة؛ لا تكسر الصيغ القديمة التي تستخدم route مع arguments صحيحة.
- [ ] push reception يستدعي invalidation/refresh للـinbox إذا مفتوح وللجرس إذا subscription معلوم؛ لا تضف +1 محليًا لأن تكرار push وعدم وصوله لا يعكسان المصدر الحقيقي.
- [ ] push tap لا يطلب read إلا إذا backend يوفر notification inbox id صريحًا؛ subjectId ليس notification id. لا تضف id افتراضيًا ولا تعتبر فتح calendar قراءة.
- [ ] حافظ على تسجيل token/token refresh/foreground notifications/cold start الموجودين. وحّد navigation فقط وأضف refresh hooks، ولا تكرر FirebaseMessaging subscriptions.
- [ ] عند AppLifecycleState.resumed: inbox المفتوح يعمل silent refresh page1، والجرس يعمل calendar-count refresh إذا subscription معلوم. Debounce/coalesce للأحداث المتتابعة؛ observer على مستوى واحد ومسجّل/مزال حسب lifecycle.
- [ ] count-only refresh لا يستدعي loadCalendar بالطريقة التي تعيد اختيار اليوم وتعرض shimmer لكل التقويم؛ استخدم usecase ثم merge badge فقط. لا يمسح scroll أو meal draft.
- [ ] اختبار opened/foreground/cold-start مع navigator جاهز ومتأخر؛ route args تصل للوجهة؛ link نسبي؛ subscription null؛ unknown event؛ malformed link؛ resumed لا يكرر listeners.

### G — قواعد العرض والتقييم والخطأ والتحقق النهائي

**Modify within actual consumers only:**

```text
lib/features/calendar/data/mapper/calendar_restaurant_mapper.dart
lib/features/calendar/data/mapper/calendar_day_mapper.dart
lib/features/calendar/data/mapper/calendar_meal_mapper.dart
lib/features/calendar/domain/entities/calendar_restaurant_entity.dart
lib/features/calendar/domain/entities/calendar_restaurant_option_entity.dart
lib/features/calendar/presentation/widgets/calendar_rating.dart
lib/features/calendar/presentation/widgets/calendar_restaurant_text_block.dart
lib/features/meal_details/presentation/mapper/calendar_meal_details_mapper.dart
```

اقرأ أيضًا `calendar_menu_mapper.dart` وMealDetailsEntity وrestaurant_menu consumers قبل تغيير rating type؛ عدّل فقط المستهلكين المتأثرين، لا كل تقييمات التطبيق أو fake models بلا علاقة.

- [ ] rating في domain numeric nullable `double?` إن كان مناسبًا للمستهلكين الحاليين؛ لا تستخدم `'0'` أو `''` لتمثيل «بلا تقييم» ولا 4.5. مرّر null عبر route/presentation mappers حتى آخر widget.
- [ ] عند null/ratingCount0 اعرض مفتاح localization لـ«لا توجد تقييمات»/“No reviews yet”؛ لا نجمة مع رقم وهمي. ratingCount وحده لا ينتج rating.
- [ ] LanguageInterceptor الموجود يضبط Accept-Language: لا تكرر header في repositories. لا تُفعّل X-Bilingual عالميًا دون داعٍ؛ اختيار اللغة بالتقويم يستخدم header ثم refetch عند تبديلها، وinbox يحتفظ باللغتين أصلًا.
- [ ] حافظ على allergens كما تأتي، ولا تضف inferred EGG/MILK ولا badge خلو مؤكد. نقص catalog مسؤولية backend.
- [ ] caloriesPercentage تُعرض كنسبة من «المرجع اليومي»؛ الحساب backend الحالي مرجعه2400، لكن لا تسميه هدف المستخدم ولا تحسب هدفًا شخصيًا من البرنامج. استخدم percentage القادمة ولا تُدخل 2400 كهدف client جديد.

**مصفوفة الأخطاء الإلزامية:**

| الحالة | الـUI المطلوب |
|---|---|
| initial GET failed بلا محتوى | `ApiErrorWidget(exception: failure.exception, onRetry: ...)` في منطقة المحتوى |
| loadMore failed | rows محفوظة + footer retry يستخدم Core error presentation |
| refresh failed مع محتوى | rows/count محفوظة + رسالة Core صغيرة/retry |
| PUT read/read-all failed | الحالة والجرس كما هما + `ErrorMessagePresenter.fromFailure` عبر listener مرة واحدة |
| GET نجح بقائمة فارغة | empty state الحالي وليس error |
| 401 | مسار انتهاء الجلسة الموجود عبر TokenInterceptor؛ لا login flow آخر |
| 403 | forbidden مترجم، لا endless retry ولا fake notifications |
| 404 common.not_found | رسالة mapped code، لا fallback لعنوان ProblemDetails |
| malformed data | mapper defensive دون crash ودون اختلاق business values |

استعمل `error_presentation.dart` و`ApiExceptionMapper` و`Failure` الموجودة. `InlineApiErrorWidget` الحالي يحتوي نصوصًا hardcoded؛ لا تنسخها أو تضيف بديل feature-local للأخطاء. لو اخترت استخدامه للـfooter، اجعل النصوص تُترجم بالـErrorMessagePresenter/localization بتعديل محدود ومبرر، أو استعمل ApiErrorWidget الموجود في مساحة footer مناسبة دون تغيير Core تصميميًا.

## 5. خطة الاختبارات الدقيقة

كل مرحلة سلوكية: اكتب الاختبارات أولًا، شغّلها لإثبات الفشل المتوقع، نفّذ أقل تغيير، ثم شغّلها لإثبات المرور. لا تستخدم فشلًا من missing Flutter SDK كإثبات regression. استخدم flutter_test والـHttpClientAdapter/completers/fakes الموجودة، بدون إضافة mock package.

### Fixture أساسي مطاعم اليوم

```json
{"serviceDate":"2026-10-15","limit":8,"adminCeiling":8,
 "restaurants":[{"restaurantId":"r1","nameEn":"Kitchen","rating":null,
 "ratingCount":0,"isEnabled":false,"disabledReason":"calendar.quota_exhausted"}],
 "page":1,"pageSize":20,"totalCount":21,"totalPages":2,
 "hasNextPage":true,"hasPreviousPage":false}
```

الصفحة2 ترجع r1 مكررًا وr2؛ expected unique ids=[r1,r2]، r1 يظل disabled، page=2. الطلب التالي فاشل ثم retry يطلب نفس next page بلا تخطي. استعمل Completer لتسليم response قديم بعد search/date reset.

### Fixture أساسي Notifications

```json
{"items":[{"id":"n1","eventKey":"order.confirmed_by_restaurant",
 "subjectId":"day-1","subscriptionId":"sub-1","titleAr":"تم التأكيد",
 "titleEn":"Confirmed","bodyAr":"وجبتك جاهزة","bodyEn":"Your meal is ready",
 "deepLink":"mealmate://orders","createdAtUtc":"2026-10-05T09:00:00Z",
 "readAtUtc":null}],"totalCount":41,"page":1,"pageSize":20,
 "totalPages":3,"hasNextPage":true,"hasPreviousPage":false}
```

- initial فتح inbox: GET فقط، لا PUT.
- n1 tap وPUT معلق: isRead=false والجرس=5، readingIds يحتوي n1.
- PUT نجاح204: isRead=true، الجرس=4، navigation effect مرة واحدة.
- tap نفس العنصر مجددًا: لا decrement جديد.
- PUT فشل403: isRead=false، badge5، لا navigation، localized error.
- read-all نجاح: كل loaded rows read، badge0 حتى لو totalCount41 ولم تُحمّل بقية الصفحات.
- read-all فشل: لا تغيير loaded rows أو badge.
- calendar count response بدأ قبل read-all وأكمل بعدها: لا يعيد badge5.
- page1 GET بدأ قبل read-single: لا يعيد n1 إلى unread بعد acknowledgment.
- locale en→ar: title يتغير دون GET جديد.
- totalCount41/items1: لا يصبح unread41 أو1؛ عداد الجرس لا يعتمد عليهما.
- generic notification subscriptionId=null: لا force unwrap، لا فتح اشتراك subjectId بالخطأ.
- yesterday/earlier boundary: استعمل now ثابتًا في mapper test بدل الاعتماد على يوم تشغيل الاختبار.
- category بلا نتائج loaded مع next=true: ما زال يمكن تحميل الصفحة التالية.
- loadMore failure يحافظ على scroll/rows ويعرض retry، لا full-screen error.
- Widget loading: ShimmerWidget موجود، spinner للمحتوى غير موجود، RTL/LTR لا overflow.
- badge rebuild test: تغير الجرس لا يعيد بناء CalendarContent أو يغير selectedDate.
- logout ثم late response: count/items الخاصة بالحساب السابق لا تظهر.

**مثال assertion عقد الطلب بعد تسجيله بالـadapter:**

```dart
expect(recordedOptions.method, 'GET');
expect(recordedOptions.uri.path,
  '/api/v1/customer/subscriptions/sub-1/days/2026-10-15/restaurants');
expect(recordedOptions.uri.queryParameters['page'], '1');
expect(recordedOptions.uri.queryParameters['pageSize'], '20');
expect(recordedOptions.uri.queryParameters['query'], 'Kitchen');
```

هذه assertions تُضاف إلى أسلوب adapter الموجود في `test/calendar_restaurants_request_test.dart`؛ recordedOptions هو RequestOptions الذي خزّنه adapter الاختبار. لا تضع هذا المثال في production.

## 6. أوامر التنفيذ والتحقق

- [ ] سجّل baseline analyzer/tests relevant قبل تعديل التطبيق؛ ميّز failures الموجودة من الجديدة.
- [ ] بعد DTO/Retrofit/Injectable:

```powershell
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

- [ ] format الملفات المعدّلة فقط بـ`dart format <explicit files>`؛ لا تعمل format لكامل المشروع.
- [ ] شغّل كل اختبار جديد بالاسم؛ ثم regression الموجودة:

```powershell
flutter test test/calendar_restaurants_request_test.dart
flutter test test/calendar_restaurants_backend_state_test.dart
flutter test test/calendar_overview_cubit_test.dart
flutter test test/calendar_rebuild_scope_test.dart
flutter test test/calendar_confirm_meals_test.dart
flutter test test/calendar_cubit_provider_lifecycle_test.dart
flutter analyze
git diff --check
git status --short
```

- [ ] تحديث test fakes المتأثرة بتغيير signatures متطلب، وليس حذف tests أو إضعاف assertions.
- [ ] generated diff لا يتضمن refactor غير مرتبط. لا تغيّر test/address_coverage_preview_test.dart الذي كان modified مسبقًا.
- [ ] تحقق بصريًا على الجهاز/المحاكي: initial shimmer/append shimmer، retry، empty، AR/EN، RTL/LTR، read/read-all، scroll، return from notification، resume، selected calendar day محفوظ.
- [ ] اختبر حيًا على بيئة نُشرت عليها النسخة الجديدة بحساب مصرح؛ إن endpoint لم يُنشر، سجّل live verification blocked مع response الفعلي ولا تعرض fake success.

## 7. حدود العقد التي لا يجوز اختلاق حلول لها

1. `canEdit=false` بعد confirm وقبل الـ72 ساعة: اطلب قاعدة backend الصريحة، واترك server flag كما هو.
2. DELETE notifications غير موجود: لا تنفّذ «مسح الكل» محليًا أو ترسل endpoint مخمنًا.
3. no-subscription account unread count: API الحالي لا يوفر مصدرًا مستقلًا؛ الجرس unknown إلى أن يتوفر عقد count مناسب.
4. `/orders/{dayId}` navigation: date-scoped calendar API لا يوفّر وحده dayId lookup؛ حدد القيد ولا تدّعِ فتح الطلب المحدد إذا فتحت تقويمًا عامًا.
5. preferences backend غير موثق: خارج الربط الحالي.
6. catalog allergens ناقص: لا تصححه في Flutter.
7. push payload inbox id غير موثق: لا تحاول mark-read باستخدام subjectId.
8. Figma غير مرفق في هذه المهمة: أعد استخدام التصميم الحالي؛ لأي تصميم جديد يلزم الرجوع للـnode حسب قواعد المشروع.

هذه حدود محددة وليست سببًا لإيقاف جميع المراحل الأخرى؛ نفّذ الأجزاء المستقلة واذكر كل قيد لم يُحل.

## 8. تعريف الاكتمال وتقرير جيميناي

- [ ] مطاعم اليوم page1 ثم append متسلسل، dedupe، reset عند التاريخ/البحث، responses القديمة مهملة، eligibility كما في السيرفر.
- [ ] الـlegacy calls لا تفرض page/pageSize.
- [ ] inbox حقيقي، pagination، اللغتين، unread حسب timestamp، قراءة واحد/الكل بعد204 فقط.
- [ ] الجرس account-scoped، count من calendar، decrement مرة واحدة، reset بعد read-all، لا stale response ولا previous-account leak.
- [ ] shimmer للمحتوى وأخطاء lib/core/errors، لا fallback لبيانات تجريبية عند API failure.
- [ ] deep links للصيغتين تمر عبر resolver واحد، nullable subscription آمن، route arguments تصل للوجهة، القيود غير المنفذة مصرح بها.
- [ ] Push/token الحاليان لم يُستبدلا؛ resume يحدث البيانات دون إعادة اختيار اليوم أو مسح المسودة.
- [ ] rating null محفوظ؛ «لا توجد تقييمات»؛ الحساسية لا تُستنتج؛ نسبة السعرات لا تسمى هدفًا شخصيًا.
- [ ] localization/generated files سليمة، relevant tests/analyzer موثقون بنتائج فعلية.

التقرير النهائي يحتوي: الملفات المعدّلة ولماذا، الأوامر ونتائجها، mocked مقابل live checks، حالات الاختبار البصري، وكل blocker من القسم7. لا تكتب «الكالندر والإشعارات جاهزين100%» إذا contract غير منشور أو تفاصيل الطلب المحدد/count بلا اشتراك/الحذف ما زالت غير مدعومة.

## 9. رسالة جاهزة لإرسالها لجيميناي

```text
نفّذ الخطة الموجودة في:
docs/superpowers/plans/2026-10-05-calendar-notifications-gemini.md

اقرأ الخطة كاملة، ثم AGENTS.md وrules/ui_rules.md وrules/rules_backend.md
وlib/core/errors قبل أي تغيير. نفّذ المراحل بالترتيب مع اختبارات السلوك.
حافظ على architecture والواجهة الحالية، واستخدم ShimmerWidget الموجود للتحميل.
أكمل Calendar restaurants pagination وNotifications inbox/read/read-all/badge
وتوحيد deep links وربط resume مع خدمة Push الحالية.
لا تغيّر canEdit/72h، ولا تخترع DELETE/count/preferences/dayId lookup endpoints.
اترك التعديلات غير المتعلقة بالمهمة كما هي. لا تعمل deploy/push.
في النهاية قدم تقرير تحقق فعلي والقيود المتبقية؛ لا تعتبر mock tests نشرًا ناجحًا.
```
