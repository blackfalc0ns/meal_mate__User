# Auth, Session, Biometric & Change Password — Gemini Implementation Plan

> **For agentic workers:** نفّذ باستخدام `executing-plans` خطوة بخطوة مع checkpoints. هذه خطة تسليم إلى Gemini، وليست تصريحًا بتغيير أجزاء أخرى من التطبيق. لا تستخدم agents إضافية تلقائيًا.

**Goal:** إصلاح وتنظيم الدخول والتسجيل والاستعادة والجلسة والتحقق البيومتري وتغيير كلمة المرور، مع أقل rebuild لازم، أخطاء موحدة، ودون hardcoding غير معتمد.

**Architecture:** تبقى `auth` فيتشر واحدة، وتنقسم إدارة الحالة داخلها حسب المسؤولية. تبقى `change_password` مستقلة. تبقى خدمة الجهاز والتخزين والجلسة في Core، مع إعادة استخدام Retrofit وDio وApiResult وsafeApiCall وInjectable والـ UseCases الحالية.

**Tech Stack:** Flutter / Dart / flutter_bloc / GetIt / Injectable / Dio / Retrofit / json_serializable / local_auth / FlutterSecureStorage / SharedPreferences. لا تضف packages.

**Spec:** مواصفة السلوك كاملة في القسمين 2 و3 من هذا الملف. اقرأ الملف كاملًا؛ المنفّذ لا يحتاج الرجوع إلى المحادثة.

**Baseline inspected:** `9c58d3ada91217764142d6b3a17d3562f0446f91`. أعد فحص الكود عند التنفيذ؛ أرقام الأسطر والتفاصيل قابلة للتغيير.

**Status:** خطة فقط. لم تُنفذ تغييرات المنتج. رابط تغيير كلمة المرور غير متوفر. قرارات المنتج المقترحة مميزة صراحةً أدناه.

## 1. Global constraints / تعليمات إلزامية

- اقرأ `AGENTS.md` و`rules/ui_rules.md` و`rules/rules_backend.md`. الملف الموجود فعليًا هو `rules_backend.md` وليس الاسم المعكوس المذكور في AGENTS.
- لا تغيّر معمارية المشروع، ولا تنشئ API client جديدًا أو Result wrapper أو state management آخر.
- لا تعدّل ملف API السائق المفتوح في IDE، ولا تنفذ report issue أو reassignment؛ هذا نطاق مختلف.
- حافظ على UI الموجودة لشاشات auth أثناء refactor. الواجهة الجديدة الوحيدة المعتمدة بمصدر هي إعداد البصمة، وواجهة change password تنتظر مصدرها.
- كل widget مخصصة في ملف منفصل، مع State الخاصة بها في نفس الملف. لا تفصل Row/Column البسيطة بلا فائدة.
- الألوان من `context.colorScheme`، النصوص من `context.localization`، الأنماط من `styles_manager.dart`، والمسافات من `spacing.dart`.
- لا تنشئ قياسات أو درجات لون تخمينية. إذا قيمة Figma ليس لها token مطابق، سجّل القيمة والمصدر والتعارض، ثم انتظر اعتماد token بدل تقريبها إلى قيمة مختلفة.
- الاتجاه من inherited Directionality. لا تستخدم شرط العربية لفرض اتجاه التطبيق. يمكن عزل OTP الرقمي باتجاه معروف إذا ذلك مطلوب لصحة قراءة الرمز، ولا تعمم هذا على الكارت أو الشاشة.
- لا تنسخ أصول SVG أو صور عشوائية؛ أعد استخدام الموجود، أو صدّر الأصل من node Figma المطلوبة وسجّله في Assets.
- كل API action: UI → sealed Event → doIntent → private ViewModel handler → UseCase → Repository → DataSource → ApiServices.
- لا تستخدم DTO في presentation، ولا BuildContext في services/domain، ولا localization داخل DataSource.
- استخدم constructor injection. لا تضف `getIt` داخل handlers لتعويض dependency واضحة.
- لا تعدّل generated files يدويًا، بما فيها DI وRetrofit وDTO وlocalizations. شغّل generators اللازمة.
- لا تسجّل passwords أو OTP أو access/refresh tokens أو request/response bodies الحساسة؛ افحص الـ network logger أيضًا.
- لا تنفذ format شامل ولا commit/push ولا تمسح تعديلات المستخدم. اعرض diff محدودًا بالنطاق.
- **كل request blocking loading يجب أن يستخدم `const CustomProgressIndicator()` من `lib/core/widget/custom_progress_indecator.dart` في منتصف الشاشة.** لا spinner داخل الزر بدلًا منه، ولا loader جديد.
- لا تخلط rebuild مع repaint؛ لا تدّعِ تحسن FPS أو blur أو raster time بدون قياس profile mode.

## 2. مواصفة المنتج وحدود القرارات

### 2.1 السلوك المؤكد من المستخدم

1. «تذكرني» = استمرار جلسة الحساب؛ عند فتح التطبيق مجددًا والجلسة صالحة يدخل Home مباشرة بدون بصمة.
2. عند انتهاء access token مع refresh token صالح، يجدّد التطبيق الجلسة تلقائيًا.
3. إذا الجلسة غير قابلة للتجديد، يرجع لشاشة الدخول؛ عندها البصمة وسيلة دخول سريع إذا مفعلة وجاهزة.
4. نجاح البصمة محليًا ليس نجاح API login؛ لا تفتح Home قبل قبول السيرفر واكتمال المصادقة.
5. كلمة «البصمة» تشمل الوجه والإصبع وفق الجهاز، وليست fingerprint فقط.
6. auth تبقى فيتشر واحدة؛ تقسيم إدارة الحالة داخلها. change_password مستقلة وتستخدم data/domain الموجودين.
7. استخدم Core errors، وامنع hardcoded text/colors/spacing غير المعتمدة، وقلل rebuild والتداخل.
8. لودر الطلبات هو CustomProgressIndicator الموجود، مركزي على مستوى الشاشة.

### 2.2 قرارات مقترحة للخطة؛ ليست حقيقة قديمة في المشروع

- `biometricOnly: true`؛ فشل/إلغاء البصمة يترك الدخول اليدوي متاحًا، ولا يُفعّل fallback إلى PIN تلقائيًا.
- «لاحقًا» محفوظة للحساب على الجهاز، ولا يتكرر عرض الإعداد تلقائيًا بعد التأجيل؛ يمكن فتح الإعداد يدويًا.
- إذا «تذكرني» غير مختارة: الجلسة تعمل أثناء التشغيل الحالي، ولكن بداية process جديدة لا تستعيد هذه الجلسة تلقائيًا. مجرد انتقال التطبيق إلى الخلفية أو resume ليس logout.
- اختيار «تذكرني» الافتراضي يظل false، مطابقًا للحالة الموجودة؛ لا تغيّره خفية أثناء refactor.
- إظهار setup بعد أول **مصادقة مكتملة** عند توفر biometric enrollment وعدم وجود قرار setup للحساب؛ لا يظهر أثناء challenge غير مكتمل أو كل تشغيل.
- في التسجيل لا تُخزن كلمة المرور في registration State لعرض setup لاحقًا. إذا طريقة biometric الحالية تحتاج credentials ولا يمكن تمريرها بملكية قصيرة العمر، أجّل الربط إلى دخول يدوي ناجح ولا تعرض تفعيلًا وهميًا.
- بعد password change/reset الناجح، تُبطل credentials البيومترية القديمة؛ إعادة الربط بعد دخول يدوي ناجح وبموافقة المستخدم. لا تمسحها إذا الطلب فشل.
- manual logout يمسح الجلسة وبيانات الدخول البيومترية ويعطّل fast login للحساب؛ انتهاء الجلسة من السيرفر وحده يحافظ على enrollment صالح لإعادة تسجيل الدخول. افصل السببين في التنفيذ.
- القرارات أعلاه هي التصميم المقترح. إذا المستخدم غيّرها، حدّث المواصفة والاختبارات قبل الكود المعتمد عليها.

### 2.3 نقاط تحتاج دليلًا قبل تنفيذ الجزء المتأثر

| الدليل الناقص | تأثيره | ما يمكن إنجازه الآن |
|---|---|---|
| Figma node لشاشة change password | لا تصمم الشاشة من نفسك ولا تكرر reset password | data/domain checks وViewModel/tests ممكنة؛ route الجديد يُوصل عند وجود شاشة معتمدة |
| عقد customer auth لمعاني `isAuthenticated` و`nextStep` وchallenge | لا تعتبر 200 مصادقة كاملة، ولا تفترض قيم nextStep أو endpoint جديد | اختبارات non-authenticated response، وحماية التنقل، وحفظ Failure |
| سياسة cooldown للـ OTP | لا تثبت مدة 23 أو 30/60 تخمينية | عزل العداد وتحديد interface للمدة؛ ربط القيمة يحتاج مصدر |
| أثر password update على توكنات السيرفر | لا تفترض logout لكل الأجهزة أو بقاء الجلسة | إبطال biometric credentials المحلية بعد نجاح الطلب |
| بيانات انتهاء الصلاحية للجلسات المخزنة سابقًا | لا تخترع عمر token | migration محافظة: محاولة refresh عند وجود refresh؛ وإلا الدخول اليدوي |

وجود دليل ناقص لمرحلة لا يوقف المراحل المستقلة. سجّل الجزء المعلق بوضوح ولا تعلن اكتمال الميزة كلها.

## 3. قواعد الجلسة والبصمة بالتفصيل

### 3.1 جدول تشغيل التطبيق

| الحالة | النتيجة المطلوبة |
|---|---|
| لا يوجد اختيار remember محفوظ / جلسة غير remembered من تشغيل سابق | شاشة الدخول، بدون طلب بصمة تلقائي |
| remember مفعلة + session metadata صحيحة + access صالح محليًا | Home مباشرة؛ السيرفر يظل صاحب القرار عند رفض الطلبات |
| access منتهي أو مجهول الصلاحية + refresh متوفر | centered loading + refresh واحد فقط |
| refresh ناجح واستجابة كاملة | حفظ التوكنات الجديدة ثم Home |
| refresh مرفوض نهائيًا حسب عقد API | مسح session tokens مرة واحدة ثم login، بدون مسح biometric credentials بسبب انتهاء الجلسة فقط |
| refresh فشل بسبب offline/timeout/5xx | حافظ على session data؛ اعرض Core error مع retry للعملية نفسها؛ لا تصنف ذلك كـ logout نهائي |
| نجاح بصمة من شاشة الدخول | قراءة credentials بعد التحقق، ثم LoginUseCase؛ loading مركزي حتى نتيجة login |
| إلغاء بصمة / lockout / عدم enrollment | لا Home؛ رسالة مترجمة عند الحاجة، والدخول اليدوي يظل متاحًا |
| token flags true لكن القيمة الفعلية فارغة | جلسة غير صالحة؛ لا تعتمد على flags وحدها |

لا refresh دوري بلا داعٍ، ولا API login مع كل تشغيل لجلسة سليمة، ولا biometric prompt من Splash.

### 3.2 حفظ الجلسة

- secure storage للتوكنات. remember preference ليست سرًا، ولكن تُربط بالحساب/الجلسة الصحيحة.
- خزّن expiry UTC الوارد من response؛ لا تحسبه بمدة hardcoded. مرّر UTC clock للاختبارات.
- validity ليست مجرد وجود النص؛ local expiry تساعد routing فقط، و401 المؤكد قد يبطل الجلسة قبل expiry.
- خزّن session بعد اكتمال المصادقة فقط. لا تترك خليط userId/token قديم مع login جديد ناقص.
- لا تحفظ remember قبل نجاح login، وإلا فشل الدخول قد يغيّر جلسة أخرى.
- handle partial secure-storage writes: إذا commit session فشل، لا تعلن login success ولا تستخدم flags توحي بحفظ ناجح.
- registration verification تحتاج policy للجلسة لا تعتمد على remember checkbox الموجود في شاشة أخرى. المقترح remembered=false حتى اختيار واضح من المستخدم؛ لا تفعّلها ضمنيًا.
- لا تحتفظ بكلمة المرور في SharedPreferences أو ملف أو State. التخزين الحالي البيومتري منفصل عن «تذكرني».

### 3.3 صاحب refresh واحد

`TokenInterceptor` يحتوي حاليًا `_inFlightRefresh`، لكنه مستقل عن RefreshTokenUseCase؛ `auth_refresh_service.dart` كله commented code ولا يعتبر خدمة قائمة تعمل.

- انقل تنفيذ refresh المسؤول عن session إلى owner واحد، يستعمله startup وTokenInterceptor بدون السباق على rotating refresh token.
- المسار العادي يبقى Retrofit/DataSource/Repository/UseCase. interceptor يستدعي dependency للمسار نفسه، ولا يعيد parsing response بنفسه.
- endpoint refresh يكون skipAuth لتجنب recursion. owner لا يعتمد على authenticated Dio في constructor بشكل يسبب DI cycle؛ افحص lazy provider registration ودورة الاعتماد قبل التوليد. injected callback/provider مؤجل لحل use case مقبول في تركيب DI فقط؛ ممنوع getIt داخل handlers.
- لا تستخدم `Dio().fetch` ولا تنشئ client إضافيًا. أعد replay عبر injected client القائم مع retry marker واحد، مع اختبار عدم deadlock في QueuedInterceptor. احتفظ بآلية queue الحالية فقط إذا ثبت عملها بهذا wiring؛ تغيير queue متعلق بهذا العيب يحتاج اختبار تزامن.
- إذا refresh خلص بعد logout أو account change، لا تحفظ نتيجته. استخدم session generation يرتفع عند invalidate/replace؛ check generation قبل commit/replay.
- refresh future المشتركة تعود null بعد الإكمال في finally، ولا تتثبت للأبد بعد failure.
- transient failure لا يمسح tokens. classify permanent rejection حسب failure/code/HTTP contract، لا حسب نص الرسالة.

### 3.4 حسابات متعددة وcredentials

- enable/skip مربوطان بـ userId على الجهاز، وليس flag عالمي يفعّل حسابًا آخر.
- لا تضع user password داخل أي Cubit State؛ حالة العرض تحمل capabilities/readiness/status فقط.
- credentials تُقرأ بعد نجاح المصادقة وتستخدم لطلب login واحد ثم تُترك من دون احتفاظ في field طويل العمر.
- النظام يحفظ templates الخاصة بالوجه والإصبع؛ التطبيق لا يقرأها ولا يخزنها. setup تفعيل استخدام التحقق الموجود وليست enrollment داخل التطبيق.
- التخزين الحالي يعيد استخدام password عبر FlutterSecureStorage؛ لا تدّعِ أنه cryptographically bound بالبصمة. الانتقال إلى device-bound token يحتاج backend contract مستقل، وليس جزءًا يُخترع في هذه المهمة.
- لا تفضح الهاتف في `BiometricCredentials.toString()`؛ استخدم وصفًا لا يحتوي بيانات شخصية.
- بعد disable امسح credentials من secure storage والحالة وflags، ولا تترك UI enabled إذا العملية فشلت جزئيًا.

## 4. تصميم Figma المعتمد

**المصدر:** https://www.figma.com/design/OSfVgAwRxYbu8lJmpXOPXC/MealMate-Mobile-APP?node-id=1836-27021&m=dev

**Node:** `1836:27021` — `02.20 - Auth / Biometric Setup`، تم فحص data الفعلية أثناء كتابة الخطة.

العناصر التي يجب الحفاظ عليها:

- شعار التطبيق، عنوان التسجيل البيومتري، وشرح الدخول السريع والآمن.
- رسم البصمة/الوجه في `1836:27060`؛ الصندوق يشمل image crop، صدّره بالقَص الصحيح ولا تستبدله برسم جديد.
- كروت فوائد حماية الحساب وسرعة الدخول وتأكيد العمليات الحساسة.
- صف الوجه `1836:27095` وصف الإصبع `1836:27113`؛ selected presentation وrecommended badge لا تعني القدرة على فرض native sensor.
- ملاحظة الخصوصية `1836:27125`، تفعيل `1836:27133`، لاحقًا `1836:27136`، ونص تغيير الخيار من الإعدادات.
- status bar وhome indicator من النظام، لا ترسم نسخًا fake داخل صفحة Flutter.
- لا تنسخ إحداثيات الـ Frame كـ Positioned screen-wide؛ resolve root frame dimensions/scale وinspect properties ثم بناء responsive يحافظ على التصميم.
- display variants: نوع واحد معروف → عرضه كمتاح؛ types عامة strong/weak فقط → generic verification، لا اسم fingerprint تخميني. كلا النوعين → عرضهما إن التصميم المعتمد يسمح، لكن لا تزعم أن native dialog يحترم اختيار sensor معين.
- تعديل اختيار الحسّاس في التصميم ليعكس قدرة local_auth يحتاج قرار ظاهر؛ لا تنفذ radio choices شكلية لا تغيّر native behavior.
- عبارة «تأكيد العمليات الحساسة» في التصميم لا تعطي تصريحًا بإضافة biometric gating لكل عمليات التطبيق؛ نفّذ login/setup فقط في هذا النطاق.

## 5. خريطة الملفات والمسؤوليات

### 5.1 Auth presentation المقترحة

داخل `lib/features/auth/presentation/manager/` أنشئ الملفات المطلوبة فقط:

| المجموعة | الملفات | المسؤولية |
|---|---|---|
| Login | `login_view_model.dart`, `login_event.dart`, `login_state.dart` | manual/biometric login، remember، failure، readiness؛ لا registration/recovery |
| Registration | `register_view_model.dart`, `register_event.dart`, `register_state.dart` | register، verifyPhone، resendPhoneOtp، snapshot الهاتف والدولة للمحاولة |
| Recovery | `password_recovery_view_model.dart`, `password_recovery_event.dart`, `password_recovery_state.dart` | forgot، resendPasswordOtp، OTP المؤقت، reset؛ reset/clear عند flow جديدة |
| Calling codes | `calling_codes_view_model.dart`, `calling_codes_event.dart`, `calling_codes_state.dart` | load/select فقط؛ يستخدمه auth وfamily dialog |
| Logout | `logout_view_model.dart`, `logout_event.dart`, `logout_state.dart` | logout policy وتمريره من profile بدون ضخ كل auth dependencies |
| Biometric settings/setup | `biometric_view_model.dart`, `biometric_event.dart`, `biometric_state.dart` | استبدال BiometricCubit بالـ ViewModel/Event project pattern، setup/disable/defer؛ لا API login مكرر |

تجنب مضاعفة state البصمة بين LoginViewModel وBiometricViewModel: capabilities موديل immutable مشترك، لكن loading/feedback لكل مسار بملكيته. لا يحتفظ الاثنان بنسخة credentials.

**Screens/widgets الحالية التي تُعدّل:** `auth_flow_screen.dart`, `auth_sign_in_page.dart`, `auth_sign_up_page.dart`, `auth_forgot_password_page.dart`, `auth_otp_page.dart`, `auth_new_password_page.dart`, `auth_phone_field.dart`, `calling_codes_bottom_sheet.dart`, `auth_login_options_row.dart`, `country_code_prefix.dart`, `auth_form_card.dart`, `auth_page_shell.dart`, وwidgets التي ثبت أنها مستخدمة وتحتاج tokens.

**New widgets/screens:**

- `screens/biometric_setup_screen.dart`: provider/navigation composition.
- `widgets/biometric_setup_content.dart`: ثابتة قدر الإمكان وتستخدم reusable primitives.
- `widgets/biometric_setup_hero.dart`, `biometric_setup_benefits.dart`, `biometric_method_tile.dart`, `biometric_privacy_notice.dart`: فقط components حقيقية، واحدة بكل ملف.
- `widgets/auth_otp_countdown.dart`: timer/retry deadline isolated rebuild.
- `widgets/auth_biometric_login_button.dart`: selector صغير للزر فقط.

### 5.2 Change password

احتفظ بكل data/domain في `lib/features/change_password/`. أضف عند تنفيذ المرحلة:

- `presentation/manager/change_password_view_model.dart`
- `presentation/manager/change_password_event.dart`
- `presentation/manager/change_password_state.dart`
- `presentation/screens/change_password_screen.dart` بعد توفر node.
- أي form widget مطلوبة وفق التصميم في `presentation/widgets/`، reuse AuthPasswordField بعد إزالة styling violations فيه، لا تنسخ field آخر.

### 5.3 Core والتكاملات المسموح تعديلها بقدر الحاجة

- `core/services/token_service.dart`: session metadata/storage/credentials؛ constructor injectable قابل للاختبار.
- `core/services/auth_refresh_service.dart`: استبدل skeleton commented بتنسيق single-flight محدد أو احذفه إذا owner reusable قائم يغطي المهمة؛ لا تترك نسختين من refresh.
- `core/biometric/biometric_service.dart`, `biometric_auth_result.dart`, `biometric_credentials.dart`؛ أضف `biometric_capabilities.dart` للناتج immutable.
- `core/services/token_interceptor.dart`, `core/network/external_modules.dart`: dependency wiring وreplay وsecret-safe logger.
- `core/constants/keys.dart` أو owner constants الحالي لstorage keys؛ لا scatter literal keys.
- `core/widget/custom_progress_indecator.dart`: إعادة استخدام دون redesign؛ إذا تعديل token داخله ضروري فهو واسع الأثر ويحتاج مراجعة المستهلكين، لا تفعل ذلك لمجرد تنظيف عرضي.
- `config/routing/app_routes.dart`, `routing_generator.dart`, `features/splash/presentation/screens/splash_screen.dart`: startup/setup/change-password routing فقط.
- `features/profile/presentation/screens/security_privacy_screen.dart`, `widgets/profile_logout_action.dart`: switch/route/logout wiring وrebuild boundary.
- `features/family_subscription_setup/presentation/widgets/family_add_member_dialog.dart`, `family_member_phone_field.dart`: استبدال اعتماد AuthViewModel على calling codes، دون تغيير lookup/debounce/business rules.
- `core/l10n/app_ar.arb`, `app_en.arb`, `config/theme/spacing.dart`, `styles_manager.dart`, theme owner عند نقص semantic color، `core/constants/assets.dart`، وأصول Figma الجديدة فقط.
- ملفات DI/DTO/localization الناتجة تُولد آليًا. لا تمس unrelated generated content دون مبرر.

## 6. Loading contract — مطلب المستخدم الصريح

أعد استخدام `AuthLoadingOverlay` الموجود. النمط التالي هو owner مقترح داخل route بحيث selector لا يعيد إنشاء المحتوى الثابت:

```dart
final content = const ChangePasswordForm(); // الاسم حسب widget المعتمدة لاحقًا
return BlocSelector<ChangePasswordViewModel, ChangePasswordState, bool>(
  selector: (state) => state.isLoading,
  builder: (context, isLoading) => AuthLoadingOverlay(
    isLoading: isLoading,
    child: content,
  ),
);
```

هذا مثال boundary لا scaffold لشاشة change password قبل Figma. `AuthLoadingOverlay` حاليًا يستخدم StackFit.expand وPositioned.fill وCustomProgressIndicator الذي يحتوي Center.

قواعد التنفيذ:

- ضع overlay فوق كامل مساحة الشاشة التي يتفاعل معها المستخدم، لا داخل form card أو زر. يجب أن يحجب submit/back/footer/switch أثناء request حسب route.
- centered loading أثناء login/register/verify/resend/forgot/reset/change-password/logout/initial calling-code fetch الذي يحجب المسار/refresh عند startup.
- لا تعرض double loader: إذا overlay مركزي ظاهر لا CircularProgressIndicator أو spinner آخر داخل الزر أو في الكارت.
- prompt النظام البيومتري native ليس HTTP request. لا تنشئ modal ثانية فوقه. أمنع النقر المتكرر، ثم overlay مركزي أثناء طلب login الذي يتبع نجاحه.
- state close/exception/cancel/API failure يعيد loading=false. لا تترك progress مستمرًا بسبب Future discarded أو storage exception.
- overlay consumer observes bool فقط. static child تُحفظ خارج builder أو const؛ لا تستبدل الشاشة كلها في كل state emission.
- AbsorbPointer يمنع touch فقط؛ امنع route pop أثناء طلب حرج بـ PopScope المناسب للنسخة، وعالج keyboard submission داخل handler guard. لا تعتمد على منع touch كحماية تزامن.
- حافظ على Form controllers وقيم المستخدم أثناء التحميل والفشل.
- `ProfileLogoutAction` widget صغيرة؛ full-screen loader يحتاج ownership في شاشة profile، لا Stack صغير حول زر logout. افحص owner المباشر ومرّر bool لأقرب screen overlay؛ لا تعمم app-wide loader manager.
- لا تستخدم root OverlayEntry إلا إذا أثبت tracing أنه لا يوجد route owner قادر على تغطية الشاشة؛ dispose/remove لكل paths إن اضطُر إليه.

## 7. مراحل التنفيذ — checklist لجيميني

### Task 0 — إعادة الفحص وتثبيت baseline

**Files:** قراءة قواعد المشروع والملفات في القسم 5 وtests الحالية وAPI docs الخاصة بالعميل فقط.

- [ ] شغّل `git status --short` و`git rev-parse HEAD`؛ حافظ على user changes.
- [ ] افحص `TokenService` constructor: الكود المقروء يحتوي named private fields بينما test موجود يستخدم `prefs/sharedPreferences`. تحقق بالـ analyzer قبل اعتماد أي مثال، ثم أصلح constructor injection ضمن Task 1 إذا ثبت التعارض؛ لا تفترض baseline كلها passing.
- [ ] افحص consumers لكل AuthViewModel/BiometricCubit/normalizeLoginPhone عبر `rg`، بما فيها family/profile/splash.
- [ ] نفّذ `flutter analyze` مرة baseline وسجّل الأخطاء السابقة مقابل الجديدة.
- [ ] نفّذ اختبارات auth loading/normalizer وtoken expiry الموجودة. لا تُصلح unrelated baseline failures ضمن هذه المهمة.
- [ ] سجل عقد auth المستخدم، القيم الدلالية للمصادقة، response shapes/expiry/refresh rejection. لا تستخدم وثيقة السائق لتفسير customer APIs.

**Deliverable:** قائمة consumers وbaseline verification والعوائق المعزولة، قبل حذف أي manager.

### Task 1 — Session persistence وremember، دون تغيير UI auth

**Files:** TokenService، constants storage، AuthRepositoryImpl، LoginRequestEntity فقط إذا propagation يحتاجه؛ reminder preference لا ترسل كحقل backend لم يطلبه العقد. tests تحت `test/core/services/` و`test/features/auth/data/`.

**Interfaces المقترحة:**

```dart
enum SessionPersistence { currentRun, remembered }

// داخل TokenService؛ DateTime? للlegacy/metadata غير المعروفة.
Future<void> saveSession({
  required String userId,
  required String accessToken,
  required String refreshToken,
  required DateTime? accessExpiresAtUtc,
  required DateTime? refreshExpiresAtUtc,
  required SessionPersistence persistence,
});
Future<bool> isRememberedSession();
Future<void> clearSession(); // يفصل session عن biometric enrollment
```

SessionPersistence في Core ملف مستقل إذا احتاج import من أكثر من owner. مرّرها محليًا عبر use case/repository بمعامل named واضح ولا تدخلها إلى request.toDto؛ لا تضف field JSON rememberMe.

- [ ] اختبارات تفشل: remembered storage survives service recreation، currentRun ليس autologin بعد startup جديد، writes ناقصة لا تعلن saved session، flags بلا token ليست جلسة.
- [ ] اختبر أن register/challenge لا يحفظ جلسة أو remember قبل اكتمال auth.
- [ ] نفّذ metadata UTC وmigration دون expiry تخمينية. timestamp parsing في data/session boundary، ليس build.
- [ ] اربط successful auth بحفظ session كاملة؛ خزّن policy من login intent، وتجنب mutable UI checkbox بعد await بتثبيت قيمة request عند submission.
- [ ] secure storage failures تنتج Failure قابلًا للعرض عبر النظام الحالي؛ no Home حتى إكمال commit.
- [ ] شغّل الاختبارات المحددة وanalyzer الملفات المتأثرة.

**Deliverable:** remembered session صحيحة وقابلة للاختبار، بدون إنشاء نظام auth آخر.

### Task 2 — Single-flight refresh وstartup routing

**Files:** auth_refresh_service.dart، token_interceptor.dart، external_modules.dart، DI annotations، SplashScreen؛ startup ViewModel/Event/State عند الحاجة داخل splash/manager؛ tests session/refresh/startup.

**Interfaces:**

```dart
// الخدمة تستخدم Retrofit/UseCase الحالي وتعيد ApiResult؛ لا raw Dio parsing هنا.
Future<ApiResult<RefreshTokenEntity>> refreshSession();
// caller يمرر/يقرأ session generation؛ commit يمنع result القديم بعد invalidate.
```

- [ ] اختبارات concurrent refresh calls تنتج network call واحدة؛ rotating refresh محفوظ مرة واحدة.
- [ ] اختبارات offline/timeout/500 تحافظ على tokens؛ definitive invalid refresh يمسحها ويطلب login مرة واحدة.
- [ ] اختبار logout/account change أثناء refresh يمنع حفظ tokens من الجلسة السابقة.
- [ ] اختبار replay يرجع نتيجة الطلب الأصلي، max retry واحد، ولا infinite recursion أو QueuedInterceptor deadlock.
- [ ] إزالة prompt البصمة من startup؛ remembered صالح → Home، otherwise flow وفق الجدول 3.1.
- [ ] استخدم CustomProgressIndicator مركزي أثناء startup refresh؛ Core error/retry عند transient failure.
- [ ] لا داعي لانتظار FCM في refresh؛ افصل auxiliary notification registration عن صحة الجلسة إذا backend لا يشترطها، مع failure مستقل وعدم استثناء غير معالج.
- [ ] تأكد DI graph بلا cycle؛ build_runner ثم analyze/tests.

**Deliverable:** دخول remembered مباشر وتجديد واحد موحد، دون اعتبار كل فشل شبكة session expiry.

### Task 3 — Calling codes migration قبل تقسيم بقية auth

**Files:** calling_codes manager الثلاثة، AuthPhoneField/BottomSheet/CountryCodePrefix/AuthFlowScreen، family dialog/phone field.

**Interfaces:** sealed `CallingCodesEvent` مع `LoadCallingCodesEvent`, `SelectCallingCodeEvent`؛ State فيها items/selected/isLoading/Failure، دون login/OTP.

- [ ] اختبارات load واحد أثناء in-flight، اختيار نفس countryCode لا emits إضافية، reload يحافظ على اختيار ما زال موجودًا.
- [ ] migrate family provider إلى CallingCodesViewModel بنفس lifetime؛ لا تغير 600ms lookup debounce أو قواعد الأسرة.
- [ ] `CountryCodePrefix` يعرض الاختيار الحقيقي فقط؛ no KW/+965 placeholder يختلف عن payload.
- [ ] إذا قائمة الدول empty بعد نجاح HTTP، اعرض الحالة المناسبة وأوقف submit؛ لا تختلق default country ولا fake Failure.
- [ ] inspect `CallingCodeEntity.formatInternationalPhone` الموجود قبل صنع helper. لا تنقل normalizer أو تبدله بدون tests: الهاتف الدولي المختلف عن الدولة، leading zero، 00، وlocal يبدأ بأرقام dial code.
- [ ] snapshot الهاتف/countryCode عند register/forgot؛ subsequent OTP يستخدم snapshot ولا selected mutable الحالي.
- [ ] selector للهاتف يراقب selected فقط؛ load/error component يراقب fields اللازمة، لا PageView كاملًا.
- [ ] اختبارات family existing + country selector + normalizer.

**Deliverable:** source واحد لاختيار الدولة، وكل consumers migrated بأمان.

### Task 4 — LoginViewModel وربط «تذكرني»

**Files:** login manager الثلاثة، AuthSignInPage، AuthLoginOptionsRow، AuthBiometricLoginButton، AuthRepositoryImpl عند incomplete-auth validation.

**Interfaces:**

```dart
sealed class LoginEvent { const LoginEvent(); }
class SubmitLoginEvent extends LoginEvent {
  const SubmitLoginEvent(this.request, {required this.rememberMe});
  final LoginRequestEntity request;
  final bool rememberMe;
}
class RememberMeChangedEvent extends LoginEvent {
  const RememberMeChangedEvent(this.value);
  final bool value;
}
// biometric submit event لا يحمل كلمة مرور؛ service يقرأها بعد native success.
```

- [ ] اختبارات duplicate submit → login call واحدة؛ loading ends لكل failure؛ close أثناء await لا emit بعد close.
- [ ] اختبارات HTTP success مع isAuthenticated=false/empty token/challenge لا يفتح Home ولا يحفظ session.
- [ ] اربط checkbox بقيمة واحدة في LoginState أو controlled widget؛ لا duplicate `_rememberMe` داخلي وخارجي.
- [ ] `BlocListener` للتنقل والرسائل، fixed form خارج broad consumer، selector للcheckbox وزر البصمة والـ overlay.
- [ ] listener يراقب outcome الخاص بالمحاولة فقط، لا login.isSuccess القديم عند تغيير biometric error.
- [ ] لا تقرأ controller password بعد await لحفظ credentials؛ ثبّت بيانات محاولة login بملكية مؤقتة ولا تسربها للState. لو المستخدم غيّر fields أثناء الطلب لا تحفظ بيانات غير المستخدمة في API.
- [ ] translate failures بواسطة ErrorMessagePresenter.fromFailure؛ verification/challenge next steps وفق العقد فقط.
- [ ] لا انتظار subscription cache/FCM قبل success إلا إذا dependency لازمة للـ Home مثبتة. إذا أُجّل cache، Home يجب ألا يستخدم قيمة حساب قديم، ويقرأ subscription عند جاهزيتها. لا fire-and-forget عشوائي دون catch/ownership.
- [ ] اختبر behavior للrememberMe false/true من intent حتى persistence دون إضافتها إلى JSON.

**Deliverable:** checkbox لها تأثير حقيقي، ولا form rebuild مع operations أخرى.

### Task 5 — Registration وPassword recovery كمسارين مستقلين

**Files:** register/recovery manager triples، SignUp/Forgot/OTP/NewPassword pages، AuthFlowScreen/AuthOtpPurpose.

- [ ] registration events: submit/verify/resend/clearFeedback/resetFlow. recovery: requestOtp/saveOtp/resend/submitReset/clearFeedback/resetFlow.
- [ ] state retain failures لكل عملية، request phone/country snapshot، request generation، loading flags المطلوبة فقط؛ no raw password في state.
- [ ] API success لكن success=false أو otpSent=false/passwordReset=false يعطي outcome واضح؛ لا silent loading end أو success toast وهمي. تفسير business failure حسب العقد.
- [ ] OTP phone verification لا يستمع لresendPasswordOtp أو recovery state؛ reset OTP لا يفحص verifyPhone failure قديم.
- [ ] clearFeedback/resetFlow يمنع تكرار رسائل قديمة والتنقل من flow سابقة. clear OTP بعد نجاح reset أو بدء محاولة recovery جديدة.
- [ ] route مباشر OTP/newPassword بلا context ينقل لخطوة بدء المسار المناسبة أو يعرض localized prerequisite feedback، ولا يبني payload فارغ.
- [ ] retry هو نفس العملية ببيانات المحاولة؛ لا reload كل auth.
- [ ] الحالة المحلية للشروط تبقى قريبة من widget؛ `_confirmPasswordController` الحالي غير مستخدم في UI: احذفه إذا لا تصميم يتطلبه، ولا تضف confirm field من نفسك لشاشة sign-up.
- [ ] تنقل AuthFlowScreen لا setState لقيمة currentPage لا تظهر في build؛ purpose update واحد عند الحاجة، دون double setState. providers مستقرة، ولا recreate ViewModel عند navigation rebuild.
- [ ] اختبارات flow boundaries، stale results، repeated errors، zero-empty success، resend failure.

**Deliverable:** تسجيل واستعادة مستقلة بدون رسائل أو نتائج تتداخل.

### Task 6 — عزل OTP countdown والـ loading

**Files:** auth_otp_countdown.dart، auth_otp_page.dart، auth_loading_overlay.dart، route owners، tests widgets.

**Interface المقترحة:**

```dart
class AuthOtpCountdown extends StatefulWidget {
  const AuthOtpCountdown({
    super.key,
    required this.retryAvailableAtUtc,
    required this.onResend,
    required this.isResending,
  });
  final DateTime retryAvailableAtUtc;
  final VoidCallback onResend;
  final bool isResending;
  // State في نفس الملف؛ widget هي boundary الوحيدة للعداد.
}
```

- [ ] deadline تأتي من owner حسب مصدر cooldown المعتمد. لا تستخدم 23 داخل widget ولا تضيف مدة تخمينية إلى constants فقط لتسميتها non-hardcoded.
- [ ] احسب remaining من UTC deadline لا decrement فقط؛ background/resume لا يمد cooldown خطأً.
- [ ] init/dispose وdidUpdateWidget يعالجان deadline جديدة وتغيير flow؛ timer cancel عند zero دون setState بلا تغيير.
- [ ] تغيير purpose/session يحذف OTP القديم ويعيد timer فقط حسب إرسال ناجح جديد.
- [ ] فشل resend لا يبدأ cooldown جديد محليًا إلا إذا contract يعيد retry deadline على الفشل.
- [ ] تمرير static child للoverlay؛ selector لا يعيد بناء PageView عند loading.
- [ ] widget tests: loader center يساوي center screen، touch/back/keyboard repeat blocked، failure removes loader مع form محفوظة، tick rebuilds countdown فقط.

**Deliverable:** countdown صغير، وطلبات تظهر loader مركزي واحد.

### Task 7 — إصلاح Core biometric capabilities/lifecycle/errors

**Files:** core biometric الملفات الأربعة، TokenService، biometric manager الجديد، LoginViewModel؛ tests `test/core/biometric/`.

**Interfaces المقترحة:**

```dart
class BiometricCapabilities {
  const BiometricCapabilities({
    required this.supportsBiometrics,
    required this.hasEnrollment,
    required this.presentationType,
  });
  final bool supportsBiometrics;
  final bool hasEnrollment;
  final BiometricTypeEnum presentationType;
}
Future<BiometricCapabilities> getCapabilities();
Future<BiometricAuthResult> authenticate({required String localizedReason});
Future<bool> cancelAuthentication();
```

اربط capabilities failure بنتيجة typed عند الحاجة بدل إخفائها في false. لا تفرض إضافة failure wrapper عام جديد؛ توسع result المحلي القائم.

- [ ] افصل hardware capability عن enrollment وعن دعم device PIN؛ `isDeviceSupported` لا يعتبر biometric enrollment.
- [ ] strong/weak → generic عند عدم وجود نوع face/fingerprint واضح؛ no fingerprint fallback على exception/empty list.
- [ ] استدعاء capability مرة في init، وأعد فحص enrollment عند resume/فتح إعداد يدوي إذا يحتمل تغيره؛ لا cache دائمًا.
- [ ] `_isAuthenticating` يبقى global guard بسبب singleton؛ أضف busy status بدل cancelled للطلب المتداخل.
- [ ] إلغاء screen-owned prompt عند مغادرة owner فقط؛ لا شاشة أخرى تلغي prompt ليست مالكتها. finally يعيد guard حتى exceptions.
- [ ] service returns status فقط ورسالة diagnostic لا تعرض للمستخدم. presentation maps notAvailable/notEnrolled/passcodeNotSet/lockedOut/permanentlyLockedOut/failed/error/busy؛ user cancel بلا error toast.
- [ ] no hardcoded English/Arabic strings في service/managers. أضف keys المفقودة في ARB للغات المهيأة.
- [ ] credentials لا تُقرأ في init/readiness State. ready يعتمد enable + enrollment + stored-credential presence الصحيحة للحساب.
- [ ] اختبارات enabled بلا creds، creds بلا enabled، unsupported، no enrollment، native false، platform cancellation، busy، exception، disable during pending auth.
- [ ] guard lifecycle بعد كل await في manager؛ منع stale success يعيد enable بعد disable أو logout.

**Deliverable:** service مشتركة صحيحة ولا تخلط business/session/presentation.

### Task 8 — صفحة Biometric Setup وربط settings

**Files:** setup screen/widgets، biometric manager، Assets/tokens/ARB، routing، AuthSignInPage/Register flow، SecurityPrivacyScreen، BiometricPromptSheet بعد migration.

- [ ] أعد inspect node `1836:27021` وصدّر الرسم/الأيقونات المطلوبة. لا تستخدم الصورة المرسلة بدل خصائص node المتاحة.
- [ ] سجّل mapping لكل Figma measurement/color/style إلى owner token. أي gap يحتاج explicit evidence وتوسيع token ضمن نطاق UI المعتمد.
- [ ] أنشئ route للإعداد لا يفتح بلا حساب مصادق عليه. مرّر userId/source/capabilities وtemporary credential handoff فقط إذا مطلوب، دون route arguments محفوظة طويلًا أو أسرار في route name.
- [ ] setup بعد auth مكتمل، وليس بعد register HTTP فقط. إذا no enrollment، لا تفعّل؛ اشرح من localization وإتاحة لاحقًا.
- [ ] native authenticate أولًا، ثم credential/pref commit، ثم success. cancellation/failure يبقي الصفحة ولا يحفظ enabled=true.
- [ ] partial storage write → rollback readiness أو state disabled، لا نجاح وهمي. no credentials → cannot claim login ready.
- [ ] Later يحفظ defer decision للحساب ثم Home. إغلاق الصفحة/back بدون قرار لا يعتبر enabled؛ لا يعرض prompt تاني ضمن نفس transition.
- [ ] settings فتح setup يدويًا بعد defer متاح. disable يمسح storage والstate ويُظهر نتيجة العملية الفعلية.
- [ ] isolate reactive switch/loading/settings biometric tile؛ change password/phone/email tiles ثابتة لا تبنى لمجرد تحميل البصمة.
- [ ] انقل business operations خارج BiometricPromptSheet؛ احذفه فقط بعد migrate كل references. لا تعمل sheet + setup screen لنفس الحدث.
- [ ] الاختبارات: تأجيل/تفعيل/إلغاء/فشل تخزين/حساب آخر/جهاز بدون enrollment، ولا repeat automatic prompt.
- [ ] تحقق rendered عربي وإنجليزي، text scaling وشاشة صغيرة؛ لا claim pixel perfect بلا مقارنة فعلية.

**Deliverable:** صفحة setup مبنية من المصدر، بقدرات حقيقية وليست اختيارًا شكليًا للحساس.

### Task 9 — إكمال Change Password وإبطال credentials القديمة

**Gate:** إنشاء واجهة screen/form وربط route منتج ينتظر Figma node. لا تستبدل هذه المرحلة بتصميم افتراضي. يمكن تنفيذ ViewModel والتخزين واختبارهما قبل التصميم.

**Files:** change-password manager/screen، UseCase الموجود دون duplicate، SecurityPrivacyScreen وrouting، biometric session policy، recovery success path.

**Interfaces:**

```dart
sealed class ChangePasswordEvent { const ChangePasswordEvent(); }
class SubmitChangePasswordEvent extends ChangePasswordEvent {
  const SubmitChangePasswordEvent(this.request);
  final ChangeCustomerPasswordRequestEntity request;
}
// State: isLoading/isSuccess/Failure?، no passwords.
```

- [ ] tests duplicate submit/loading/failure/success/close وعدم إبطال credentials في failure.
- [ ] private handler calls ChangeCustomerPasswordUseCase ثم matches ApiResult<void>؛ لا تخلق response DTO لendpoint void.
- [ ] currentPassword لا trim؛ كلمة المرور الجديدة validation من helper/policy المعتمدة. confirm field فقط إذا التصميم يطلبه، والمطابقة validation محلية لا field backend إضافي.
- [ ] loader المركزي يظهر قبل الطلب وينتهي بعد required local invalidation؛ success feedback لا يسبق إتمام ذلك.
- [ ] بعد نجاح change/reset امسح biometric credentials القديمة/readiness؛ لا تنشئ password الجديدة في State لحفظها لاحقًا.
- [ ] verify server session revocation contract قبل اختيار navigation بعد success؛ لا all-device logout من خيال المنفذ.
- [ ] route `changePassword` مستقل؛ `newPassword` يظل recovery. زر security privacy يستدعي الجديد فقط عند اكتمال الشاشة.
- [ ] أخطاء current password من ErrorMessagePresenter.fromFailure؛ لا مقارنة نصية raw detail.
- [ ] success/failure routing tests، layout/render verification بعد توفر Figma.

**Deliverable:** user logged-in password update منفصل عن OTP recovery، أو تقرير واضح أن UI المرحلة ينتظر تصميمه.

### Task 10 — Logout integration وتنظيف managers القديمة

**Files:** LogoutViewModel triple، ProfileLogoutAction وصاحب screen overlay، AuthRepositoryImpl، consumers migrated، auth_view_model/state/event وbiometric_cubit القديمين.

- [ ] no manual storage read في UI لطلب logout؛ owner يقرأ refresh عبر dependency/use case ويطبّق policy.
- [ ] logout duplicate guarded، centered screen loader، local clear مضمون حسب policy حتى backend failure، feedback يعكس الفرق بين local logout/server revoke.
- [ ] عند session expiry يحافظ على enrollment الذي يسمح بإعادة login؛ manual logout له invalidate مستقل.
- [ ] لا تحذف AuthViewModel حتى `rg` يؤكد صفر consumers runtime؛ migrate family/profile وجميع selectors أولًا.
- [ ] لا تحذف LoginFormSection/LoginTopSection وسائر الملفات لمجرد الاسم legacy؛ أثبت عدم الاستخدام imports/routes/tests ثم احذف فقط dead code داخل النطاق.
- [ ] remove unused confirm controller/imports/helpers بعد التحويل؛ keep normalizer compatibility أو migrate test import إلى owner helper إذا نقلته.
- [ ] validate DI regenerated بلا manual edits، ولا duplicate biometric init.

**Deliverable:** لا consumers مكسورة، ولا manager شامل باقٍ بالتوازي مع بديله.

### Task 11 — Tokens/localization/RTL ومراجعة الأمان المتصلة

**Files:** traced auth/setup widgets وtokens/ARB/logger فقط.

- [ ] remove `AppColors`, `Colors.*`, hex color داخل widgets touched، باستعمال semantic theme المناسب لا أقرب لون بصري عشوائي.
- [ ] remove locale-based Directionality في AuthFormCard؛ Arabic/English layout وراثي.
- [ ] OTP message formatter مفاتيح localization مع placeholder للثواني، لا string concatenation يعتمد ترتيب لغة واحدة.
- [ ] استبدال gaps/radii بtokens إذا verified match، والقياسات غير المتاحة توقف تعديلها حتى تتوثق.
- [ ] match gradient التصميم من theme extension المعتمدة؛ `AppColors.primaryGradient` الموجود مختلف عن inline login gradient، لا تستبدله بدون مراجعة Figma.
- [ ] network logger يمنع password/OTP/tokens في headers/bodies/responses. الـ refresh logger الحالي ليس مقيدًا بـ kDebugMode ويعرض bodies؛ عالج logger policy بدون إنشاء client جديد.
- [ ] ErrorMessagePresenter لFailure، ولا exception.toString يصل للtoast. أخطاء local biometrics من localized statuses.
- [ ] const عندما جميع args compile-time، بلا تحويل widgets تغير theme/localization إلى const بمعاملات ثابتة غلط.

**Deliverable:** لا hardcoding مخالف في الملفات المعدلة، وRTL/LTR صحيحان، ولا secrets في logs.

## 8. استراتيجية الاختبارات وأمثلة فعلية

لا تضف اختبارات mirror لكل getter. اختبر observable outcomes/requests/navigation/rebuild ownership. أعد استخدام fakes الموجودة، أو mocks المتاحة في pubspec؛ لا تضف package.

### 8.1 اختبار الـ centered loader — إعادة استخدام اختبار قائم

توجد baseline في `test/features/auth/presentation/widgets/auth_loading_overlay_test.dart`. وسّعها لتغطية route screen بدل form صغيرة:

```dart
testWidgets('request loading is centered and blocks submission', (tester) async {
  var submissions = 0;
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(body: AuthLoadingOverlay(
      isLoading: true,
      child: TextButton(
        onPressed: () => submissions++,
        child: const Text('Submit'),
      ),
    )),
  ));
  expect(find.byType(CustomProgressIndicator), findsOneWidget);
  expect(tester.getCenter(find.byType(CustomProgressIndicator)),
      tester.getCenter(find.byType(Scaffold)));
  await tester.tap(find.text('Submit'), warnIfMissed: false);
  expect(submissions, 0);
});
```

النص الثابت في test fixture ليس product copy. لا تستخدم `pumpAndSettle` أثناء Lottie repeat؛ استعمل pump بمدة محددة ثم unmount حتى لا يعلق الاختبار.

### 8.2 اختبارات session بالجدول

أنشئ `test/core/services/auth_session_startup_test.dart` باستعمال secure-storage fake يدعم injected writes/reads وclock ثابت. اختبر:

| Fixture | Assert |
|---|---|
| remembered=true, access future expiry | route Home، biometric calls=0، refresh calls=0 |
| remembered=true, access past, refresh valid | refresh calls=1، Home بعد completion فقط |
| remembered=false, previous run tokens | login، لا biometric ولا refresh automatic |
| refresh timeout | tokens intact، typed error، retry enabled |
| refresh permanently rejected | clear count=1، route login count=1 |
| refresh pending ثم logout | completion لا يحفظ tokens ولا يفتح Home |
| legacy بلا metadata | لا fake expiry؛ migration policy من 3.1 |

اكتب failing test لكل مجموعة behavior قبل implementation، شغله وحده، ثم minimal fix، ثم أعد تشغيل المجموعة. لا assertions على implementation private methods.

### 8.3 اختبار التزامن بعقد outcome

استخدم Completer في fake use case؛ لا real server أو biometric hardware في unit tests:

```dart
final pending = Completer<ApiResult<LoginEntity>>();
// Fake LoginUseCase.call يعيد pending.future ويزيد callCount.
viewModel.doIntent(SubmitLoginEvent(request, rememberMe: true));
viewModel.doIntent(SubmitLoginEvent(request, rememberMe: true));
expect(fakeLoginUseCase.callCount, 1);
await viewModel.close();
pending.complete(ApiErrorResult(failure: offlineFailure));
await Future<void>.delayed(Duration.zero);
// test runner يفشل إذا صدر emit-after-close/unhandled error.
```

جهز request/LoginEntity/Failure من constructors الحقيقية، no secrets حقيقية. names fake هنا وصف harness، لا types يضيفها production. في اختبار retry بعد completion تأكد callCount يزيد إلى 2 وليس blocked دائمًا.

### 8.4 Rebuild tests وقياس الجهاز

- build counter في test-only widget يحيط static form/hero؛ tick countdown لا يزيده.
- تغيير rememberMe لا يعيد بناء phone/password؛ تغيير selected country يعيد prefix فقط.
- state resend error لا يعيد hero/form ولا يعرض verify error من محاولة سابقة.
- biometric settings loading لا يعيد change-password tile.
- استخدم DevTools Track Widget Builds في profile mode على الجهاز عند توافره؛ سجل الجهاز/سيناريو/counts. blur cost يُقاس من raster timings وليس build counter.
- لا تضف RepaintBoundary عشوائيًا؛ قياس الرسم يقرر الحاجة.

### 8.5 Manual device matrix

1. Android fingerprint enrolled، Android face/generic حيث متوفر، iOS Face ID/Touch ID حسب جهاز فعلي.
2. الجهاز يدعم biometrics لكن لا enrollment، وdevice لا يدعمها.
3. cancel prompt، failed attempt، lockout، background أثناء prompt، مغادرة owner.
4. remembered cold restart، nonremembered cold restart، resume بدون إغلاق process.
5. expired access + valid refresh، invalid refresh، offline/timeout أثناء refresh.
6. manual logout أثناء refresh/biometric، account switch، password change/reset ثم fast login.
7. setup مرة واحدة، Later، manual setup من settings، storage failure.
8. Arabic/English، small viewport، keyboard، text scale؛ loader في منتصف الشاشة بكل request.

## 9. أوامر التحقق وترتيبها

نفذ كل أمر وحده، لا combine shell separators أو mutations غير لازمة:

```text
git status --short
flutter analyze
flutter test --no-pub test/auth_login_phone_normalizer_test.dart
flutter test --no-pub test/features/auth/presentation/widgets/auth_loading_overlay_test.dart
flutter test --no-pub test/core/services/token_interceptor_session_expiry_test.dart
flutter test --no-pub test/core/biometric
flutter test --no-pub test/features/auth
flutter test --no-pub test/features/change_password
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

اختبارات directories الجديدة تشغّل بعد إنشائها، لا تفشل baseline بسبب path غير موجود. شغّل generators عقب تعديل annotations/models، ثم formatter على قائمة الملفات المعدلة فقط، ثم analyze والاختبارات. افحص generated diff قبل التسليم.

**Baseline المعروف من المراجعة:** auth/change_password targeted analyzer: 4 warnings const و17 discarded_futures. اختبارات normalizer/overlay: 5 passed. Core biometric analyzer: no issues. هذه ليست نتائج تنفيذ الخطة ولا إثبات أن full project/test suite passing.

## 10. معايير القبول النهائية

- [ ] remember checkbox تؤثر فعليًا في cold-start persistence، بلا كلمة مرور بسبب remember.
- [ ] remembered valid session تفتح Home دون native prompt.
- [ ] expired access يجدد مرة واحدة، transient failure لا يمسح الجلسة.
- [ ] session expiry login يمكن استخدام biometrics فيه، success API شرط Home.
- [ ] face/fingerprint/generic صحيحون حسب الدليل، لا sensor selection وهمية.
- [ ] disable/logout/password change تطبق السياسة المذكورة بلا stale credentials/flags/state.
- [ ] كل request blocking فيه CustomProgressIndicator مركزي واحد، بلا button spinner بديل.
- [ ] no broad consumers للصفحات الثابتة، no screen timer setState، no needless setState navigation.
- [ ] calling code واحد متوافق مع payload والـ OTP snapshot؛ no EG/KW/+20/+965 fallback داخل UI.
- [ ] error presentation عبر Core للـ API، وlocalized typed statuses للـ biometrics.
- [ ] requests guarded، pending close/stale generation لا ينتج navigation أو session write قديم.
- [ ] profile logout/family phone consumers migrated قبل حذف AuthViewModel.
- [ ] no extra clients/packages/architecture، no sensitive logs.
- [ ] setup Figma node/assets inspected ومقارنة rendered موثقة؛ لا claim مطابقة من source فقط.
- [ ] change-password UI تم تنفيذها من node معتمد، أو مصنفة بوضوح pending design دون إعلان اكتمال المرحلة.
- [ ] generators/formatter/analyzer/tests executed بعد آخر تعديل، findings السابقة مفصولة عن الجديدة.

## 11. شكل تسليم Gemini المطلوب

عند انتهاء كل مرحلة، حدّث checkboxes وأبلغ باختصار: ماذا تغيّر، الملفات، الاختبارات ونتائجها، وأي نقص يمنع هذه المرحلة فقط.

عند التسليم النهائي قدّم:

1. جدول المراحل: completed / pending evidence / failed verification مع السبب المحدد.
2. قائمة تغييرات الملفات الفعلية، وأي توسع ضروري في Core/profile/family مع دليل dependency.
3. نتائج أوامر verification الفعلية، لا نتائج baseline المنسوخة.
4. دليل rebuild/performance إذا قيس؛ وإلا اذكر أنه لم يُقَس على جهاز.
5. دليل مقارنة Figma للصفحات التي أُنشئت، وقرارات المنتج التي ما زالت مقترحة.
6. المخاطر الفعلية فقط: backend contract أو design gate أو device behavior غير مختبر.

لا تعلن أن «كل شيء مكتمل» إذا change-password design أو auth contract أو cooldown source ما زال ينقص المرحلة المتأثرة. لا تطلب تأكيدًا متكررًا على نطاق أُقر بالفعل؛ اطلب فقط المعلومة الناقصة التي لا يمكن استنتاجها من الكود أو المصدر.
