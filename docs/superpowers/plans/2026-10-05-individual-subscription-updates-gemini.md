# Individual Subscription Updates — Gemini Implementation Plan

> **For Gemini:** نفّذ الخطة بالترتيب، مهمة واحدة ثم اختبارات ومراجعة قبل المهمة التالية. لو مهارة `executing-plans` متاحة استخدمها. هذه الوثيقة للتنفيذ بواسطة Gemini؛ لا تحتاج تشغيل agents أو إنشاء معمارية جديدة.

**Goal:** ربط Pagination للبرامج والباقات ومطاعم التصنيف والملخص، اختيار تصميم التصنيف، الكوبون من الملخص للدفع، وأسماء مناطق العنوان باللغتين، داخل فلو الاشتراك الفردي الحالي.

**Architecture:** الحفاظ على `UI → Event → ViewModel → UseCase → Repository → DataSource → ApiServices` و`DTO → Mapper → Entity`. إعادة استخدام `ApiResult`, `safeApiCall`, Dio/Retrofit, Injectable/GetIt ونظام `lib/core/errors`. إضافة مسارات paged typed داخل نفس ApiServices مع إبقاء مسارات List القديمة للمستهلكين الحاليين، خصوصًا العائلة.

**Tech Stack:** Flutter/Dart، flutter_bloc، dio، retrofit، json_serializable، injectable، get_it، flutter_test. لا تضف dependencies.

**Spec:** `docs/superpowers/specs/2026-10-05-individual-subscription-backend-contract.md` — نسخة مستقلة من آخر ملف أرسله المستخدم. اقرأه كاملًا قبل التنفيذ؛ لا تعتمد على سجل المحادثة.

## 1. تعليمات حاكمة ونطاق العمل

- اقرأ `AGENTS.md`, `rules/rules_backend.md`, `rules/ui_rules.md`. المسار الفعلي الذي حدده المستخدم للباك هو `rules/rules_backend.md`؛ `rules/backend_rules.md` المذكور في AGENTS غير موجود وقت إعداد الخطة. لا تنشئ نسخة بديلة للقواعد.
- اقرأ `lib/core/errors` و`lib/core/network` و`lib/core/di` قبل كتابة معالجات أو نماذج مشتركة.
- المهمة تنفيذ تكامل داخل الموجود، وليست إعادة تصميم أو تعديل backend.
- DTO response fields nullable، وEntities لا تستورد DTO/Dio/Flutter؛ لا JSON parsing في ViewModel.
- كل عملية UI عبر sealed Event و`doIntent`. State immutable واحدة مع `copyWith` وclear flags عند إزالة nullable values.
- Core للأخطاء العامة، ومعنى أخطاء الكوبون وسلوك الرجوع للملخص داخل الفيتشر. لا navigation داخل Core/Data/Repository.
- لا تعدّل `.g.dart`, `di.config.dart` أو ملفات localization المولدة يدويًا.
- UI يستخدم `context.colorScheme`, `context.localization`, StylesManager وSpacing الموجودين؛ لا نصوص أو ألوان أو مقاسات مخترعة. Widget واحدة لكل ملف؛ Directionality موروثة.
- لا تعمل commit/push أو staging لتعديلات المستخدم تلقائيًا. يمكن تجهيز توصيات commits منفصلة بعد التحقق.
- كان هناك تعديل موجود مسبقًا في `lib/features/calendar/presentation/widgets/calendar_restaurant_nutrition_item.dart`. سجّل الحالة مجددًا ولا تمس هذا التعديل.
- خارج النطاق: السائق/SignalR والإشعارات، تعديل فلو العائلة، إعادة بناء فلو عروض Offers، تغيير الجدولة/الأهلية/الجمعة، إعادة تصميم الشاشات.

## 2. ما ثبت من فحص الكود

1. `ApiServices.getSubscriptionPrograms()` يرجع `List<SubscriptionProgramResponseDto>` بلا query pagination.
2. `getSubscriptionProgramBundles()` يرجع wrapper باسم `SubscriptionProgramBundlesResponseDto` بلا pagination query.
3. `getSubscriptionTierRestaurants()` يقبل `page/pageSize` بالفعل لكن يرجع `List`؛ هذا غير متوافق مع الرد Paged عند إرسال المعاملات. لا تُرسل المعاملات مع نوع الرد القديم.
4. نفس API لمطاعم التصنيف له مستخدمون في `core/subscription_tiers` و`monthly_plans`؛ `family_package_days` يستخدم usecase المشتركة. إبقاء List API القديمة يحمي المستهلكين الحاليين.
5. DTO/entity الخاصة بـtiers في `monthly_plans` ملفات export للمصدر الحقيقي في `core/subscription_tiers`. عدّل المصدر الحقيقي، ولا تنشئ نسخة ثانية.
6. ملفات bundles في `subscription_programs` تعيد استخدام/export نماذج `subscription_packages`؛ راجع imports قبل التعديل.
7. برامج الاشتراك وباقات الاشتراك تستخدم حاليًا loading flag عامة، وبدون حماية كافية من ردود الطلبات القديمة.
8. `SubscriptionSummaryViewModel._getSummary` يمسح summary قبل كل طلب، ولا يمنع رد قديم من الكتابة فوق الجديد.
9. summary request وcheckout request لا يحتويان promoCode. `PaymentArgs` يحمل summary وsummaryRequest؛ هذه نقطة النقل المعتمدة للكوبون.
10. Bottom bar يبني request من `summaryArgs.request` الأصلي. لازم يتحول لاستخدام active request من State حتى لا يفقد الكوبون أو تاريخ البدء بعد التحديث.
11. `SubscriptionSummaryRestaurantsSheet` يستقبل List snapshot ويعرض `restaurants.length`؛ بعد pagination يجب أن يراقب State ويعرض إجمالي المطاعم الحقيقي.
12. `subscription_delivery_address_card.dart` يعتمد على addressLine. إضافة حقول جديدة وحدها لا تجعل أسماء المناطق تظهر باللغة المطلوبة.
13. `ApiException` يحتفظ بـresponse وbackendErrorCode. الـmapper يحفظ `error` ككود لكنه لا يعالج nested coupon messages. `ErrorMessagePresenter` موجود ويجب إعادة استخدامه.
14. لم أجد مسار configuration مطبقًا في الفلو المفحوص. الاعتماد على theme داخل tiers يكفي للفلو الحالي؛ لا تخمن URL configuration.

## 3. عقد الباك المختصر

كل المسارات تحت prefix الموجود في `EndPoints` وDio؛ لا تكتب base URL في feature.

| المورد | المعاملات الجديدة | الرد |
|---|---|---|
| programs | page, pageSize | items + pagination metadata على مستوى الكائن |
| programs/{programId}/bundles | page, pageSize | wrapper الحالي + pagination |
| programs/{programId}/bundles/{bundleId}/tiers/{tier}/restaurants | page, pageSize | items + metadata |
| programs/{programId}/tiers/{tier}/restaurants | page, pageSize | items + metadata؛ لا تضف caller غير مستخدم |
| summary | restaurantsPage, restaurantsPageSize, promoCode | summary الحالي + restaurantsPagination + coupon |
| subscriptions/checkout | promoCode اختياري في body | العقد الحالي؛ يعيد التحقق والتسعير |

بدون معاملات صفحات: الرد القديم. إرسال page أو pageSize يفعّل Paged. اطلب page=1/pageSize=20 في الفلو الجديد. maximum 100، page أقل من 1 يعامل كـ1، query غير رقمية 400، وبعد آخر صفحة 200 مع قائمة فارغة وtotalCount الحقيقي.

`Paged`: items,totalCount,page,pageSize,totalPages,hasNextPage,hasPreviousPage. Metadata المتداخلة في bundles/summary لا تحتوي items.

الأهلية والترتيب والإحصائيات والأسعار من الخادم؛ لا تحسب isMostSelected أو restaurantCount أو السعر من عدد عناصر الصفحة. لا تخلط قائمة مطاعم تصفح التصنيف بقائمة مطاعم summary.

`theme`: `{designId:1,designName:Classic}` أو `{designId:2,designName:Aurora}`؛ null/unsupported → التصميم الحالي. الاختيار للشاشة كلها.

الكوبون: `code,status,offerId,discountAmount,messageAr,messageEn`. الحالات: valid,not_found,inactive,not_started,expired,usage_exhausted,stacking_conflict,ineligible. summary مع كود مرفوض يرجع 200، وليس Failure. `finalPrice` هو المبلغ المرجعي؛ `coupon.discountAmount` لا يُجمع مع `campaignDiscount`.

أخطاء الدفع 400: `checkout.coupon_rejected`, `checkout.coupon_no_longer_valid`, `checkout.coupon_full_discount_unsupported`. الأولى والثانية قد تحملان nested coupon. لا تنشئ subscription/payment session من التطبيق عند هذه الأخطاء، ولا تبدأ WebView.

Address داخل summary/readiness يضيف governorateNameAr/En,areaNameAr/En,blockNameAr/En. النصوص القديمة snapshots، وlabel/addressLine يحتفظان بنص المستخدم. الاسم الجديد null → fallback للحقل القديم لكل جزء على حدة.

## 4. اعتماديات خارجية وحدود صريحة

- تأكد من نشر الباك قبل اختبار live. الوصف «منفذ ويتوفر بعد النشر» ليس دليل نشر.
- pageSize صفر/سالب، وcoupon عند غياب الكود غير محسومين. التطبيق يرسل حجمًا موجبًا فقط؛ parsing يدعم coupon null أو absent دون اختلاق حالات جديدة. اسأل الباك لو مطلوب اختبار غير ذلك.
- Classic/Aurora أرقام معلومة، لكن الملف لا يحتوي تصميم Figma. ابحث عن تصميم معتمد في المشروع/المرفقات؛ لا تسمِّ UI الحالي Aurora دون دليل. يمكن إكمال data plumbing/resolver واختبارات fallback، لكن تنفيذ widget Aurora يتوقف فقط على توفير التصميم.
- موضع وشكل إدخال الكوبون وfooter المزيد يحتاجان UI موجودًا أو Figma معتمدًا. أعد استخدام الموجود أولًا؛ لو لا يوجد دليل، بلّغ بالجزء البصري المحدد واستمر في الطبقات المستقلة.
- لا يوجد URL موثق لـconfiguration هنا؛ اقرأ theme من tiers عند دخول الشاشة/refresh. لو طُلب تغيير التصميم فور فتح التطبيق كله، اطلب عقد configuration ومكان الجلب الحالي أولًا.
- resume coupon failure قد يحدث خارج summary route؛ لا تفترض وجود سياق الاشتراك الكامل. استخرج السياق من entity الموجودة إن متاح، وإلا اعرض رسالة localized واترك المستخدم في billing مع إجراء متاح، وبلّغ تعذر العودة للملخص بدل تخمين request.

## 5. خريطة التغييرات

### ملفات مشتركة

- `lib/core/network/api_services.dart`: إضافة paged methods typed، query summary، إبقاء القديمة.
- `lib/core/errors/subscription_error_codes.dart`: الثلاثة أكواد coupon checkout.
- `lib/core/errors/error_message_presenter.dart` + `lib/core/network/failuer_mapper.dart`: localized messages للكود وحالات الكوبون، بدون navigation.
- `lib/core/l10n/app_ar.arb`, `app_en.arb`: المفاتيح الجديدة إن غير موجودة، ثم gen-l10n.
- المصدر الحقيقي لـtiers: `lib/core/subscription_tiers/data/models/response/subscription_tier_response_dto.dart`, `data/mapper/subscription_tier_mapper.dart`, `domain/entities/subscription_tier_entity.dart`.

### الفيتشرز

لكل مورد paginated عدّل DataSource contract/impl، Repository contract/impl، UseCase، Event/State/ViewModel والـUI المستهلك. التفاصيل في المهام؛ لا تكتفِ بتعديل Retrofit.

- `subscription_programs`: data models/mappers/data_source/repo، domain repo/usecase، presentation manager وselection view/screen.
- `subscription_packages`: bundle response/entity/mapper وكل سلسلة packages، controller وlist section.
- `monthly_plans`: سلسلة get tier restaurants، plan manager، widgets المطاعم والتصنيف المعتمدة.
- `subscription_checkout`: summary/readiness DTO/entity/mapper، request، summary سلسلة الاستدعاء، manager، address card، restaurants sheet، bottom bar.
- `payment`: request DTO/entity/mapper، viewmodel، state/event لو مطلوب typed return effect، screen/error banner/order summary.
- `profile`: التعامل مع coupon_no_longer_valid في resume عبر النمط الحالي فقط.

## 6. Task 1 — تثبيت baseline والعقد

- [ ] اقرأ spec والقواعد وimports في الملفات المذكورة. نفذ `git status --short` وسجّل تغييرات المستخدم.
- [ ] ابحث عن reusable pagination/theme/coupon/localized text؛ لا تنشئ نسخة من مفهوم موجود.
- [ ] شغّل الاختبارات الحالية المعنية قبل التعديل وسجّل failures السابقة منفصلة.
- [ ] راجع جميع callers لـAPI القديمة والـusecases المشتركة باستعمال `rg -n 'getSubscriptionPrograms|getSubscriptionProgramBundles|getSubscriptionTierRestaurants' lib test`.
- [ ] جهز JSON fixtures في tests: Paged صفحة أولى/ثانية/فارغة، bundles wrapper، summary+coupon، address bilingually، legacy responses. بيانات صناعية فقط، بلا tokens أو حسابات حقيقية.

**Deliverable:** baseline مكتوب وقائمة consumers صحيحة؛ لا تفسير محلي لتسعير أو شكل API مجهول.

## 7. Task 2 — نماذج pagination وواجهات typed

**Create بعد تأكيد عدم وجود equivalent:**

- `lib/core/network/models/response/pagination_response_dto.dart`: nullable metadata JSON.
- `lib/core/entities/pagination_entity.dart`: immutable metadata domain دون networking imports.
- `lib/core/entities/paged_entity.dart`: `PagedEntity<T>` يحتوي items وmetadata؛ ليس بديل ApiResult.
- `lib/core/network/mapper/pagination_mapper.dart`: conversion مع validation للحقول المهمة.
- `lib/features/subscription_programs/data/models/response/subscription_programs_page_response_dto.dart`: items من DTO البرنامج وmetadata.
- `lib/features/monthly_plans/data/models/response/subscription_tier_restaurants_page_response_dto.dart`: items من DTO المطاعم الحالي وmetadata.

استخدم concrete response DTOs لتسهيل Retrofit generation، واشتراك metadata عبر نموذج واحد. لا تنشئ generic HTTP client أو state wrapper عام.

```dart
class PagedEntity<T> {
  const PagedEntity({required this.items, required this.pagination});
  final List<T> items;
  final PaginationEntity pagination;
}
```

**Modify API:** أضف `getSubscriptionProgramsPage` و`getSubscriptionTierRestaurantsPage` بجوار القديمة بنفس EndPoints. page/pageSize required بالمسارات paged. أضف named nullable query args للباقات والملخص. لا تستخدم `Future<dynamic>` لتغطية List وMap.

```dart
@GET(EndPoints.subscriptionPrograms)
Future<SubscriptionProgramsPageResponseDto> getSubscriptionProgramsPage(
  @Query('page') int page,
  @Query('pageSize') int pageSize,
);
```

Metadata المفقودة في request paged لا تُحوّل تلقائيًا إلى «انتهت القائمة». أوقف append وارجع parsing/contract Failure عبر safeApiCall؛ لا تختلق hasNextPage من items.length. legacy bundles بلا pagination تبقى مقبولة فقط للمسار القديم.

- [ ] اكتب `test/subscription_pagination_contract_test.dart` باستخدام HttpClientAdapter مثل الاختبار الحالي ليثبت query وشكل الرد وأن legacy method لا يرسل pagination.
- [ ] اختبر numbers int/null، wrapper bundles، missing metadata، last page، وأن parsed metadata لا تختلط مع totalCount المحلي.
- [ ] ولّد الملفات ثم شغّل الاختبار؛ راجع generated diff ولا تعدّله يدويًا.

**Interfaces produced:** `PaginationEntity`, `PagedEntity<T>` وpaged API methods. `PaginationEntity` حقوله page,pageSize,totalCount,totalPages,hasNextPage,hasPreviousPage؛ metadata محفوظة من الخادم بعد validation.

## 8. Task 3 — Pagination البرامج والباقات

**Files:** السلسلة الكاملة في `subscription_programs` و`subscription_packages`، خصوصًا `subscription_programs_view_model.dart`, `subscription_packages_view_model.dart`, states/events، و`subscription_package_flow_controller.dart`.

**Interfaces:** أضف `GetSubscriptionProgramsPageUseCase.call({required int page,required int pageSize}) → Future<ApiResult<PagedEntity<SubscriptionProgramEntity>>>`. الباقات تظل `SubscriptionProgramBundlesEntity` مع `PaginationEntity? pagination` وflags profile الحالية، وusecase الباقات الحالي يضيف named page/pageSize optional. المستهلك الفردي الجديد يرسل الاثنين دائمًا، caller قديم يظل بلا معاملات.

- [ ] اكتب `test/subscription_programs_pagination_test.dart`, `test/subscription_packages_pagination_test.dart` قبل التنفيذ.
- [ ] Events للتحميل الأول والتحميل الإضافي والretry؛ أبقِ initial failure منفصلة عن loadMoreFailure لكل قائمة.
- [ ] State لكل قائمة: items, metadata nullable، isInitialLoading,isRefreshing,isLoadingMore، Failure وloadMoreFailure. لا تغيّر أسماء موجودة دون ضرورة؛ يمكن إضافة flags وصفية مع تحديث listeners الحالية.
- [ ] initial/refresh يطلب صفحة 1؛ append يطلب metadata.page+1. retry append يعيد نفس الصفحة الفاشلة. لا تحديث currentPage إلا بعد نجاح الطلب.
- [ ] امنع double tap أثناء طلب نفس القائمة. refresh جديد يبطل append السابق، حتى لو الطلب لم يُلغ فعليًا.
- [ ] generation مستقلة للبرامج والباقات؛ program change يبطل رد bundles القديم ويمسح قائمة/اختيار السياق القديم.
- [ ] dedupe بالـprogramId/bundleId ويحافظ على ترتيب الباك؛ null/empty IDs لا تظهر كعناصر قابلة للاختيار. لا تعِد ترتيب العناصر بعد append.
- [ ] الاختيار identity بالمعرف. controller الحالي يستعمل index؛ صحح sync الاختيار عند refresh دون أن ينتقل اختيار المستخدم لباقة أخرى أو يتكسر الرجوع من prerequisites.
- [ ] flags profile وbadge/isMostSelected وشعارات المطاعم من الرد كما هي، لا حساب على صفحة واحدة.
- [ ] UI يحتفظ بالمحتوى وقت refresh/append failure؛ footer loader/InlineApiErrorWidget للappend، ApiErrorWidget فقط لو فشل تحميل مطلوب ولا محتوى، EmptyStateWidget عند نجاح أول صفحة فارغة.

**اختبارات إلزامية:** page 1+2 بلا تكرار؛ retry page2؛ refresh لا يضيف للقديم؛ تغيير البرنامج قبل اكتمال الرد؛ selected bundle identity؛ profile prerequisites بعد refresh؛ عدم تعديل قائمة أخرى عند append.

## 9. Task 4 — Pagination مطاعم التصنيف

**Files:** `monthly_plans/data/data_source/subscription_plan_remote_data_source.dart` وimpl، repo contract/impl، `domain/usecase/get_subscription_tier_restaurants_usecase.dart`، plan state/event/viewmodel، widgets المطاعم الحالية. المصدر المشترك في `core/subscription_tiers` يبقى متوافقًا مع العائلة.

**Interface:** أضف `GetSubscriptionTierRestaurantsPageUseCase.call({required String programId,required String bundleId,required String tier,required int page,required int pageSize}) → Future<ApiResult<PagedEntity<SubscriptionTierRestaurantBrowseEntity>>>` داخل monthly_plans وسلسلتها. القديمة List تبقى للعائلة/callers القدماء بلا query.

- [ ] اختبارات في `test/subscription_tier_restaurants_pagination_test.dart` قبل التنفيذ.
- [ ] browse state مستقلة: page metadata,initial/append loading,initial/append Failure. event LoadMore يحمل/يستعمل browsing context الصحيح.
- [ ] context key يشمل program,bundle,tier,address generation. إغلاق sheet يبطل pending requests. فتحها ثانية يبدأ page1 للسياق الصحيح.
- [ ] لا تخلط selectedTierIndex مع browsedTierIndex؛ browsing لا يغيّر اختيار الدفع.
- [ ] طبّق dedupe restaurantId وحماية stale responses وretry للصفحة الفاشلة.
- [ ] اختبر core legacy endpoint القديم مازال يرجع List ولا يرسل query؛ شغّل اختبارات family المشتركة.

## 10. Task 5 — Theme من المصدر المشترك

**Create:** `lib/core/subscription_tiers/data/models/response/subscription_tier_theme_response_dto.dart`, `lib/core/subscription_tiers/domain/entities/subscription_tier_theme_entity.dart` وmapping في mapper الموجودة. presentation resolver داخل monthly_plans فقط، وليس Domain widget factory.

```dart
enum SubscriptionTierDesign { current, classic, aurora }

SubscriptionTierDesign resolveSubscriptionTierDesign(
  int? designId, {
  required bool supportsClassic,
  required bool supportsAurora,
}) => switch (designId) {
  1 when supportsClassic => SubscriptionTierDesign.classic,
  2 when supportsAurora => SubscriptionTierDesign.aurora,
  _ => SubscriptionTierDesign.current,
};
```

- [ ] أضف theme nullable في DTO/entity الحقيقيتين وmapper؛ أبق export files دون نسخ.
- [ ] State اختيار واحد للشاشة. حين تختلف theme عبر tiers خلاف العقد استخدم current بأمان وسجّل contract mismatch بدون بيانات حساسة، ولا تعيّن تصميمًا مستقلًا لكل tier.
- [ ] اجلب tiers عند دخول الشاشة/refresh بالنمط الحالي. لا API داخل build ولا polling جديد ولا configuration URL مخمن.
- [ ] widget resolver يركب UI المعتمد لكل تصميم؛ designName لا يقرر layout.
- [ ] إن غاب Figma لتصميم، اتركه unsupported→current وبلّغ أن التنفيذ البصري لم يكتمل. لا تدّعِ تطبيق Aurora مع fallback.
- [ ] `test/subscription_tier_theme_test.dart`: null,1,2,999، supported/unsupported، refetch changes، shared family fields القديمة لم تتغير.

## 11. Task 6 — العنوان بلغتين في summary/readiness

**Modify:** `subscription_summary_response_dto.dart`, `subscription_readiness_response_dto.dart`, `subscription_summary_entity.dart`, `subscription_readiness_entity.dart`, `subscription_summary_mapper.dart`, `subscription_delivery_address_card.dart`.

- [ ] أضف الستة حقول nullable إلى Address DTOs وentities. map كل حقل باسم الباك حرفيًا.
- [ ] helper يختار اسم كل جزء بلغة الواجهة ثم legacy عند غياب/فراغ الجديد. اختيار اللغة للبيانات مسموح؛ لا تستعمل لغة البيانات لتحديد layout direction.
- [ ] افصل names line المترجمة عن addressLine المستخدم؛ لا تجعل `formattedAddress` الحالي يفضل addressLine ثم يلغي ظهور الأسماء المترجمة.
- [ ] label وaddressLine يظهران كما وردا؛ لا ترجمة آلية ولا replace عربي/إنجليزي داخل نص المستخدم ولا حذف street/building details.
- [ ] لا تكرر سطرًا مطابقًا للنص الظاهر؛ احفظ جميع تفاصيل العنوان الحالية ومكانها المعتمد بصريًا.
- [ ] `test/subscription_address_localization_test.dart`: Arabic/English، missing English fallback legacy لكل جزء، null region catalog، label/addressLine كما هما، summary/readiness mapping، تغيير لغة التطبيق يعيد العرض دون إعادة API ضرورية.

## 12. Task 7 — Coupon وPagination مطاعم summary

**Create:** `features/subscription_checkout/data/models/response/subscription_coupon_response_dto.dart`, `domain/entities/subscription_coupon_entity.dart`, `data/mapper/subscription_coupon_mapper.dart`. status غير معروفة محفوظة/unknown ولا تصبح valid افتراضيًا.

**Modify:** summary request/entity/DTO/mapper وسلسلة الاستدعاء وsummary manager/events/state والـrestaurants sheet وbottom bar.

**Request fields:** promoCode nullable، restaurantsPage nullable، restaurantsPageSize nullable. `copyWith` يجب أن يدعم clearPromoCode فعليًا، وليس `promoCode ?? this.promoCode` فقط.

**State authority:** activeRequest هو سياق آخر summary معتمدة، مع requested context/generation لحماية التحديث. couponDraft منفصلة عن الكود المرسل؛ آخر coupon result مرتبطة بالسياق. restaurant metadata والفشل/التحميل الإضافي مستقلان عن إعادة التسعير.

**Events:** `ApplySubscriptionPromoCodeEvent(String code)`, `RemoveSubscriptionPromoCodeEvent`, `LoadMoreSubscriptionSummaryRestaurantsEvent`, `RetrySubscriptionSummaryRestaurantsEvent` بجوار start-date/load الحالية. UI→doIntent فقط.

- [ ] اكتب `test/subscription_summary_coupon_test.dart` و`test/subscription_summary_restaurants_pagination_test.dart` قبل التنفيذ.
- [ ] عند apply أرسل النص trimmed للباك ثم اعرض code الذي رجع منه؛ لا تخمن خصم/أهلية ولا تفترض أنه case-sensitive. blank→remove.
- [ ] apply/remove أو تغيير startDate/duration/Friday/program/bundle/tier/address يبطل summary السابقة للتقدم للدفع، ويطلب summary page1 بنفس الكود إن مازال موجودًا. لا تفقد الكود عند copyWith.
- [ ] أثناء إعادة التسعير احتفظ بالمحتوى السابق بصريًا حيث مناسب لكن عطّل التالي إلى أن تنجح summary للسياق الجديد. عند failure لا تدفع بسعر/context قديمين؛ اعرض retry في القسم.
- [ ] 200 coupon رفض: اعرض الرسالة والحقل القابل للتعديل/الإزالة مع السعر الذي أرسله الباك. لا تستخدم ApiErrorWidget ولا Failure صناعية، ولا تمنع checkout لمجرد rejected status إذا canCheckout يسمح؛ قبل الدفع يلزم إزالة/تصحيح الكود ثم summary جديدة حتى لا يُرسل كود مرفوض إلى checkout.
- [ ] loadMore summary يرسل restaurantsPage وليس page، وبنفس pricing context وpromoCode. كل request له captured context + generation؛ apply جديد يبطل append القديم.
- [ ] append يحدّث restaurants وrestaurantsPagination فقط عند تطابق scalar pricing/context مع summary المعتمدة. إن رجع finalPrice/coupon/canCheckout مختلفًا، لا تدمج كروت مع سعر قديم؛ اعتبرها تغير quote واطلب page1 جديدة وعطّل الدفع حتى تستقر.
- [ ] عرض إجمالي المطاعم من restaurantCount؛ sheet العدد لا يستعمل items.length. sheet يستعمل ViewModel الحالية بـBlocProvider.value عبر modal boundary، لا ينشئ نسخة أخرى ولا يغلق الـViewModel التي لا يملكها.
- [ ] bottom bar يبني PaymentArgs من summary وactiveRequest للسياق نفسه. لا يعيد البناء من summaryArgs الأصلية بعد تعديل الكوبون.
- [ ] السعر المعروض `finalPrice`؛ الخصم يصف الحقول الحالية فقط، coupon.discountAmount للتوضيح لا إضافته للحساب.

**State race pattern داخل ViewModel، وليس API helper عام:**

```dart
final generation = ++_summaryGeneration;
final result = await _getSubscriptionSummaryUseCase(capturedRequest);
if (isClosed || generation != _summaryGeneration) return;
// emit النتيجة لهذا الطلب فقط، وactiveRequest المطابقة لها عند النجاح.
```

generation مستقلة للappend مع parent summary generation؛ loadMore busy flag تمنع parallel pages. التخلص من stale success وstale failure معًا إلزامي.

**اختبارات:** apply/remove/rejected/unknown statuses؛ refresh يفشل ويبقى المحتوى والدفع disabled؛ old response لا يكتب؛ startDate تحتفظ بالكود؛ retry append page نفسها؛ restaurantCount لا يتغير مع طول الصفحة؛ رفض code سابق لا يعود بعد remove؛ missing coupon لا crash.

## 13. Task 8 — نظام الأخطاء الموحد للكوبون

**Files:** `lib/core/errors/subscription_error_codes.dart`, `error_message_presenter.dart`, `lib/core/network/failuer_mapper.dart`، ARBs، feature mapper/state المذكور في مهمة 7.

```dart
static const couponRejected = 'checkout.coupon_rejected';
static const couponNoLongerValid = 'checkout.coupon_no_longer_valid';
static const couponFullDiscountUnsupported =
    'checkout.coupon_full_discount_unsupported';
```

- [ ] اختبر `ApiExceptionMapper.fromResponse` يحفظ backendErrorCode وresponse كما هما عند nested coupon، ويصنف 400 badRequest دون crash.
- [ ] لا تكتب nested JSON parsing داخل payment/profile ViewModel. mapper في Data يستقبل `Failure.exception.response` ويحول coupon إلى entity عند أكواد coupon فقط؛ الربط في Repository ينتج Failure تحفظ typed details عبر subtype feature-specific إذا احتاجت State ذلك، وتبقى متوافقة مع ApiErrorResult/Failure.
- [ ] لا تغيّر ApiResult ولا تتخلص من exception أو status أو payload الأصلية. typed failure لا تعيد بناء DioException أو تضيف UI imports.
- [ ] رسالة الكوبون حسب لغة الواجهة من entity أو localization status map؛ sanitize backend messages باستخدام ErrorMessagePresenter. status مجهولة/message غير صالحة→localized generic coupon message.
- [ ] مثال localization المعتمدة: coupon expired «انتهت صلاحية كود الخصم» / “This coupon code has expired”، full-discount unsupported «الدفع بمبلغ صفري غير مدعوم حاليًا. أزل الكود أو استخدم كودًا آخر.» / “Zero-amount checkout is currently unsupported. Remove this code or use another code.” أضف مفاتيح لكل status في spec ورسائل apply/remove/loading إن غير موجودة.
- [ ] عدم عرض `checkout.coupon_rejected` حرفيًا للمستخدم؛ لا اختيار messageEn دائمًا للواجهة العربية.
- [ ] `ApiErrorWidget.fromTypedFailure` عند failure+no usable data، `InlineApiErrorWidget` عند append/section failure، `EmptyStateWidget` للsuccess-empty. لا تخلق Error screen جديدة.
- [ ] لا تعالج أخطاء network بنصوص في كل شاشة؛ استعمل ErrorMessagePresenter والنمط الحالي للـfeedback. لا تغيّر Core widgets لمجرد وجود مخالفات styling قديمة خارج نطاق الربط.

**Tests:** `test/core/errors/subscription_coupon_errors_test.dart` ويشمل locale ar/en، HTML/technical message، null coupon، unknown status، full_discount بلا coupon، existing error mapping regression. شغّل `test/core/errors/api_exception_mapper_test.dart` و`family_error_message_test.dart`.

## 14. Task 9 — الدفع والرجوع للملخص والاستئناف

**Files:** `payment_checkout_request_dto.dart`, `payment_entity.dart`, `payment_mapper.dart`, `payment_view_model.dart`, `payment_state.dart`, `payment_event.dart`, `payment_screen.dart`, `payment_checkout_error_banner.dart`, `payment_order_summary_section.dart`؛ وprofile resume handler الحالية عند الحاجة.

- [ ] أضف String? promoCode في checkout Entity/DTO وrequest mapper. `@JsonKey(includeIfNull:false)` على الاختياري؛ بلا كود لا يُرسل، ومع valid code تُرسل القيمة الموحدة المرتبطة بآخر summary ناجحة.
- [ ] لا تضف amount من التطبيق في checkout body؛ تظل الحسابات للخادم.
- [ ] PaymentViewModel يجلب methods باستخدام latest summary.finalPrice، وليس basePrice أو إجمالي محلي. يربط methods response بإصدار amount/context ويمنع stale methods.
- [ ] إعادة تسعير summary تبطل طرق الدفع القديمة. لأن الكوبون يُعدل في summary، أغلق/ارجع payment للسياق السابق؛ عند الدخول مجددًا LoadPaymentEvent تجلب methods للمبلغ الجديد. لو UI تسمح تغيير الكوبون داخل payment، اربط refresh methods صراحة ولا تُنشئ مصدر summary مستقل.
- [ ] لا تحتفظ selectedMethod قديمة إذا unavailable في الرد الجديد. لا تعدل سياسة wallet الحالية ضمن المهمة.
- [ ] عند couponRejected/fullDiscount: لا WebView ولا fulfillment polling. State تحمل recovery effect typed، والـscreen تعود للsummary route الحالية بـNavigator.pop(result)؛ لا تكدس نسخة جديدة منها. message/coupon payload محفوظان.
- [ ] summary ينتظر نتيجة فتح payment، يعرض localized rejection مرة واحدة، يعيد summary الحالية، ويسمح إزالة/تعديل الكود. listener effect تُستهلك مرة ولا navigation أثناء build. mounted/isClosed checks.
- [ ] fullDiscount unsupported: امنع بدء الدفع برسالة واضحة. لا تعامل finalPrice=0 تلقائيًا كدفع ناجح أو تعيد حسابه؛ أظهر رفض الباك المرجعي.
- [ ] resume: لا تضف promoCode للrequest؛ الباك يعيد التحقق من المحجوز. عند coupon_no_longer_valid أظهر المعنى المترجم وارجع للsummary فقط حين يتوفر سياق صحيح؛ لا تدخل payment webview.
- [ ] الحفاظ على success callbacks، payment status verification، calendar polling، existing subscription conflict، correlationId الحالية. لا «تصلح» idempotency أو resume backend تخمينيًا في هذه المهمة.

**Tests:** `test/subscription_coupon_checkout_test.dart`: request JSON مع/بدون promoCode؛ methods amount latest finalPrice؛ stale methods ignored؛ coupon failure لا ينتج navigation لـwebview؛ الرجوع وremove/retry؛ عدم تكرار snackbar/effect؛ existing conflict/sandbox/payment success مازال يعمل. `test/subscription_coupon_resume_test.dart`: payload بدون promoCode و400 localized recovery مع/بدون سياق.

## 15. Task 10 — الواجهة، الترجمة، التحقق النهائي

- [ ] اربط مدخل الكوبون وأزرار apply/remove/status بالState حسب التصميم المعتمد؛ controllers/focus nodes تُنشأ خارج build وتُdispose.
- [ ] اربط نهاية القوائم بـhasNextPage فقط؛ footer المزيد لا يظهر بعد النهاية، وفشل page2 لا يمسح page1.
- [ ] selectors/buildWhen تراقب ما يحتاجه كل section. إدخال couponDraft لا يعيد بناء الشاشة كلها؛ append restaurants لا يعيد hero/price بلا حاجة.
- [ ] RTL/LTR من inherited Directionality؛ languageCode لا يقرر side/child order. اختبر العربية والإنجليزية وتكبير النص/keyboard أثناء إدخال الكوبون.
- [ ] لا تخلق صورة/لون/Spacing لتصميم Aurora. صرّح بأي اعتماد Figma ناقص بدقة في تقرير التنفيذ.
- [ ] استخدم قائمة ملفات scoped للتنسيق. لا `dart format lib` حتى لا تتغير ملفات المستخدم أو ملفات غير مرتبطة.

```powershell
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test test/core/errors
flutter test test/subscription_pagination_contract_test.dart test/subscription_programs_pagination_test.dart test/subscription_packages_pagination_test.dart test/subscription_tier_restaurants_pagination_test.dart test/subscription_tier_theme_test.dart test/subscription_address_localization_test.dart test/subscription_summary_coupon_test.dart test/subscription_summary_restaurants_pagination_test.dart test/subscription_coupon_checkout_test.dart test/subscription_coupon_resume_test.dart
flutter test test/subscription_programs_feature_test.dart test/subscription_program_bundles_profile_status_test.dart test/subscription_programs_prerequisites_test.dart test/subscription_package_flow_controller_test.dart test/subscription_plan_toggle_friday_test.dart test/subscription_tier_restaurants_endpoint_test.dart test/subscription_summary_screen_test.dart test/payment_sandbox_method_test.dart test/payment_success_screen_test.dart test/family_checkout_contract_test.dart test/family_tier_member_query_test.dart
git diff --check
git status --short
```

شغّل targeted test لكل مهمة بعد كتابة الاختبار (يفشل للسلوك المفقود) وبعد التنفيذ (ينجح). الاختبارات تستعمل fakes/Completer/adapter الموجود دون package جديدة، ولا تجعل كل Unit Test تعتمد على السيرفر. إن SDK غير متاح سجّل عدم القدرة على التشغيل بدل ادعاء النجاح.

## 16. وصف اختبارات ترتيب الردود

للاختبارات السلوكية استخدم fake repository/usecase مع Completer لكل request، ولا تعتمد على sleep:

```dart
final first = Completer<ApiResult<SubscriptionSummaryEntity>>();
final second = Completer<ApiResult<SubscriptionSummaryEntity>>();
// fake repository يعيد first.future لطلب الكود A، وsecond.future للكود B.
// أرسل Apply A ثم Apply B، وأكمل second أولًا بsummary B ثم first بsummary A.
// بعد اكتمال microtasks: summary/coupon/activeRequest يجب أن تظل B.
```

كرّر الاختبار مع first يفشل، ومع remove بدل B، ومع إغلاق الـViewModel. للappend: طلب page2 القديم يصل بعد refresh page1 الجديدة، فلا يُضاف إلى القائمة الجديدة. راجع `test/subscription_programs_feature_test.dart` و`test/subscription_plan_toggle_friday_test.dart` لنمط fake المناسب، وأنشئ fixtures typed كاملة بدل نسخ constructors قديمة ناقصة.

## 17. Live QA بعد نشر الباك

نفّذ على بيئة اختبار وحساب مخول فقط، لا تستخدم tokens في تقرير أو fixtures:

| التجربة | المتوقع |
|---|---|
| programs بلا query | legacy List، التطبيق القديم متوافق |
| programs page1/page2 | Paged، IDs وترتيب دون تكرار مع بيانات ثابتة |
| bundles pageSize=2 | metadata، profile flags وbadge كما الباك |
| tier restaurants page2 | السياق الصحيح، إجمالي ثابت |
| summary restaurantsPage2 | قائمة المطاعم فقط paged؛ السعر والإجماليات لا تُحسب محليًا |
| theme 1 ثم 2/refetch | widget المعتمدة إن مدعومة؛ unsupported→current |
| address Arabic/English | أسماء كتالوج صحيحة، user text محفوظ |
| coupon valid | summary discount ثم methods latest amount ثم checkout يحمل الكود |
| coupon expired/not_found | summary 200 ورسالة واضحة وسعر الخادم |
| انتهاء الكود بين summary/checkout | 400، رجوع للملخص، لا WebView |
| remove coupon | summary بدون الكود ثم methods بالسعر الجديد |
| zero finalPrice | رفض واضح، لا نجاح وهمي |
| resume كود لم يعد صالحًا | recovery localized، لا إرسال كود جديد |
| آخر استخدام للكوبون بطلبين متزامنين | الباك يمنع الاستهلاك الزائد؛ التطبيق يعرض رد كل طلب بوضوح |
| فشل الدفع ثم إعادة المحاولة | تأكيد release behavior من الباك؛ لا استهلاك/حجز محلي |

تجربة الطلبين المتزامنين/الاستهلاك مسؤولية تحقق backend، وليست منطقًا يمكن إثباته باختبار Flutter unit وحده. لا تسجّلها Passed بدون تجربة مصرح بها أو دليل الباك.

## 18. تعريف الإنجاز وتسليم Gemini

- [ ] كل مورد paginated مكتمل من Retrofit حتى UI، مع retry/race/dedupe/end states.
- [ ] API List القديمة والمستهلكون المشتركين والعائلة متوافقون.
- [ ] coupon تحمل إلى checkout من active request نفسها، وإزالة الكود فعالة.
- [ ] لا جمع مزدوج للخصم ولا حساب finalPrice محليًا ولا checkout بquote قديمة.
- [ ] أخطاء network تستخدم lib/core/errors؛ أخطاء business 200 لا تتحول لأخطاء شبكة.
- [ ] أسماء address مترجمة مع fallback؛ لا وعد بترجمة نص المستخدم.
- [ ] Theme plumbing وfallback مكتملان؛ التصميم البصري لا يُعتبر مكتملًا دون Figma وتنفيذ/تحقق.
- [ ] localization/codegen/analyze/tests نتائجها مسجلة، وfailures السابقة مفصولة عن الجديدة.
- [ ] ملفات المستخدم وغير المرتبطة لم تتغير؛ generated diff فقط من أدوات التوليد.

تقرير Gemini الأخير يحتوي: الملفات التي تغيرت ولماذا، ما نجح من الاختبارات بالأوامر، ما لم يُختبر live، تصميمات مدعومة فعليًا، الاعتماديات الخارجية المتبقية، وأي مخالفة عقد ظهرت. لا تستخدم «تم بالكامل» إذا ظلت Aurora أو نشر الباك أو recovery context غير محسومة.

## 19. Prompt جاهز لإرساله لـGemini

```text
نفّذ docs/superpowers/plans/2026-10-05-individual-subscription-updates-gemini.md بالترتيب.
اقرأ أيضًا docs/superpowers/specs/2026-10-05-individual-subscription-backend-contract.md.
قواعد الباك المطلوبة في rules/rules_backend.md، وقواعد الواجهة في rules/ui_rules.md.
أعد استخدام lib/core/errors بالكامل، ولا تنشئ نظام أخطاء أو شبكة أو State management جديدًا.
حافظ على الفلو الحالي والعائلة؛ نفّذ DTO→Mapper→Entity وApiServices→DataSource→Repository→UseCase→ViewModel→Event/State→UI لكل تعديل.
اختبر pagination والتزامن والكوبون والدفع والترجمة، ولا تعدّل generated files يدويًا.
لا تخترع Figma لتصميم Aurora أو لمكونات جديدة. إذا غاب التصميم بلّغ الجزء البصري المحدد وأكمل المهام المستقلة.
لا تمس تعديلات المستخدم الموجودة، ولا تعمل commit/push تلقائيًا.
سلّم تقريرًا بنتائج الاختبارات والملفات وأي أجزاء معلقة، ولا تعتبر توثيق الباك دليل نشر فعلي.
```
