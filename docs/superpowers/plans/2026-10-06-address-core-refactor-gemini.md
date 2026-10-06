# Address Core Refactor — خطة تنفيذ لجيميني

> **For agentic workers:** Execute this plan task-by-task using the executing-plans workflow. Track the checkboxes and validate each stage before continuing. Do not delegate unless the user authorizes delegation.

**Goal:** فصل الوظائف المشتركة للعناوين في `lib/core/address`، وإبقاء عمليات العميل والعائلة مستقلة، وتحسين التحكم في الطلبات والـrebuilds بدون تغيير التصميم.

**Architecture:** الحفاظ على Clean Architecture وCubit/ViewModel وEvent وimmutable State الموجودة بالمشروع. محرر مشترك لا يعرف Features، وتنفيذ مستقل لعمليات العميل والعائلة عبر عقد domain محايد. خدمات الموقع العامة تستخدم الكتالوج والكاش المشترك، بينما بيانات صاحب العنوان ونتائج التغطية تظل معزولة.

**Tech Stack:** Flutter/Dart، flutter_bloc، ApiResult/safeApiCall، Dio/Retrofit، GetIt/Injectable، google_maps_flutter، flutter_test. استخدم الحزم الموجودة فقط.

**Spec:** هذا الملف يوثق الاتفاق مع المستخدم: المشترك داخل `core/address`، والفيتشران يحتفظان باسميهما، وتحسين الأداء وحماية الأخطاء دون أي تغيير تصميم.

## 1. تعليمات إلزامية قبل التنفيذ

- اقرأ `AGENTS.md` وأي تعليمات متداخلة في المجلدات التي ستعدلها.
- اقرأ `rules/ui_rules.md` و`rules/rules_backend.md` كاملين. وقت إعداد الخطة ملف الباك إند الفعلي اسمه `rules_backend.md` بينما AGENTS يشير إلى `backend_rules.md`. لو ظهر الملف المشار إليه لاحقًا اقرأه أيضًا، ولا تعدل أسماء ملفات القواعد ضمن الريفاكتور.
- **ممنوع تغيير التصميم نهائيًا:** الألوان، الخطوط، الأحجام، المسافات، ترتيب العناصر، الـsheets، الـskeletons، الأيقونات، animations، النصوص، اتجاه الواجهة، أماكن الأزرار والخريطة يجب أن تبقى كما هي.
- **لو تغيير بصري ضروري، توقف عن الجزء المتأثر واسأل المستخدم أولًا.** اشرح السبب، والشاشة المتأثرة، والتغيير المقترح، وقدّم مقارنة قبل/بعد قابلة للمراجعة. لا تنفذ التغيير قبل موافقة صريحة، ويمكن متابعة الأجزاء المستقلة.
- إعادة تركيب widgets لتقليل rebuilds مسموحة فقط مع نفس النتيجة البصرية وسلوك التركيز والتمرير والـmodal وحالة الخريطة.
- لا تضف Feature أو عملية للعائلة لمجرد وجود endpoint. حافظ على القدرات والـflows الحالية؛ لا تخترع حذفًا أو تعديلًا أو شاشة جديدة.
- لا تضف package، ولا تستبدل networking أو state management أو error presentation.
- لا تستخدم DTO في UI/domain، ولا تستدعِ API أو Repository أو UseCase من UI. إنشاء ViewModel عبر DI مسموح؛ اختيار وتنفيذ العمليات يتم في التركيب المناسب والـViewModel، وليس منطق الشبكة داخل widget.
- حافظ على `Event → ViewModel → UseCase → Repository → DataSource → ApiServices`.
- حافظ على single immutable State + copyWith لكل ViewModel؛ لا تستبدلها بعائلة subclasses لحالات loading/success/error.
- لا تجعل domain يعتمد على Flutter أو GetIt أو Dio.
- لا تعدل generated files يدويًا، ولا تغير عقود HTTP أو أسماء JSON أو قيم country/bounds أو شروط business بلا دليل من العقد الحالي.
- لا تعدل ملفات غير مرتبطة، ولا تسترجع أو تمسح تغييرات المستخدم. المشروع كان يحتوي على تغييرات غير مرتبطة عند إعداد الخطة.
- لا تعمل commit أو merge أو push بدون طلب المستخدم. اعرض نتائج كل مرحلة وتابع العمل المصرح به.

## 2. الوضع الحالي الذي يجب مراجعته

راجع هذه الملفات أولًا، لأن الأسماء والمسارات قد تتغير قبل التنفيذ:

| الملف | الوضع الحالي / سبب المراجعة |
|---|---|
| `lib/features/addresses/presentation/manager/addresses_view_model.dart` | يجمع قائمة العميل، الكتالوج، geocoding، التغطية والحفظ، وفيه configureFamilyMember واعتماد مباشر على عائلة |
| `lib/features/addresses/presentation/manager/addresses_state.dart` | State مقسمة إلى addresses/locations/action/mapAutofill/coveragePreview؛ أعد استخدام الأجزاء بدل إعادة اختراعها |
| `lib/features/addresses/presentation/manager/addresses_event.dart` | مدخل UI الحالي؛ افصل أحداث القائمة عن المحرر |
| `lib/features/addresses/presentation/screens/address_choose_location_screen.dart` | يدعم familyMemberId، ويختار UseCases عائلة؛ يجب فصل التركيب مع الحفاظ على args ونتائج route |
| `lib/features/family_addresses/presentation/widgets/family_address_location_stage.dart` | يستخدم AddressesViewModel ويبدل العضو، مع BlocConsumer واسع |
| `lib/features/family_addresses/presentation/manager/family_addresses_view_model.dart` | يدير الأفراد والاكتمال؛ addressSaved لا يستقبل العنوان الجديد |
| `lib/features/family_addresses/presentation/screens/family_addresses_screen.dart` | تحويل members داخل builder وتحديث FamilyFlowScope داخل build |
| `lib/features/family_addresses/data/repo/family_addresses_repository_impl.dart` | يحدّث FamilyFlowSnapshotStore عند add/update؛ حافظ على تحديث صاحب الطلب الأصلي |
| `lib/features/family_subscription_setup/domain/entities/family_flow_snapshot_store.dart` | snapshot مشتركة وrevision؛ لا تستبدل الكائن أو تعطل حمايته |
| `lib/config/routing/routing_generator.dart` | مستخدمو route وأشكال arguments وعودة النتيجة |
| `lib/core/di/di.dart` ومصدر DI الحالي | تحقق من عمر ViewModels والخدمات؛ المحرر factory وليس singleton |
| `lib/core/network/api_services.dart` | يشارك DTOs ويحتوي endpoints منفصلة؛ نقل imports لا يغير HTTP |

مخاطر مثبتة من القراءة تستلزم اختبارات قبل الإصلاح:

- المسار العائلي في AddressesViewModel يحوّل add/new preview فقط، بينما عمليات أخرى تستخدم API العميل. لا تدّع أنها كلها مستدعاة حاليًا؛ اثبت مساراتها وأوقف fallback الخاطئ.
- اختيار area يعتمد على member generation ولا يتحقق من أحدث اختيار area داخل نفس العضو.
- تحميل الكتالوج واكتمال تحميل blocks يحتاجان حماية عبر تبديل owner وإغلاق المحرر.
- معظم فروع doIntent لا تنتظر Futures الداخلية رغم إرجاع Future<void>.
- snapshot تتحدث بعد الحفظ، لكن members داخل FamilyAddressesState لا تتحدث بالعنوان الجديد.
- pagination في العائلة يمكن أن تعيد بناء subtree تحتوي على الخريطة.

## 3. هيكل الملفات النهائي ومسؤولياتها

### 3.1 نقل ملفات موجودة مع الحفاظ على أسماء الأنواع

انقل الملفات التالية من `lib/features/addresses/` إلى نفس المسار النسبي تحت `lib/core/address/`، ثم عدّل جميع imports المباشرة والمتعدية في المشروع والاختبارات:

```text
domain/entities/customer_address_entity.dart
domain/entities/customer_address_request_entity.dart
domain/entities/locations_catalog_entity.dart
domain/entities/map_address_autofill_entity.dart
domain/entities/address_coverage_preview_entity.dart
domain/entities/address_coverage_pagination_entity.dart
data/mapper/customer_address_mapper.dart
data/mapper/map_address_autofill_mapper.dart
data/models/request/customer_address_request_dto.dart
data/models/request/address_coverage_preview_request_dto.dart
data/models/request/map_geocode_request_dto.dart
data/models/request/map_reverse_geocode_request_dto.dart
data/models/response/customer_address_response_dto.dart
data/models/response/address_coverage_preview_response_dto.dart
data/models/response/address_coverage_pagination_response_dto.dart
data/models/response/map_address_autofill_response_dto.dart
data/models/response/locations_catalog_response_dto.dart
data/models/response/region_catalog_response_dto.dart
domain/usecase/get_locations_catalog_usecase.dart
domain/usecase/geocode_address_usecase.dart
domain/usecase/reverse_geocode_location_usecase.dart
presentation/manager/address_catalog_matcher.dart
presentation/manager/address_entry_flow_controller.dart
```

تحقق من صيغة DTO العميل والعائلة قبل المشاركة؛ إذا اختلفت، المشترك فقط Entity والمكونات المتطابقة، ويظل DTO المختلف داخل feature. لا تغيّر payload لتسهيل النقل.

انقل مكونات المحرر المشتركة التالية إلى `core/address/presentation/widgets/`:

```text
address_choose_location_map_view.dart
address_choose_location_sheet.dart
address_choose_location_search_bar.dart
address_choose_location_options_row.dart
address_choose_location_mode_card.dart
address_choose_location_header.dart
address_map_marker.dart
address_form_field.dart
address_details_wolt_sheet.dart
home_address_form_card.dart
address_coverage_preview_bottom_sheet.dart
address_coverage_restaurants_list.dart
address_coverage_loading_skeleton.dart
address_loading_overlay.dart
```

لا تنقل widget يعتمد على family subscription أو navigation قبل إزالة الاعتماد بحقن callbacks أو قيم presentation محايدة، دون تغيير الشكل. الـstepper الخاص بالاشتراك يبقى في feature، ولا يُسحب للكور مع الخريطة.

مكونات قائمة العميل مثل current_address_card/saved_address_tile/action menu/delete dialog/content/actions/saved sections تظل في addresses. Skeletons الخاصة بصفحات العميل والعائلة تظل مع صفحاتها. الملف `widgets/saved_addresses_section.dart` حاليًا export وليس widget مكرر؛ لا تتعامل معه كتكرار تنفيذ.

### 3.2 ملفات جديدة محددة

```text
lib/core/address/domain/repo/address_location_repository.dart
lib/core/address/data/repo/address_location_repository_impl.dart
lib/core/address/data/data_source/address_location_remote_data_source.dart
lib/core/address/data/data_source/address_location_remote_data_source_impl.dart
lib/core/address/data/data_source/address_location_cache.dart
lib/core/address/domain/contracts/address_editor_operations.dart
lib/core/address/presentation/manager/address_editor_view_model.dart
lib/core/address/presentation/manager/address_editor_event.dart
lib/core/address/presentation/manager/address_editor_state.dart
lib/features/addresses/domain/usecase/customer_address_editor_operations.dart
lib/features/family_addresses/domain/usecase/family_address_editor_operations.dart
```

أنشئ widgets منفصلة للخريطة والتغطية/loading عند الحاجة الفعلية إلى rebuild boundary، بملف واحد لكل widget وبنفس الـlayout الموجود. لا تنشئ طبقات أو ملفات فارغة.

### 3.3 الحدود والعقود

- `AddressLocationRepository`: getLocationsCatalog(countryCode, areaId)، geocode وreverseGeocode، بنفس ApiResult وأنواع Entities والتوقيعات الحالية؛ نقل UseCases الثلاثة لتستهلك هذا العقد.
- AddressesRepository يحتفظ بعمليات customer CRUD وpreview/default فقط. FamilyAddressesRepository يظل مستقلًا ويحتفظ بعملياته الحالية وتحديث snapshot.
- `AddressEditorOperations` عقد domain محايد لعمليات المحرر، وليس Repository بديلًا. تنفيذه في كل feature يفوض إلى UseCases الحالية؛ لا يتجاوز أي طبقة.
- المحرر يستخدم العقد للحصول على preview وحفظه، ولا يحتوي memberId أو imports للفيتشرز. هوية الجلسة رقم محلي أو قيمة محايدة لا تحمل معرفة بالعائلة.
- capabilities ثابتة، تمنع أحداث update/default لو غير مدعومة. لا تنفذ fallback إلى API العميل ولا تستخدم nullable UseCases مع `!`.

شكل مرجعي للعقد (احفظ signatures وأنواع البيانات الموجودة عند التنفيذ):

```dart
enum AddressEditorAction { add, update, setDefault }

abstract interface class AddressEditorOperations {
  Set<AddressEditorAction> get supportedActions;

  Future<ApiResult<AddressCoveragePreviewEntity>> previewNew(
    CustomerAddressRequestEntity request, {int? page, int? pageSize});

  Future<ApiResult<AddressCoveragePreviewEntity>> previewExisting(
    String addressId, {int? page, int? pageSize});

  Future<ApiResult<CustomerAddressEntity>> add(
    CustomerAddressRequestEntity request);

  Future<ApiResult<CustomerAddressEntity>> update(
    String addressId, CustomerAddressRequestEntity request);

  Future<ApiResult<CustomerAddressEntity>> setDefault(String addressId);
}
```

تنفيذ العميل يدعم العمليات الموجودة. تنفيذ العائلة يدعم فقط العمليات المستخدمة والمثبتة في الـflows الحالية. العمليات غير المدعومة تعيد typed failure من نمط المشروع، والمحرر يرفضها قبل الطلب. لا تضف أزرارًا جديدة ولا شروطًا بصرية جديدة.

لو العقد سيؤدي إلى methods غير مستخدمة كثيرة، قسمه إلى عقود capabilities صغيرة بنفس التوقيعات بدل إضافة abstractions بلا فائدة. وثّق الاختيار النهائي في تقرير التنفيذ.

## 4. Task 1 — تثبيت baseline والاختبارات

**Files:** read-only للملفات السابقة؛ تعديل اختبارات السلوك الموجودة فقط عند إضافة coverage.

- [ ] شغل `git status --short` وسجل الملفات المعدلة أصلًا. لا تعمل stash/reset/clean.
- [ ] اقرأ القواعد كاملة، واقرأ اختبارات العناوين الحالية بدل افتراض سلوكها من الاسم.
- [ ] تتبع كل مستخدمي AddressChooseLocationArgs والـroute وfamilyMemberId ونتيجة الرجوع.
- [ ] شغل الاختبارات الحالية التالية وسجل أي فشل سابق قبل التعديل:

```powershell
flutter test test/addresses_map_autofill_test.dart test/addresses_locations_catalog_cache_test.dart test/address_coverage_preview_test.dart test/address_coverage_pagination_view_model_test.dart test/address_coverage_pagination_transport_test.dart test/address_coverage_pagination_modal_test.dart test/family_addresses_view_model_test.dart test/family_saved_address_prefill_test.dart test/address_save_navigation_test.dart test/address_edit_form_prefill_test.dart
```

- [ ] سجل صورًا للحالات الموجودة: قائمة العميل، إضافة، تعديل، اختيار الموقع، فورم العنوان، preview loading/success/error/load-more، العائلة وتبديل الفرد. استخدم تشغيل المشروع الحالي وأدواته؛ لو الصور أو Maps غير متاحة اذكر الحد بدقة، ولا تدّع مطابقة بصرية.
- [ ] سجل عدد طلبات catalog/blocks وbuilds للخريطة عند pagination وحفظ/تبديل الفرد. قياس frame timing يكون في profile mode على جهاز ممثل؛ debug rebuild tracking وحده ليس قياس سرعة.

**Acceptance:** baseline معروف، ولا يتغير الكود الإنتاجي في هذه المهمة.

## 5. Task 2 — نقل البيانات المشتركة دون تغيير السلوك

**Files:** ملفات النقل في 3.1، مستخدمو imports في lib/test، ApiServices imports، DI registrations المطلوبة.

- [ ] انقل Entities/DTOs/Mappers مع الحفاظ على أسماء classes وحقول JSON/nullability والسلوك.
- [ ] عدّل imports في كامل repo؛ الملفات الخارجية للفيتشرين مسموح تعديل imports المطلوبة فقط، لا منطق unrelated.
- [ ] لا تضف exports انتقالية إلا إذا كانت مرحلة مؤقتة ضرورية؛ احذفها بعد تحديث جميع المستخدمين.
- [ ] ولّد code فقط إذا كانت annotations/DI تحتاج؛ لا تعدل generated files يدويًا.
- [ ] شغل mapper/transport/contract tests الموجودة المتعلقة بالعناوين والتحليل.

**Acceptance:** payload وresponse mapping unchanged، ولا يوجد نوعان منفصلان لنفس Entity، ولا يعتمد الكور على Features.

## 6. Task 3 — خدمات الموقع والكاش المشترك

**Files:** AddressLocationRepository/DataSource/Cache الجديدة، UseCases الموقع المنقولة، حذف methods الموقع من AddressesRepository بعد نقل كل المستخدمين.

- [ ] اكتب `test/address_location_cache_test.dart` لاختبار reuse/in-flight/error/clear قبل التنفيذ.
- [ ] انقل استدعاءات ApiServices للكتالوج/geocoding إلى DataSource الموقع، مع safeApiCall داخل Repository فقط.
- [ ] AddressLocationCache تكون DI instance مشتركة للكتالوج والـblocks فقط. المفتاح countryCode + areaId؛ أضف لغة الاستجابة للمفتاح إذا endpoint ينتج أسماء حسب header الحالي.
- [ ] cached data immutable؛ لا cache لـState أو selectedArea أو owner أو CoveragePreview.
- [ ] عند نفس المفتاح الجاري أعد نفس Future. أزل Future في finally سواء النجاح أو الفشل. لا cache لفشل، ولا تسمح لطلب بدأ قبل clear أن يعيد ملء الكاش بعده؛ استخدم cache revision.
- [ ] احتفظ ببيانات catalog/blocks طوال عمر الجلسة المحددة، ووفّر clear عند logout/account/locale change وفق hooks الموجودة؛ لا تضف wiring غير مرتبط بلا حاجة.
- [ ] reverse-geocode cache داخل المحرر أو بمفتاح كامل واضح؛ لا تنقل cache تقريبي عالميًا. احتفظ بالthreshold/debounce الحاليين ولا تغيرهما بالتخمين.
- [ ] لا cache لتغطية العميل أو الفرد في هذه المرحلة، ولا retry تلقائي للكتابة.

**Test cases:** نفس country/area في محررين يعطي طلبًا واحدًا؛ البلدان المختلفة لا تشترك؛ pending requests مشتركة؛ failed request يسمح بطلب جديد؛ clear يمنع النتيجة القديمة من تخزين نفسها؛ لا ينقل اختيار مستخدم إلى الآخر.

**Acceptance:** requests أقل في السيناريوهات المثبتة دون مشاركة بيانات شخصية أو تغيير اختيارات.

## 7. Task 4 — فصل المحرر وعمليات الـFeatures

**Files:** AddressEditorViewModel/Event/State والعقد والتنفيذان، AddressesViewModel/State/Event، الشاشتان وFamilyAddressLocationStage، DI factory/registration.

- [ ] انقل locations/mapAutofill/coveragePreview/editor action إلى AddressEditorState بإعادة استخدام equality/copyWith الصحيحة. قائمة العميل تبقى في AddressesState.
- [ ] افصل أحداث الكتالوج والموقع والمعاينة والحفظ للمحرر. UI يستخدم doIntent فقط للعمليات؛ navigation في listener.
- [ ] جميع فروع doIntent التي تنفذ Future ترجع أو await العملية، لا Future ينتهي قبل العملية الداخلية. unawaited يستخدم فقط في UI عند fire-and-forget المقصود.
- [ ] أنشئ ViewModel جديدًا لكل محرر؛ حقن implementation ثابت للعمليات عند الإنشاء. عند تغيير الفرد أبطل/أغلق المحرر القديم وابدأ جلسة جديدة، مع إبقاء كاش الموقع مشتركًا.
- [ ] حافظ على route arguments العامة ومكان route screen. اجعل composition يختار تنفيذ العميل/العائلة بدل imports عائلة داخل محرر الكور. إن احتاج routing adapter، ضعه في composition/navigation الحالي وليس داخل core/address.
- [ ] انقل عمليات preview/default الخاصة بقائمة العميل إلى نفس المحرر أو مكون يستهلكه بدون تكرار منطق pagination. لا تنشئ ViewModel عامًا ضخمًا مرة أخرى.
- [ ] احذف configureFamilyMember وfamily UseCase fields/fallbacks من الكود العام بعد استبدال كل استخداماتها.
- [ ] تأكد من ownership: BlocProvider(create) يغلق owned ViewModel؛ BlocProvider.value لا يغلق instance خارجي. لا double close، ولا singleton للمحرر.

**Tests:** `test/address_editor_operations_test.dart` و`test/address_editor_view_model_test.dart`؛ assert calls للعميل والعائلة، capabilities غير المدعومة لا تستدعي API، await doIntent لا ينتهي قبل إكمال Completer، كل محرر معزول.

**Acceptance:** core/address لا يستورد features، والفيتشران لا يعتمدان على بعضهما، ونفس route return values والـflows.

## 8. Task 5 — تزامن الطلبات وحماية الحفظ

**Files:** AddressEditorViewModel/State/Event، AddressEntryFlowController، FamilyAddressesViewModel/State، FamilyAddressesRepositoryImpl وsnapshot عند الحاجة المحددة فقط.

استخدم request revisions محلية مستقلة للكتالوج/اختيار المنطقة/geocoding/coverage، وsession revision لكل owner/editor. لا تجعل تغيير pagination يبطل catalog بلا داعٍ.

نمط تنفيذ لازم يتكرر عند كل await يؤثر على UI:

```dart
final session = _sessionRevision;
final request = ++_areaRequestRevision;
final result = await loadArea();
if (isClosed || session != _sessionRevision ||
    request != _areaRequestRevision) return;
// Emit only if the currently selected area still matches the request.
```

- [ ] تحقق مرة أخرى بعد awaits المتداخلة مثل تحميل blocks بعد geocoding، وليس بعد أول request فقط.
- [ ] إعادة اختيار نفس القيمة لا تصدر State ولا طلب جديد بلا سبب. تغيير governorate يمسح area/block؛ تغيير area يمسح block. استخدم clear flags الصحيحة بدل null الذي يحتفظ بالقيمة القديمة في copyWith.
- [ ] منع duplicate submit بقفل synchronous قبل أي await؛ لا تكتفِ بتعطيل الزر. Capture العملية/owner/request المستهدفين قبل await.
- [ ] لا تؤكد preview قديمة: اربط pending action بsnapshot request/session، وأبطلها عند تعديل البيانات التي تؤثر على coverage.
- [ ] في فشل الحفظ احتفظ ببيانات الفورم وبيانات العملية اللازمة لإعادة المحاولة. لا تمسح pending context قبل نجاح الحفظ بطريقة تفقد retry.
- [ ] لا retry تلقائي للـPOST/PUT/DELETE عند timeout. لو النتيجة غير معروفة استخدم قراءة موجودة للتوفيق إن كان العقد يسمح، وإلا حافظ على feedback الحالي واطلب retry يدويًا؛ لا تخترع idempotency field أو endpoint.
- [ ] ignore old UI responses لا يعني إلغاء الكتابة في backend. نتيجة حفظ فرد A تظل تحدث snapshot الخاص بـA حتى لو انتقل المستخدم إلى B، دون اكتمال/تنقل/رسالة نجاح تخص B.
- [ ] اكتمال الحفظ في العائلة ينتج ownerId + saved entity؛ حدّث state.members للفرد المطابق وليس currentMember وقت وصول النتيجة. حدّث completion لنفس owner، والتنقل للخطوة التالية مرة واحدة فقط عندما يخص النجاح الجلسة الحالية.
- [ ] load في FamilyAddressesViewModel له latest request/close guards، وcurrentIndex صالح عند تغيير members. عدم وجود أفراد يعالج وفق flow الحالي، لا skeleton لا نهائي ولا navigation جديد من build.
- [ ] success/error effects مع operation revision أو tracking الحالي بحيث لا يتكرر snackbar/navigation بسبب coverage update.
- [ ] dispose cancels owned timers/listeners/controllers. Dio cancellation اختياري فقط لو infrastructure الحالية تدعمه؛ لا تغير ApiServices لتدّعي أن ignore هو cancellation.

**Tests — `test/address_editor_race_conditions_test.dart`:** استخدم Completer للتحكم في ترتيب الردود، لا sleeps زمنية.

```dart
// Test structure: use the project's existing fake UseCases/Repositories.
final first = Completer<ApiResult<LocationsCatalogEntity>>();
final second = Completer<ApiResult<LocationsCatalogEntity>>();
// Dispatch select A then B. Complete B first, then A.
// Expect selectedArea.id == B after both Futures finish.
```

اكتب كذلك حالات: governorate changes أثناء blocks، geocoding A/B، close أثناء catalog ثم blocks، owner switch أثناء preview/save، submit مرتين، حفظ فاشل ثم retry بنفس المدخلات، revisiting saved member يعرض العنوان الجديد. أضفها إلى `family_addresses_view_model_test.dart` و`family_saved_address_prefill_test.dart` عند ملاءمة fixtures الحالية.

**Acceptance:** latest selection wins؛ لا emit بعد close؛ لا طلب حفظ مزدوج؛ ولا نتيجة عضو تنتقل لعضو آخر.

## 9. Task 6 — فصل rebuild boundaries بدون تغيير التصميم

**Files:** FamilyAddressLocationStage، FamilyAddressesScreen، AddressesScreen، AddressChooseLocationScreen، widgets المحرر المنقولة وحدود البناء الجديدة.

| الجزء | الاستماع المسموح |
|---|---|
| خريطة/اختيار موقع | locations والبيانات اللازمة فعليًا، لا coverage pagination |
| submit control | action.isLoading فقط أو primitive projection مكافئ |
| coverage panel | preview/session/loading/loadingMore/failure اللازمة للوحة |
| members strip | members/currentIndex/completedMemberIds فقط |
| قائمة العميل | addresses/items/loading/failure الخاصة بالقائمة |
| static layout/header | خارج listeners الواسعة إلا لو يعرض familyName متغير |

- [ ] اجعل selectors تستخرج fields الفعلية أو immutable projection ذات equality صحيحة، لا tuple/list جديدة بلا equality كل build.
- [ ] احتفظ بـGoogleMap subtree ثابت الهوية في pagination. لا تغير map key بسبب coverage/loadingMore؛ تغيير owner فقط يمكن أن يتطلب reset مطابقًا للسلوك الحالي.
- [ ] لا تضع map وcoverage داخل builder واسع ثم تعتقد أن selector داخل child وحده يمنع rebuild بسبب parent؛ افصل boundaries واحتفظ بالـstatic children المناسبة.
- [ ] افصل listeners عن builders. FamilyFlowScope.updateFamilyName ينتقل إلى listener مضبوط، مع معالجة قيمة التحميل الأولى والتحديث مرة واحدة عند تغير الاسم.
- [ ] لا تغيّر ترتيب الـStack أو Positioned أو SafeArea أو padding، ولا presentation mode للـbottom sheet.
- [ ] لا تفرغ text controllers مع unrelated state update؛ احتفظ بselection/cursor/focus/scroll/camera بعد pagination والفشل.
- [ ] لا تنقل localized strings إلى domain. اختيار UI model للشريط يستخدم localization الحالية ويتحدث عند تغير اللغة دون mapping متكرر لكل تغيير لا يخصه.
- [ ] استخدم const حيث صالح؛ لا تضف keys أو RepaintBoundary أو memoization عشوائيًا. Repaint مختلف عن rebuild ويحتاج دليل.

**Tests — `test/address_editor_rebuild_test.dart`:** استخدم widget build counters بحدود حقيقية، وfake map عند الحاجة بدون تغيير UI الإنتاجي. بعد اكتمال البناء الأول سجل العدادات؛ pagination/loadingMore لا يرفع map build count، تغيير submit يحدّث submit section، owner change يعيد تهيئة editor مرة واحدة مقصودة. تأكد أن props المحتاجة تتحدث رغم تقليل builds.

**Acceptance:** نفس الشكل والـfocus/camera/scroll، وتحديث coverage مستقل عن الخريطة. وثّق rebuilds الضرورية بدل وعد zero rebuild.

## 10. Task 7 — التغطية والأخطاء والـpagination

**Files:** shared coverage manager/widgets، implementations الخاصة بالعمليات، existing typed error handling عند ضرورة مرتبطة.

| الحالة | السلوك المطلوب |
|---|---|
| catalog failure بلا بيانات | loader ثم error widget الموجود مع retry لنفس الطلب |
| فشل مع بيانات صالحة | احتفظ بالمحتوى، feedback بنفس pattern الحالي |
| successful empty addresses/restaurants | empty state الموجود، لا Failure وهمي |
| missing/invalid coordinates | تحقق بالمحددات الحالية قبل request، يشمل NaN/infinity إن كان النوع يسمح |
| coverage conflict/unresolved region | لا confirm؛ نفس presentation والشروط الحالية |
| form/save failure | الفورم يبقى، لا انتقال أو اكتمال |
| failed load-more | احتفظ بالصفحات الحالية، retry الصفحة الفاشلة فقط |
| repeated page / missing metadata / empty next page | نهاية وفق العقد الحالي؛ لا infinite request loop |
| duplicate restaurant IDs | merge مستقر بدون تكرار المعرفات المعروفة وبنفس ترتيب السيرفر |
| response missing fields | Mapper defensive وفق rules، ولا invent IDs/coordinates تجعل عملية غير صالحة قابلة للتأكيد |
| unsupported editor action | typed failure بدون customer fallback أو API request |
| auth/network/server error | mapper/interceptor/error presenter الحالي، لا feedback system جديد |

- [ ] حافظ على سياسة coverage الخاصة بالعميل والعائلة بشكل صريح محقون، لا imports للعائلة ولا boolean لا يحدد معناه. ممنوع توحيد الشروط المختلفة بتغيير business behavior.
- [ ] isLoadingMore/initial loading/save locks تمنع requests المتكررة، وsession checks تطبق على pagination وretry أيضًا.
- [ ] لا snackbar متكرر مع كل loadMore state، ولا إغلاق modal لجلسة أحدث بسبب finally لجلسة أقدم.
- [ ] إعادة المحاولة تكرر العملية الفاشلة وصاحبها والصفحة نفسها، دون تحميل باقي Features.

**Tests:** توسعة `address_coverage_pagination_view_model_test.dart` و`address_coverage_pagination_modal_test.dart` و`address_coverage_restaurants_pagination_test.dart` و`address_coverage_preview_bottom_sheet_test.dart` للحالات أعلاه. استخدم fixtures الفعلية؛ لا تعيد كتابة اختبارات لمجرد مطابقة implementation.

## 11. Task 8 — DI وimports والتحقق النهائي

- [ ] راجع جميع مستخدمي الأنواع المنقولة في family_subscription_setup/subscription_checkout/subscription_settings وغيرها. عدّل imports اللازمة فقط، دون refactor لهذه Features.
- [ ] ViewModels factories؛ catalog cache عمره مشترك مناسب؛ عمليات الأسرة مرتبطة بالفرد عند composition ولا تتحول إلى singleton owner متغير.
- [ ] شغل generator إذا احتاج النقل/DI ذلك، وافحص generated diff ولا تمسح تغييرات أصلية في الملفات المشتركة.

```powershell
dart run build_runner build --delete-conflicting-outputs
```

- [ ] formatter على الملفات المعدلة فقط. لا تستخدم `dart format lib test` لو هيعدل أجزاء خارج نطاق العمل.
- [ ] شغل التحليل والاختبارات المتعلقة ثم suite المشروع الحالية إذا البيئة تسمح:

```powershell
flutter analyze
flutter test test/address_location_cache_test.dart test/address_editor_operations_test.dart test/address_editor_view_model_test.dart test/address_editor_race_conditions_test.dart test/address_editor_rebuild_test.dart
flutter test test/addresses_map_autofill_test.dart test/addresses_locations_catalog_cache_test.dart test/address_coverage_preview_test.dart test/address_coverage_pagination_view_model_test.dart test/address_coverage_pagination_transport_test.dart test/address_coverage_pagination_modal_test.dart test/address_coverage_restaurants_pagination_test.dart test/family_addresses_view_model_test.dart test/family_saved_address_prefill_test.dart test/address_save_navigation_test.dart test/address_edit_form_prefill_test.dart test/address_choose_location_sheet_test.dart test/subscription_address_localization_test.dart
flutter test
```

- [ ] فحص dependency boundaries. المخرجات المتوقعة للأمرين الأولين: بلا imports مخالفة. الـrouting composition مستثنى من منع cross-feature العام، لكنه ليس داخل الفيتشرين:

```powershell
rg -n 'package:meal_meat_user/features/' lib/core/address
rg -n 'features/family_addresses/' lib/features/addresses
rg -n 'features/addresses/' lib/features/family_addresses
rg -n 'configureFamilyMember|invalidateFamilyMemberOperations' lib test
git diff --check
git diff --stat
git status --short
```

- [ ] راجع صور قبل/بعد للحالات نفسها ونفس viewport/locale/data، بالعربية والإنجليزية واتجاهات المشروع المدعومة، دون استنتاج RTL من languageCode.
- [ ] راجع Maps على جهاز فعلي/محاكي مناسب؛ fake map في widget tests لا يثبت camera/platform performance.
- [ ] قارن عدد requests وrebuild counts وprofile frame timings بنفس السيناريوهات والأجهزة. لا تدّع تحسن FPS أو الذاكرة من نجاح اختبارات فقط.

## 12. معايير التسليم النهائية

- [ ] لا تغيير تصميم أو نصوص أو animations أو ترتيب/موضع عناصر. أي ضرورة لتغيير بصري لها موافقة مستخدم موثقة قبل التنفيذ.
- [ ] المشترك داخل core/address ولا imports لـFeatures منه.
- [ ] customer/family APIs منفصلة، ولا fallback خاطئ.
- [ ] Owner/session isolation، ونتائج قديمة لا تغيّر owner/selection الحاليين.
- [ ] saved entity يحدّث state.members وsnapshot لصاحب العنوان الصحيح.
- [ ] الحفظ مرة واحدة لكل عملية، والفشل لا يفقد الفورم أو retry context.
- [ ] pagination لا يعيد بناء الخريطة، ولا يكرر المطاعم أو الطلبات الجارية.
- [ ] cache الموقع يشارك البيانات العامة فقط ومفاتيحه صحيحة والـclear آمن ضد الطلبات المتأخرة.
- [ ] owned resources disposed، وFutures المنتظرة تمثل اكتمال العملية.
- [ ] route args/result/navigation والـflows القديمة محفوظة، effects مرة واحدة.
- [ ] analyzer/tests نتائجها مسجلة، وأي failures سابقة مفصولة عن regressions الجديدة.
- [ ] لا files unrelated أو packages جديدة أو generated edits يدوية أو بقايا implementation قديم.

## 13. تقرير جيميني المطلوب بعد التنفيذ

قدّم للمستخدم تقريرًا مختصرًا يشمل:

1. الملفات المنقولة والجديدة والمسؤوليات النهائية.
2. إصلاحات التزامن والحفظ والكاش والتغطية.
3. نتائج الأوامر والاختبارات الفعلية، وأي قيود تشغيل.
4. قياس قبل/بعد للطلبات والـrebuilds، وframe timing لو اتقاس فعليًا.
5. دليل مراجعة الشكل قبل/بعد، أو توضيح أن visual validation تعذر.
6. أي نقطة لم تُنفذ وسببها، وأي تغيير بصري ما زال منتظر موافقة المستخدم.

لا تعتبر العمل مكتملًا لمجرد نقل الملفات أو نجاح analyzer. الفصل، صحة الـflows، عزل النتائج، تقليل rebuilds المثبت، والمحافظة على التصميم كلها شروط تسليم.
