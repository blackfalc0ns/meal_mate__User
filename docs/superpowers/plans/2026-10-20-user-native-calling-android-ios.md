# User Native Calling — Android & iOS Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking. نفّذ داخل تطبيق اليوزر فقط. هذه الوثيقة خطة وليست تصريحًا بالبدء في تعديل التطبيق.

**Goal:** استقبال مكالمات المندوب والرد عليها وتشغيل الصوت في تطبيق اليوزر على Android وiOS دون انتظار تشغيل Flutter، مع الحفاظ على تصميم MealMate داخل التطبيق وسلامة باقي المزايا.

**Architecture:** محرك مكالمات واحد لكل منصة يدير دورة المكالمة، جلسة الجهاز، REST، SignalR، WebRTC، الربط بالنظام، والموارد. Flutter يظل واجهة عرض وتحكم من خلال جسر typed؛ لا ينشئ اتصال صوت موازيًا. الواجهات الأصلية للنظام وشاشات Compose وFlutter تتعامل مع نفس المحرك ونفس المكالمة.

**Tech Stack:** Dart / Flutter / flutter_bloc / Injectable كما بالمشروع؛ Kotlin + Jetpack Compose + Android Telecom؛ Swift + PushKit + CallKit + AVAudioSession؛ Native WebRTC؛ MethodChannel + EventChannel؛ بروتوكول Voice Calls v2 الموجود.

**Spec:** المواصفات التفصيلية المضمّنة في الأقسام 1–10 أدناه هي تصميم هذه الخطة. لا توجد وثيقة Figma أو مواصفات backend مستقلة تم التحقق منها خلال إعداد الخطة؛ بوابات التحقق أدناه إلزامية قبل تنفيذ الأجزاء المعتمدة عليها.

**تاريخ الإعداد:** 2026-10-20، Africa/Cairo.

**مرجع الفحص:** `feature/voice-calls-v2` عند commit `fcdb2379be57e24b8f3e69819832a3f655a16de0`.

**حالة مساحة العمل أثناء التخطيط:** الفرع الحالي `development`. تمت قراءة ملفات برانش المكالمات باستخدام `git show` دون checkout. لا تنفّذ الخطة على `development` لمجرد أن الملف محفوظ عليه.

## Global Constraints

- النطاق: تطبيق اليوزر Android وiOS فقط؛ لا تعديل لتطبيق المندوب أو كود السيرفر أو إنشاء مشروع جديد.
- مراجعة عقود السيرفر مسموحة؛ أي عجز في العقد يسجّل كاعتمادية خارجية، وليس تعديلًا مخفيًا ضمن عمل اليوزر.
- UI: اتبع `rules/ui_rules.md`. اسم ملف backend الموجود فعليًا هو `rules/rules_backend.md`، رغم أن `AGENTS.md` يشير إلى `rules/backend_rules.md` غير الموجود.
- حافظ على feature-based architecture و`Event → ViewModel → UseCase → Repository → DataSource` وعلى DTO → Mapper → Entity في Flutter؛ لا API calls داخل الشاشات.
- Flutter يستخدم Core networking الحالي لأي API يبقى مملوكًا له. الشبكات الأصلية الضرورية لمسار cold start محصورة في ميزة calling، ومفصولة عن Compose وCallKit UI. لا عميل شبكات ثانٍ لباقي التطبيق.
- Android: Kotlin وJetpack Compose؛ لا استبدال Compose بـXML في شاشات المكالمات المخصصة.
- iOS: Swift وواجهات CallKit الأصلية عند استقبال مكالمة والتطبيق غير ظاهر. لا وعد بفتح واجهة مخصصة تلقائيًا فوق شاشة القفل.
- الإشعارات العادية، الدفع، الحساب، والوجبات تظل ضمن بنيتها الحالية؛ التغييرات المشتركة تقتصر على ما يلزم الربط وتُغطّى باختبارات رجوع.
- محرك واحد فقط لكل منصة؛ لا Dart SignalR موازٍ ولا PeerConnection ثانٍ للمكالمة نفسها.
- لا تسجيل صوت أو تشغيل ميكروفون قبل قبول المستخدم ووجود إذن صالح وتفعيل جلسة الصوت المسموح بها من النظام.
- لا ألوان أو أبعاد أو خطوط أو نصوص UI مخترعة؛ Figma والتوكنز والموارد الحالية مرجع. أي عنصر جديد يحتاج تصميمًا/نصوصًا معتمدة قبل تنفيذه بصريًا.
- جميع لغات التطبيق مدعومة. الموجود حاليًا `ar` و`en`، ويعاد فحص `supportedLocales` وقت التنفيذ؛ دعم RTL/LTR من النظام.
- لا تعديل يدوي لملفات `*.g.dart` أو `di.config.dart` أو ملفات localization المولّدة.
- لا تحديث جماعي لحزم التطبيق أو تغيير applicationId أو bundleId أو رفع minimum OS كأثر جانبي.
- لا إضافة dependency قبل توثيق اسمها وإصدارها المتوافق ومصدرها؛ أي حزمة غير متفق عليها تُعرض تحديدًا للمراجعة وفق قواعد المشروع.
- عدم الادعاء بأن الاختبارات نجحت أو أن التجربة فورية بلا قياسات. أي اختبار غير منفّذ يسجّل `NOT RUN` مع السبب.
- كتابة الخطة لا تعني ضمان انعدام الأخطاء؛ الإغلاق يتطلب دليل اختبار ومراجعة كل معيار قبول.

## 1. ما الذي تم التحقق منه في البرانش؟

| الدليل | أثره على التنفيذ |
|---|---|
| `lib/main.dart` ينتظر DI وFirebase و`PushNotificationService.initialize()` قبل `runApp` | بداية التطبيق الكاملة لا تصلح شرطًا لبدء الصوت |
| `firebaseMessagingBackgroundHandler` موجود في Dart ويعرض CallKit من `envelope` | عرض المكالمة الحالي يعتمد على background Flutter path؛ النقل إلى Native يجب ألا يترك عارضًا ثانيًا |
| مسار الخلفية يتعرف على `type=voice-call` لكنه يعالج العرض داخل وجود `envelope` | يلزم parser موحد وفحص الرسائل المبسطة المدعومة؛ لا إسقاط صامت لدعوة صحيحة |
| `VoiceCallManager.initialize()` يشترك في أحداث الرد | التحكم الحالي يبدأ مع تهيئة Dart manager |
| `_executeAnswerCall` يشترط snapshot ثم اتصال/ربط SignalR، وبعده REST answer، ثم reconciliation، ثم ICE وpermission وWebRTC | cold start يحتوي سلسلة waits قبل الصوت؛ يجب فصل مراحل القبول والتوصيل دون مخالفة العقد |
| `_acceptCallKitCall` يستدعي `setCallConnected` قبل `answerCall` | لا ننقل هذا الترتيب كإثبات أن media connected؛ نميز platform answer وserver accepted وmedia ready |
| العداد الحالي يعتمد على snapshot `active` و`connectedAtUtc` | نحافظ على سلطة السيرفر للمدة، مع readiness محلية منفصلة؛ لا نبدأه لمجرد لمس الرد |
| heartbeat الحالي كل 10 ثوانٍ | ينقل للـNative إن بقي هذا ما يفرضه العقد؛ لا heartbeat من Dart أيضًا |
| `VoicePermissionService` يرجع true تلقائيًا على غير Android | يجب تنفيذ check/request/settings حقيقي على iOS |
| namespace/applicationId في Android هو `kw.mealmate.user2` | ملفات المحرك والـbridge الجديدة تكون تحت الحزمة المستخدمة فعليًا |
| يوجد `MainActivity` ثانٍ تحت `kw/mealmate/meal_meat_user` للرنين، بينما الفعلي يحتوي permission channel | لا توصيل features بالملف غير النشط؛ نراجع merged manifest ونوحّد المسؤوليات المتعلقة بالميزة |
| iOS `AppDelegate` لا يحتوي PushKit registry أو CallKit delegate خاص بالمشروع | وجود `voip/audio` في Info.plist وحده لا يحقق استقبال وتشغيل مكالمة مستقلة عن Flutter |
| iOS deployment target = 13.0 في المشروع | لا اختيار Swift SignalR client يحتاج iOS 14 دون حل صريح لسياسة التوافق |
| AGP = 9.0.1، Kotlin plugin declaration = 2.3.20، JVM = 17 | اختبار Compose compiler وbuilt-in Kotlin مع هذا الإعداد، بدل نسخ إعدادات AGP قديمة |
| `flutter_callkit_incoming` = 3.1.6، `flutter_webrtc` = 1.6.2+hotfix.4 في lockfile | افحص native dependencies المقفولة نفسها؛ لا اختيار WebRTC binary آخر يسبب symbols/classes مكررة |
| `MealsConfirmedEffect` يصدر بعد نجاح تأكيد الوجبات، وتعالجه `calendar_screen_effects.dart` مع confirmation sheet موجود | هذا موضع دخول إذن المكالمات؛ لا dialog جديد فوق confirmation sheet وهو مفتوح |

هذه أدلة من مراجعة المصدر، وليست إعادة إنتاج للعطل على جهاز أو إثباتًا لشكل push الذي يرسله السيرفر فعليًا.

## 2. سلوك المستخدم النهائي

### 2.1 التطبيق مفتوح

1. Android native FCM / iOS PushKit يستقبل دعوة المكالمة؛ SignalR قد يوصل نفس الحدث أيضًا.
2. المحرك يوحّد الحدث حسب callId/eventId/sequence، ويحدّث snapshot واحدة.
3. Flutter يقرأ الحالة ويعرض شاشة MealMate الحالية للرنين.
4. المستخدم يضغط رد/رفض من Flutter؛ الأمر يمر للمحرك الأصلي.
5. الصوت لا يعتمد على Navigator أو بناء شاشة Flutter أو تحميل صورة المندوب.
6. على iOS نلتزم بمتطلبات CallKit للـcallback المستخدم. لا نفترض أن واجهة النظام يمكن إخفاؤها دائمًا في foreground؛ نمنع تكرار المعالجة والصوت بدل محاولة تجاوز النظام.

### 2.2 Android غير ظاهر أو العملية متوقفة بسبب النظام

1. FCM data message توقظ مسار استقبال Android الأصلي، إذا سمح النظام بتوصيلها.
2. تعرض CallStyle notification وتضيف المكالمة إلى Telecom ضمن مسار خدمة صحيح.
3. عند السماح بواجهة كاملة، تظهر IncomingCallActivity مبنية بـCompose فوق القفل بالطريقة النظامية.
4. عدم السماح بـfull-screen لا يلغي الدعوة: يبقى تنبيه مكالمة متاحًا وفق أذونات/سياسة النظام.
5. الرد من الشاشة أو notification أو السماعة يمر لنفس coordinator.
6. بعد الرد تبقى شاشة Compose متاحة، والخدمة مسؤولة عن استمرار المكالمة.
7. فتح التطبيق أثناء ذلك يعرض نفس المكالمة في Flutter دون إعادة التفاوض أو استدعاء answer مجددًا.

### 2.3 iPhone غير ظاهر أو العملية متوقفة بسبب النظام

1. APNs VoIP push تصل إلى PKPushRegistry؛ نبلغ CallKit سريعًا وفق متطلبات Apple.
2. لا ننتظر REST lookup أو صورة المندوب أو Flutter قبل إبلاغ النظام.
3. CXProviderDelegate يستقبل الرد/الإنهاء/الكتم، وSwift coordinator يدير المكالمة.
4. WebRTC audio يبدأ مع تفعيل جلسة الصوت من CallKit، وليس من initState في Flutter.
5. واجهة النظام تبقى متاحة؛ لا نقوم بفتح Flutter تلقائيًا عند الرد.
6. إذا فتح العميل التطبيق، تعرض شاشاته حالة الاتصال الحالية دون تملك اتصال ثانٍ.

### 2.4 التحضير المبكر والرد

- أثناء الرنين: قراءة الجلسة الآمنة، تجهيز WebRTC factory، وفتح SignalR وربطه إذا سمح عمر العملية والنظام والعقد. جلب ICE مبكرًا فقط إذا endpoint يسمح أثناء ringing؛ لا نفترض ذلك.
- لا اتصال دائم طوال اليوم لمجرد إبقاء الصوت جاهزًا. التحضير مربوط بدعوة حية وله deadline.
- بدء الميكروفون/audio tracks عند قبول المستخدم وبعد تحقق الإذن وتفعيل مسار audio المسموح.
- لا انتظار لـFlutter كي يتم REST answer أو SDP/ICE أو heartbeat أو hangup.
- طلب answer يخرج فور امتلاك prerequisites الحقيقية. إذا السيرفر يسمح بالقبول قبل hub bind، لا نضيف انتظار bind محليًا. إذا يشترطه، نجري bind مبكرًا أثناء الرنين ونثبت الأداء؛ لا نحذف الشرط بالتخمين.
- فشل الشبكة لا يحول الشاشة إلى active وهمية. الحالة المحلية تظل answering/connecting ثم fail واضح عند المهلة المتفق عليها.

### 2.5 ماذا تعني «جارٍ الاتصال» والمدة؟

- `answering`: المستخدم طلب الرد؛ القبول على السيرفر لم يثبت بعد.
- `connecting`: القبول ثبت، لكن مسار الصوت لم يجهز محليًا.
- `connected`: محليًا النقل الصوتي صالح وجلسة الصوت مفعلة، والحالة متوافقة مع authoritative snapshot.
- لا نطلق `connected` بسبب ظهور remote track وحده أو نجاح REST answer أو لمس زر الرد.
- عداد MealMate يعتمد على `connectedAtUtc/durationSeconds` من السيرفر، مع elapsed monotonic للعرض بين التحديثات. server active وحده مع فشل local audio يعرض reconnecting/connecting بوضوح.
- واجهة نظام iOS/Android لها توقيتها وسلوكها؛ لا نعد المستخدم بأن عداد النظام مطابق حرفيًا لعداد Flutter في كل إصدار.
- هذه الخطة لا تغيّر أي شاشة أو نغمة أو منطق في تطبيق المندوب.

## 3. النطاق البصري للشاشات

| السطح | المحتوى والسلوك |
|---|---|
| Flutter incoming | الاسم/الدور/الصورة إن توفرت، رد ورفض. إعادة استخدام assets/theme الحالية بعد مطابقة Figma |
| Flutter active | حالة واضحة، المدة عند الاتصال، mute، speaker/audio route، end؛ ليس هناك API أو WebRTC داخل widget |
| Android Compose incoming | نسخة Native من الهوية المعتمدة، تحكم accessible، تعمل دون Flutter engine |
| Android Compose active | نفس الوظائف الأساسية، لا اعتماد على Flutter fonts/assets loader؛ موارد محلية معتمدة |
| Android CallStyle notification | رد ورفض/إنهاء وفتح الشاشة، payload داخلي محدود لا أسرار، تحديث نفس notification للمكالمة |
| iOS system UI | caller name/handle، provider icon template، ringtone والقدرات المعتمدة؛ لا صورة/خلفية مخصصة بوعد غير مدعوم |
| Permission explainer | بعد أول تأكيد ناجح للوجبة، زر تفعيل + لاحقًا؛ غياب الإذن لا يفشل تأكيد الوجبة |
| Permission required | داخل التطبيق عند الرد دون الإذن؛ زر request/settings حسب الحالة، وإمكانية إنهاء المحاولة |
| Delivery reminder | CTA غير متكرر في سطح التوصيل المناسب فقط؛ لا نافذة كل مرة يفتح فيها Home |

مرجع الألوان والخطوط والspacing والـassets هو الموجود بالمشروع مع Figma. قبل التنفيذ يلزم تحديد exact Figma node للشاشتين وpermission state، وتوثيق mapping للـCompose. لا يشتق التصميم الجديد من أرقام تخمينية أو من اختلافات عرضية في الكود الحالي.

الـback يغلق surface أو يرجع للتطبيق وفق تصميمه ولا ينهي مكالمة نشطة إلا بأمر end صريح. لا يتم unlock تلقائيًا أو كشف عنوان العميل على شاشة القفل؛ بيانات الطلب الحساسة تظهر داخل التطبيق بعد السماح المناسب.

## 4. عقد الربط Flutter ↔ Native

أسماء قنوات مقترحة ثابتة للإصدار الأول:

```text
MethodChannel: kw.mealmate.user/voice_calls/methods
EventChannel:  kw.mealmate.user/voice_calls/events
schemaVersion: 1
```

هذه أسماء داخلية جديدة وليست endpoints للسيرفر. لا تغيّر applicationId أو bundleId بسبب تشابه الأسماء.

### 4.1 أوامر الجسر

| method | arguments | النتيجة |
|---|---|---|
| `getSnapshot` | لا شيء | NativeCallSnapshot بما فيه idle |
| `getCapabilities` | لا شيء | availability، permission status، presentation capability، سبب عدم الدعم |
| `answer` | callId, lifecycleId, requestId | receipt؛ حالة النجاح الفعلية تأتي من snapshot |
| `reject` | callId, lifecycleId, requestId | receipt |
| `end` | callId, lifecycleId, requestId | receipt |
| `setMuted` | callId, lifecycleId, requestId, muted | receipt؛ لا optimistic flip دائم قبل confirmation |
| `setAudioRoute` | callId, lifecycleId, requestId, routeId | receipt أو unsupported_route |
| `getMicrophonePermission` | لا شيء | notDetermined / granted / denied / permanentlyDenied / restricted |
| `requestMicrophonePermission` | لا شيء، من foreground user action | permission status |
| `openAppSettings` | لا شيء، user action | opened / unavailable |
| `setPresentationContext` | appVisible, localeTag, uiRevision | acknowledgment؛ معلومة عرض لا دليل readiness للصوت |
| `synchronizeSession` | sessionRevision فقط | reconcile session store؛ لا secrets في الحدث |
| `clearSession` | sessionRevision, reason | cleanup receipt؛ الأحداث القديمة لا تقدر تعيد الجلسة |

```json
{
  "schemaVersion": 1,
  "engineInstanceId": "engine-instance-a",
  "revision": 18,
  "callId": "call-a",
  "lifecycleId": "local-lifecycle-a",
  "serverSequence": 7,
  "negotiationGeneration": 0,
  "phase": "connecting",
  "serverStatus": "accepted",
  "microphonePermission": "granted",
  "isMuted": false,
  "audioRouteId": "earpiece",
  "availableAudioRoutes": ["earpiece", "speaker"],
  "mediaTransportConnected": false,
  "audioSessionActive": false,
  "connectedAtUtc": null,
  "elapsedSeconds": 0,
  "errorCode": null
}
```

هذا JSON مثال للجسر، وليس تغييرًا في Voice Calls v2. caller display يُنقل كـDTO منفصل قابل للغياب ويُحوّل إلى entity؛ لا نمرر token/controlProof/SDP/ICE للواجهة.

### 4.2 ضمان عدم ضياع أو إعادة ترتيب الحالة

- المحرك يملك `engineInstanceId` لكل process و`revision` متزايدة محليًا. `serverSequence` يظل مستقلًا عن revision المحلية.
- يشترك Flutter في الأحداث أولًا ثم يطلب snapshot. يستقبل الأحدث بحسب engineInstanceId/revision ويتجاهل snapshot متأخرة.
- أول event عند subscribe عبارة عن snapshot الحالية، ثم أي تحديث. إعادة الاشتراك لا تعيد answer أو reject.
- أوامر ذات requestId مكرر تعيد receipt محفوظة لنفس lifecycle، ولا تكرر side effect.
- callId/lifecycleId غير الحالي أو جلسة حساب قديمة يرد بخطأ typed دون لمس المكالمة الجديدة.
- إغلاق Flutter engine يلغي subscription فقط؛ لا يوقف call service أو WebRTC.
- receipt هي قبول معالجة الأمر، لا إعلانًا بنجاح اتصال الصوت. حالات الرفض typed: stale_call، no_session، permission_required، unsupported_route، platform_rejected، protocol_error.

### 4.3 مسار Flutter يحافظ على الطبقات

```text
Screen → doIntent(CallingEvent)
  → CallingViewModel → calling control UseCase
  → NativeVoiceRepository → NativeVoiceDataSource
  → MethodChannel → platform coordinator

EventChannel → Bridge DTO → Mapper → NativeCallSnapshot entity
  → repository stream → ViewModel State → Screen
```

`VoiceCallRepository` الحالي يبقى مرجع الـREST/history/registration الموجودة إلى أن ننقل ملكية العملية المطلوبة صراحة. لا نحشر control channel داخل Retrofit repository ولا نجعل widget يتصل بالقناة مباشرة.

### 4.4 جسر الجلسة الداخلي

قناة الأوامر السابقة خاصة بواجهة المكالمات ولا تكفي وحدها لترحيل credentials. أضف adapter داخليًا منفصلًا لا تستدعيه widgets:

```text
MethodChannel: kw.mealmate.user/voice_session/methods
installSession(expectedRevision, accountSession, voiceSession)
readAccessToken(expectedRevision)
refreshSession(expectedRevision)
clearSession(expectedRevision, reason)
getSessionMetadata()
```

- `accountSession` يتبع حقول TokenService/refresh DTO الموجودة: userId/accessToken/refreshToken/expiries/persistence، ولا يتضمن معلومات profile غير اللازمة.
- `voiceSession` يتبع VoiceDeviceSessionEntity الحالي. عند migration تنقل نفس session/proof/expiry/token association، لا جلسة مسجلة حديثًا.
- revision مملوكة للمخزن الأصلي؛ install/clear/refresh عمليات compare-and-set. install أول مرة يتطلب empty store وlogin صالح؛ migration قديمة لا تكتب فوق session أحدث.
- `readAccessToken` يرجع token للاستخدام الداخلي في TokenService/TokenInterceptor فقط. `refreshSession` يرجع نتيجة مطابقة للـrefresh contract إلى AuthRefreshService عبر mapper وتكون الكتابة الأصلية اكتملت ذريًا قبل نشر metadata.
- serialized method calls تمر داخل نفس التطبيق؛ لا exposed Activity/Intent/Broadcast يحمل أسرارًا. يمنع طباعة arguments أو channel responses الحساسة، وتبقى EventChannel خالية من secrets.
- إذا بدء التطبيق يستخدم session persistence غير متذكرة، تطبق نفس السياسة الموجودة؛ لا تجعل المكالمات native تتجاوز logout/expiry المتعمدين.
- API الـrefresh الحالي وشكل response مصدر الحقيقة. لا refresh HTTP داخل widget ولا منطقي refresh مستقلان. هذا تغيير محدد لتناسق الجلسة بسبب cold-call path، وليس نقل بقية backend إلى Native.

## 5. محرك المكالمة ومسؤولياته

ينفّذ نفس السلوك مرتين، Kotlin وSwift، باستخدام fixtures مشتركة. المقابل بين المكونات:

| المسؤولية | Kotlin | Swift |
|---|---|---|
| تنسيق الأوامر والحالة | `NativeCallCoordinator` | `NativeCallCoordinator` actor/serial queue |
| الحالة والانتقالات | `CallStateMachine` | `CallStateMachine` |
| جلسة آمنة | `VoiceSessionStore` | `VoiceSessionStore` |
| REST الخاص بالمكالمات | `VoiceApiClient` | `VoiceApiClient` |
| hub/events/rebind | `VoiceSignalingClient` | `VoiceSignalingClient` |
| SDP/ICE/audio tracks | `VoiceMediaEngine` | `VoiceMediaEngine` |
| التعامل مع النظام | `TelecomCallController` | `CallKitController` |
| استقبال push | `VoiceMessagingService` | `VoipPushRegistry` |
| قناة Flutter | `NativeVoiceBridge` | `NativeVoiceBridge` |
| قياسات دون أسرار | `VoiceDiagnostics` | `VoiceDiagnostics` |

عمر coordinator هو application/process أو call service، وليس Activity/Scene/FlutterEngine. لا نستخدم singleton عشوائي لكل class؛ تبنى dependencies مرة واحدة في composition root للميزة مع injectable constructors للاختبار.

### 5.1 حالات محلية منفصلة عن حالات السيرفر

```text
idle → ringing → permissionRequired → answering → connecting → connected
                                               ↘ ending → ended
connected → reconnecting → connected / ending → ended
ringing → ending → ended
```

ليس شرطًا المرور بـpermissionRequired إذا الإذن صالح. `failed/rejected/cancelled/missed` أسباب terminal server، وليست aliases لـconnected. فشل permission flow لا يتحول تلقائيًا لـserver accepted ما لم يفرضه عقد النظام؛ نعيد reconciliation ونغلق المحاولة بوضوح إذا تعذر إكمالها.

قواعد إلزامية:

1. معاملة serial لكل انتقال؛ network/media work خارج main thread، والعودة بفحص ownership.
2. كل async operation يلتقط sessionRevision + callId + lifecycleId + negotiationGeneration، ويتحقق بعد كل await/callback.
3. terminal irreversible لنفس lifecycle؛ event متأخر لا يبعث ringing من جديد.
4. duplicates من Push/Hub/REST لا تنشئ إشعارًا أو صوتًا أو navigation إضافيًا.
5. استلام offer/ICE قبل readiness يخزن في queue محدودة للمكالمة/generation الحالية، ثم يفرغ بترتيب صحيح.
6. generation أقدم تُهمل، والأحدث تلغي retries والـqueue القديمة. الحدود: SDP ≤ 65536 UTF-8 bytes وcandidate ≤ 4096 كما في الكود الحالي.
7. نهاية A ثم بداية B ثم callback قديمة لـA لا تنظف B ولا تغيّر mute/route الخاص بها.
8. مكالمة ثانية أثناء الأولى لا تستبدل الأولى تلقائيًا؛ يطبق contract busy/multi-device الفعلي ويختبره.
9. قبول من جهاز آخر (`winningDeviceSessionId`) ينهي surface المحلي ولا يرسل end ضد الجهاز الفائز.
10. cleanup idempotent: توقف الرنين والـtimers والـheartbeat والـtracks والـpeer والـhub والـplatform call والإشعار؛ لا callbacks end مرتدة تتسبب في REST إضافي.
11. إعادة تشغيل process تنشئ engineInstanceId جديدًا. المخزن يحتفظ بالهوية والterminal/dedupe اللازمة فقط؛ لا يعتبر حفظ `connected=true` دليلًا على peer موجودة. عند restart نراجع active snapshot والنظام، ثم نعيد الاتصال إذا العقد يسمح أو ننهي stale surface. لا وعد بأن نفس PeerConnection تعيش بعد قتل process؛ ضمان ثباتها يخص فتح/إغلاق واجهات Flutter أثناء بقاء المحرك حيًا.

## 6. عقود السيرفر: فحص داخل النطاق، وتعديله خارج النطاق

مرجع ثابت: `lib/core/network/network_constants.dart` و`api_services.dart` وDTOs و`VoiceCallSignalRService`. لا توليد endpoint/field جديد من هذه الخطة.

المسارات الحالية تبدأ بـ`/api/v2/voice-calls`، والـhub هو `/hubs/voice-call-v2`. headers الخاصة بالجلسة: `X-Voice-Device-Session` و`X-Voice-Device-Proof`، مع auth الفعلي حسب العقد.

عمليات يجب نقل سلوكها في مسار المكالمة: active/details/events، ringing-ack، answer/reject/end، ice-servers، reports/connecting، reports/connected، heartbeat، display عند الحاجة. التسجيل/revoke/token refresh ينسقان مع account session ولا يصبح لكل طبقة جهاز مستقل.

Hub compatibility:

```text
BindDeviceSession(deviceSessionId, controlProof)
call:event(envelope)
rtc:offer(envelope), rtc:answer(envelope), rtc:ice-candidate(envelope)
SendAnswer(callId, {type: answer, sdp}, messageId, generation)
SendIceCandidate(callId, candidateData, messageId, generation)
```

نحافظ على four-argument legacy receive fallback الموجود فقط إذا contract الحالي يتطلبه. اليوزر الحالي هو answerer في مسار المندوب؛ لا إضافة زر بدء مكالمة أو تغيير offerer role ضمن هذه الخطة.

قبل التنفيذ، يوثّق response حقيقي sanitized لكل سؤال:

| سؤال | قرار التنفيذ المترتب |
|---|---|
| هل answer يحتاج hub bound أم voice session فقط؟ | تحديد إمكانية إرسال القبول بالتوازي مع hub أو بعده |
| هل answer يوقف deadline؟ وما حد connecting؟ | منع افتراض أن client timer يغير timeout على السيرفر |
| هل يمكن جلب ICE أثناء ringing؟ | السماح بتحضير مبكر أو تأجيل endpoint حتى القبول |
| هل offer قابل للاسترجاع/إعادة الإرسال بعد late bind؟ | منع ضياع offer بين answer والاشتراك في hub |
| هل توجد terminal push عند إلغاء المندوب؟ وكيف تصل لكل منصة؟ | تنظيف شاشة/رنين دون بقاء stale call |
| هل registration/token update يدوّر session/proof؟ | لا force-register يسرق ملكية المكالمة أثناء فتح Flutter |
| ما auth/refresh المطلوب لكل endpoint والـhub؟ | عمل cold path بدون تهيئة TokenInterceptor في Dart |
| كيف نفسر 401/403/404/409 وwinning session؟ | refresh/reconcile/fail محدد، دون retries عمياء |
| هل APNs VoIP token وenvironment/topic مدعومة؟ | iOS terminated test ممكن فعلًا أم blocked خارجيًا |

إذا عقد مطلوب غير مدعوم، ننفّذ الأجزاء المستقلة ونعلّم السيناريو المتأثر `BLOCKED external contract`. لا تغيير للمندوب أو السيرفر، ولا ندّعي إتمام الميزة end-to-end.

## 7. أمان الجلسة والعمل أثناء القفل

- لا نقرأ ملفات flutter_secure_storage الخام بالتخمين من Kotlin/Swift؛ backend الداخلي للحزمة وتشفيره قد يختلفان.
- `VoiceSessionStore` الأصلي يكون المالك الوحيد لبيانات cold-call المطلوبة؛ نكتب/نقرأ من خلال native APIs آمنة مع migration مرة واحدة من خدمة Dart الحالية بعد login صالح.
- سجل الجلسة وحدة متسقة versioned: accountId، installationId، sessionRevision، voiceDeviceSessionId، controlProof، expiresAtUtc، token association، والحد الأدنى اللازم من auth/refresh حسب العقد.
- migration تحافظ على sessionId/proof؛ لا revoke أو force registration لمجرد نقل التخزين.
- فصل عدم وجود المستخدم عن temporary storage unavailable. عند iOS protected data unavailable قبل أول unlock بعد reboot لا نعيد إنشاء حساب أو نمسح الجلسة.
- iOS Keychain accessibility يختار صراحة للعمل بعد أول unlock أثناء القفل، من دون تحويل جميع أسرار الحساب إلى سياسة أضعف. اختبار جهاز حقيقي تحت lock إلزامي.
- تنسيق refresh بين Dart وNative لمنع rotating refresh token مستعمل مرتين: central arbiter للجلسة الأصلية، وDart AuthRefreshService يفوض إليه عند تمكين المسار الأصلي. لا refresh متزامن مستقل لكل stack.
- تحديث login/logout/token rotation يمر عبر sessionRevision ذرية؛ callback قديمة لا تحفظ credentials لحساب غادر.
- logout ينهي المكالمة محليًا ويمنع late push من تسجيل حساب قديم. server revoke best effort حسب العقد؛ تعذره لا يبقي الصوت مفتوحًا.
- لا انتظار لتسجيل FCM أو إذن الإشعارات للحصول على VoIP token على iOS؛ registration مستقل عن إذن الإشعارات العادية.
- لا logs للـtokens/proof/SDP/ICE/IP/audio/push envelope الخام. قياسات callId تستخدم correlation محدودًا وتخضع لسياسة retention.

## 8. أذونات الميكروفون والإشعارات

### 8.1 بعد أول تأكيد وجبة

الربط بعد نجاح `MealsConfirmedEffect` وبعد إغلاق confirmation sheet الحالية. لا عند save draft ولا عند بدء HTTP ولا عند confirm فاشل.

- يظهر explainer مرة لكل حساب على installation؛ dismiss/defer يسجّل كي لا يظهر مع كل وجبة. حالة الإذن الفعلية device-level وتفحص من النظام.
- لو الإذن granted بالفعل لا نعرض explainer أو system prompt.
- زر التفعيل وحده يستدعي request. «لاحقًا» أو الرفض لا يغيّر نتيجة تأكيد الوجبة.
- لا overlay أثناء مكالمة حية أو شاشة دفع أو navigation غير مستقر.
- العملاء الحاليون يظهر لهم CTA في سياق التوصيل أو التأكيد القادم، دون افتراض أن حدث أول وجبة التاريخي يمكن معرفته من local flag جديد.
- reminder CTA محدود في كارت التوصيل الحالي، وليس modal تلقائيًا متكررًا.

### 8.2 الرد دون إذن

- request ممكن فقط بسياق foreground user action، مع التعامل مع قفل الجهاز والـplatform action timeout.
- iOS لا يمكن تعليق CXAnswerCallAction إلى أجل غير مسمى لانتظار settings/unlock. Android remote callbacks كذلك لها حدود زمنية.
- إذا أمكن عرض permission flow ضمن الفترة القانونية وdeadline الحي نكمل. وإلا نفشل/ننهي attempt بصورة متسقة ونعرض مسار التفعيل بعد فتح التطبيق.
- لا وعد بأن أول رد من شاشة القفل سينجح دون فتح الجهاز، ولا تشغيل downlink-only بصمت وإظهاره كاتصال طبيعي.
- بعد الرجوع من Settings نعيد check؛ إذا المكالمة انتهت لا نستأنفها ولا نرسل answer قديمًا.
- Android one-time permission/auto-reset وiOS restricted/denied/screen-time يتميزوا عن granted. لا request loop أو فتح settings تلقائيًا.

### 8.3 رفض الإشعارات

- iOS PushKit/CallKit مستقل عن إذن alerts العادية، مع احترام Focus/Do Not Disturb والنظام.
- Android FCM data delivery تختلف عن notification display. Telecom/CallStyle exemption يتطلب استيفاء شروط التكامل، ويُختبر على Android 13+.
- رفض full-screen منفصل عن رفض notifications؛ لا إذن overlays ولا battery bypass تلقائي لإجبار الشاشة.
- Android force-stop من Settings وقيود بعض المصنعين ليست مثل swipe من recent apps. لا وعد أن native يتخطى المنع النظامي.
- على iOS نفرق بين suspended/system-terminated وuser force-quit؛ نسجل نتائج التوصيل الحقيقية لكل OS، ولا نعمم ضمانًا من Android.

## 9. خريطة الملفات

المسارات الجديدة أدناه مقترحة داخل المشروع الحالي، ولا تُنشأ قبل مراجعة الموجود عند التنفيذ.

### Flutter — تعديل الموجود

- `lib/features/calling/service/voice_call_manager.dart`: يتحول تدريجيًا إلى facade/read model للـNative؛ لا يشغّل signaling/media القديم على المنصتين بعد cutover.
- `lib/features/calling/service/voice_callkit_service.dart`: إزالة ملكيته لأحداث وعرض المكالمة عند تفعيل المسار الأصلي.
- `lib/features/calling/service/voice_call_signalr_service.dart` و`voice_webrtc_service.dart`: إيقاف initialization في المسار الجديد، ثم إزالة ما صار غير مستخدم بعد تدقيق references والاختبارات.
- `lib/features/calling/presentation/manager/calling_view_model.dart` و`calling_state.dart` و`calling_event.dart`: القراءة من snapshots والتحكم من usecases، إزالة الاعتماد المباشر على Dart WebRTC.
- `lib/features/calling/presentation/screens/incoming_call_screen.dart` و`active_call_screen.dart` ومكونات widgets المتأثرة: واجهة فقط، مصدر واحد للـnavigation.
- `lib/core/services/push_notification_service.dart`: ordinary notifications تبقى؛ voice push/tap لا تعيد إنشاء المكالمة في Dart.
- `lib/core/services/voice_permission_service.dart`: adapter حقيقي للمنصتين؛ إزالة iOS return true.
- `lib/features/calling/data/data_source/voice_device_session_storage.dart`: migration/delegation للمخزن الآمن الأصلي.
- `lib/core/services/token_service.dart` و`auth_refresh_service.dart` ومواضع login/logout الفعلية: تنسيق session مع الـNative بأقل تغيير ممكن واختبارات رجوع.
- `lib/main.dart` و`lib/core/di/di.dart` و`lib/core/network/external_modules.dart`: lifecycle composition للـbridge، دون نقل startup waits إلى مسار المكالمة.
- `lib/features/calendar/presentation/screens/calendar_screen_effects.dart` و`calendar_navigation_coordinator.dart`: trigger explainer بعد نجاح/إغلاق confirmation sheet.
- `lib/features/home/presentation/widgets/home_delivery_card.dart`: reminder CTA فقط إن كان السطح الحقيقي المناسب بعد التحقق؛ لو البيانات تمر من widget آخر يتبع data flow الموجود.
- `lib/core/l10n/app_ar.arb` و`app_en.arb` وأي locale مضاف وقت التنفيذ، وtheme ملفات محددة فقط لو token معتمد مفقود.
- `pubspec.yaml` وlockfile: إزالة الحزم القديمة فقط إذا لم يعد لها مستخدم، دون تحديث بقية الاعتماديات.

### Flutter — ملفات جديدة محددة المسؤولية

```text
lib/features/calling/domain/entities/native_call_snapshot_entity.dart
lib/features/calling/domain/repo/native_voice_repository.dart
lib/features/calling/domain/usecase/answer_native_call_usecase.dart
lib/features/calling/domain/usecase/reject_native_call_usecase.dart
lib/features/calling/domain/usecase/end_native_call_usecase.dart
lib/features/calling/domain/usecase/set_native_call_muted_usecase.dart
lib/features/calling/domain/usecase/set_native_call_audio_route_usecase.dart
lib/features/calling/data/models/response/native_call_snapshot_dto.dart
lib/features/calling/data/mapper/native_call_snapshot_mapper.dart
lib/features/calling/data/data_source/native_voice_data_source.dart
lib/features/calling/data/data_source/native_voice_data_source_impl.dart
lib/features/calling/data/repo/native_voice_repository_impl.dart
lib/core/services/native_voice_session_bridge.dart
lib/features/calling/service/voice_navigation_coordinator.dart
lib/features/calling/presentation/manager/voice_permission_setup_view_model.dart
lib/features/calling/presentation/manager/voice_permission_setup_event.dart
lib/features/calling/presentation/manager/voice_permission_setup_state.dart
lib/features/calling/presentation/widgets/voice_permission_setup_sheet.dart
lib/features/calling/presentation/widgets/voice_permission_required_content.dart
```

Permission DTO/entity/usecase يستعمل الموجود إن وُجد نظير مناسب؛ لا إنشاء wrapper مكرر. بقية enums/value types الصغيرة توضع مع الملف المالك إذا كانت قواعد المشروع تسمح.

### Android

تعديل: `android/app/build.gradle.kts`، و`android/settings.gradle.kts` فقط إن تطلب Compose توافقًا مثبتًا، و`android/app/src/main/AndroidManifest.xml`، و`android/app/src/main/kotlin/kw/mealmate/user2/MainActivity.kt`.

إنشاء تحت `android/app/src/main/kotlin/kw/mealmate/user2/calling/`:

```text
NativeCallCoordinator.kt
CallStateMachine.kt
CallModels.kt
VoiceSessionStore.kt
VoiceApiClient.kt
VoiceSignalingClient.kt
VoiceMediaEngine.kt
TelecomCallController.kt
VoiceMessagingService.kt
VoiceCallService.kt
CallNotificationController.kt
NativeVoiceBridge.kt
NativeVoiceSessionBridge.kt
VoiceDiagnostics.kt
ui/IncomingCallActivity.kt
ui/IncomingCallScreen.kt
ui/ActiveCallScreen.kt
ui/CallTheme.kt
```

Android resources محلية للمكالمات فقط: icons/strings/ringtone/theme tokens المعتمدة، وقواعد backup/storage اللازمة لإبعاد أسرار الجلسة عن backup. أسماء channel IDs الأصلية للإشعارات العادية لا تتغير.

### iOS

تعديل: `ios/Runner/AppDelegate.swift`، `SceneDelegate.swift` عند الحاجة للعرض فقط، `Info.plist`، `Runner.entitlements`، `Runner.xcodeproj/project.pbxproj` وملفات dependency resolution الخاصة بمسار البناء الفعلي.

إنشاء تحت `ios/Runner/Calling/`:

```text
NativeCallCoordinator.swift
CallStateMachine.swift
CallModels.swift
VoiceSessionStore.swift
VoiceApiClient.swift
VoiceSignalingClient.swift
VoiceMediaEngine.swift
CallKitController.swift
VoipPushRegistry.swift
NativeVoiceBridge.swift
NativeVoiceSessionBridge.swift
VoiceDiagnostics.swift
```

موارد localized usage strings/provider icon/ringtone ضمن Runner عند اعتمادها. لا SwiftUI screen مخصصة لشاشة القفل ولا extension جديدة لمجرد استقبال VoIP push.

**ملاحظة بناء:** لم يظهر Podfile committed ضمن شجرة iOS التي تمت مراجعتها. افحص SwiftPM/CocoaPods وFlutter plugin integration الفعليين قبل إضافة binary. لا تنشئ Podfile أو تغيّر استراتيجية البناء تلقائيًا.

### الاختبارات والتوثيق

```text
test/features/calling/native_voice_bridge_test.dart
test/features/calling/native_call_snapshot_mapper_test.dart
test/features/calling/native_calling_view_model_test.dart
test/features/calling/voice_permission_setup_test.dart
test/features/calling/voice_navigation_coordinator_test.dart
test/core/services/native_voice_session_sync_test.dart
test/fixtures/voice_calls_v2/contract_cases.json
test/fixtures/voice_calls_v2/lifecycle_cases.json
android/app/src/test/kotlin/kw/mealmate/user2/calling/CallStateMachineTest.kt
android/app/src/test/kotlin/kw/mealmate/user2/calling/NativeCallCoordinatorTest.kt
android/app/src/test/kotlin/kw/mealmate/user2/calling/VoiceProtocolTest.kt
android/app/src/androidTest/kotlin/kw/mealmate/user2/calling/NativeCallingIntegrationTest.kt
ios/RunnerTests/Calling/CallStateMachineTests.swift
ios/RunnerTests/Calling/NativeCallCoordinatorTests.swift
ios/RunnerTests/Calling/VoiceProtocolTests.swift
integration_test/user_native_calling_test.dart
docs/superpowers/verification/2026-10-20-user-native-calling-results.md
```

اختبار flutter integration لا يحل محل اختبار push/cold-start حقيقي، لأنه يبدأ Flutter أصلًا.

## 10. قرارات dependencies والتوافق قبل البدء

- Core-Telecom ومكتبات Compose dependencies أصلية مطلوبة لهذا التصميم، لكنها ليست مثبتة بعد. اختبر minimum OS والـSDK/AGP/Kotlin compatibility وأثبت resolved versions في lock/resolution report.
- المرجع الحالي من Microsoft لـSwift SignalR يتطلب iOS ≥14 وSwift ≥5.10؛ المشروع يستهدف iOS 13. لا ترفع deployment target لتجاوز الخطأ. قيّم client بديل يدعم 13 بعقد hub نفسه، أو اطلب قرارًا صريحًا لرفع minimum؛ السيناريو يتوقف حتى الحسم.
- Android SignalR Java client متاح رسميًا؛ اختبر reconnect/rebind/auth behavior الفعلي بدل افتراض مطابقته لـsignalr_netcore.
- WebRTC Native distribution يجب أن يطابق artifact المستخدم في الإصدار المقفول من flutter_webrtc، أو يستبدله بعد إزالة القديم. لا إدراج اثنين من WebRTC.framework/AAR. اختبار dependency tree وrelease link إلزامي.
- لا نعتمد native internals الخاصة بالـFlutter plugin كواجهة عامة مستقرة، ولا ننشئ Flutter engine فقط كي نصل لملف WebRTC.
- إذا تم إبقاء flutter_webrtc مؤقتًا لأجل ربط binaries، لا يستدعى API الخاص به ولا يهيئ plugin audio side effects؛ يثبت ذلك بالاختبار، ثم يزول coupling قبل إعلان الاستقلال النهائي.
- public docs الحالية لا تثبت versions التي يستخدمها hotfix المقفول؛ المصدر من package cache/lock/build resolution هو دليل التنفيذ.

## 11. خطوات التنفيذ وبوابات التسليم

كل مهمة: اختبار سلوك يفشل أولًا → إثبات الفشل المتوقع → تنفيذ الحد الأدنى → إعادة الاختبار → مراجعة diff → commit محلي مركز داخل فرع التنفيذ. لا push/merge ضمن الخطة.

### Task 0 — تثبيت المرجع وجمع baseline

**Files:** هذه الخطة، ملف نتائج التحقق، كل ملفات calling الحالية للقراءة. لا تعديل product source في هذه المهمة.

**Consumes:** برانش المكالمات والمرجع أعلاه. **Produces:** baseline موثق وبيئة تنفيذ معزولة مشتقة من feature branch.

- [ ] افحص working tree وAGENTS والقواعد وقت التنفيذ؛ سجل تغييرات المستخدم ولا تكتب فوقها.
- [ ] أنشئ workspace/worktree من برانش المكالمات وفق using-git-worktrees، ثم سجل HEAD؛ إذا تغير عن المرجع أعد مراجعة الأجزاء المتأثرة.
- [ ] شغّل flutter analyze وflutter test قبل أي تعديل وسجّل الأعطال السابقة منفصلة.
- [ ] ابنِ Android baseline واقرأ merged manifest وnamespace والـlaunch Activity الفعلية.
- [ ] على Mac/Xcode، ابنِ iOS baseline وسجّل scheme/OS deployment/dependency manager/signing/device availability.
- [ ] على أجهزة حقيقية قِس: push received، tap answer، answer sent/ack، hub bound، media connected. لا logs أسرار.
- [ ] سجل كل أمر وexit code. لا تعتبر emulator دليلًا لجودة audio أو iPhone terminated delivery.

```powershell
git status --short
git rev-parse HEAD
flutter --version
flutter analyze
flutter test
flutter build apk --debug
```

**Gate:** baseline ووسيلة تشغيل Android وMac/iPhone موثقان؛ أي غياب يمنع اعتماد اختبارات المنصة المتأثرة، لا يمنع كتابة الكود المستقل.

### Task 1 — تثبيت protocol fixtures وقرارات التصميم المعتمدة

**Files:** `test/fixtures/voice_calls_v2/contract_cases.json`، `lifecycle_cases.json`، ملف نتائج التحقق. قراءة NetworkConstants/ApiServices/DTOs/SignalR والخدمات.

**Produces:** fixtures موحدة للمنصتين، وسجل contract/dependencies/Figma gates.

- [ ] اجمع payload دعوة Android حقيقية sanitized، وVoIP payload حقيقية مع APNs topic/environment، وREST snapshots وhub envelopes.
- [ ] اختبر answer بدون hub ومع hub على حساب اختبار وفي بيئة مصرح بها؛ سجل الاستجابة الفعلية دون افتراض نتيجة.
- [ ] تحقق من offer replay/deadlines/ICE-before-answer/refresh/errors ومهلة action في كل منصة.
- [ ] عيّن mapping Figma → Flutter/Compose tokens والنصوص قبل أي UI implementation؛ العنصر غير المتاح يسجل blocked، ولا يخمّن.
- [ ] ثبّت نسخ dependencies بقرار توافق موثق، خاصة iOS13 وWebRTC binary uniqueness وCompose/AGP9.
- [ ] أنشئ canonical fixtures للسلوك التالي:

```json
[
  {"case":"duplicate_push_hub", "input":["ringing_a_seq1","ringing_a_seq1"], "expected":{"platformCalls":1,"answerRequests":0}},
  {"case":"answer_twice", "input":["ringing_a_seq1","answer_req1","answer_req1"], "expected":{"answerRequests":1}},
  {"case":"terminal_then_old_ringing", "input":["ended_a_seq4","ringing_a_seq1"], "expected":{"phase":"ended","platformCallsCreatedAfterEnd":0}},
  {"case":"old_callback_after_new_call", "input":["end_a","ring_b","media_ready_a"], "expected":{"callId":"b","phase":"ringing"}},
  {"case":"server_answer_rejected", "input":["ringing_a_seq1","answer_req1","answer_http409_terminal"], "expected":{"phase":"ended","microphoneOpen":false}}
]
```

الـfixture IDs أعلاه معرفة داخل harness كأحداث محددة بـcallId وsequence وclock؛ يعاد ترميزها للـDTOs الفعلية قبل استخدامها. لا ترسلها للسيرفر.

**Gate:** لا unknown contract مستتر في السلوك؛ بند غير مثبت يسجل dependency مستقلة مع السيناريو المتأثر.

### Task 2 — بناء الحالة والـbridge واختبارات ترتيب الأحداث

**Files:** ملفات DTO/entity/mapper/data source/repository/usecases المذكورة في §9، `NativeVoiceBridge` على المنصتين، اختبارات Dart والـstate machine.

**Consumes:** schemaVersion 1 وfixtures. **Produces:** نفس snapshot/commands/error codes في Kotlin/Swift/Dart.

- [ ] اكتب اختبارات mapper لحقول ناقصة/null وأنواع غلط وschema غير مدعوم، ورفض command لـcallId قديم.
- [ ] اكتب اختبار event revision أحدث يصل قبل نتيجة getSnapshot؛ يجب ألا يرجع العرض لحالة أقدم.
- [ ] اختبر disconnect/reconnect للـEventChannel ووصول terminal event وقت Flutter غير شغال.
- [ ] نفّذ MethodChannel/EventChannel على serialized coordinator، وmock platform side في Dart tests.
- [ ] أضف usecases وإرجاع ApiResult للعمليات، مع error mapping للـCore Failure، وconstructor injection.
- [ ] نفّذ state machine قبل networking باستعمال effects قابلة للعد في الاختبارات.
- [ ] أعد الاختبارات ونفّذ generation ثم analyzer؛ لا تعدّل ملفات generated يدويًا.

مثال اختبار Dart مطلوب بعد تعريف DTO/mapper بالحقول السابقة:

```dart
test('null callId with idle is valid, malformed active is rejected', () {
  final idle = NativeCallSnapshotDto.fromJson({
    'schemaVersion': 1, 'engineInstanceId': 'e',
    'revision': 1, 'phase': 'idle', 'callId': null,
  });
  expect(idle.toEntity().callId, isNull);
  final invalid = NativeCallSnapshotDto.fromJson({
    'schemaVersion': 1, 'engineInstanceId': 'e',
    'revision': 2, 'phase': 'connected', 'callId': null,
  });
  expect(() => invalid.toEntity(), throwsFormatException);
});
```

**Gate:** السباقات السابقة تعبر بلا audio/network حقيقيين، وبدون اعتماد على Navigator.

### Task 3 — المخزن الآمن وتناسق الحساب وrefresh

**Files:** VoiceSessionStore على المنصتين، `voice_device_session_storage.dart`، TokenService/AuthRefreshService ومواضع login/logout ذات الصلة، `native_voice_session_sync_test.dart`، اختبارات native storage.

**Consumes:** sessionRevision وهوية الحساب وsession/proof الحالية. **Produces:** جلسة native قابلة للاستخدام أثناء القفل بدون Flutter.

- [ ] اختبر migration يحافظ على نفس deviceSessionId/proof ويظل idempotent بعد إعادة فتح التطبيق.
- [ ] اختبر logout أثناء refresh: complete القديم لا يعيد حسابًا أو proof أو صوتًا.
- [ ] اختبر Dart وNative يطلبان refresh معًا؛ refresh واحد فعلي ومشاركة نتيجة آمنة.
- [ ] نفّذ internal session bridge المحدد في §4.4، واختبر compare-and-set وعدم ظهور أسراره في diagnostics أو EventChannel.
- [ ] نفّذ secure native store atomically، واستخدم central refresh arbitration عند تمكين المسار الأصلي.
- [ ] عدّل registration/token sync بحيث لا يعيد force-register أثناء مكالمة إلا إذا العقد يضمن ثبات الملكية.
- [ ] نفّذ login/logout/relogin/account switch وFCM/VoIP token rotation.
- [ ] اختبر iOS locked after first unlock، وstorage unavailable قبل أول unlock؛ واختبر migration من نسخة التطبيق الحالية على جهاز حقيقي.

```text
Given: sessionRevision=10, refresh request started.
When: logout commits revision=11, then old refresh succeeds.
Expect: session remains empty at revision=11; no hub connect, no session save.
```

**Gate:** لا sessions/accounts متعارضة، ولا إعادة كتابة أسرار بعد logout. بقية تسجيل الدخول والتذكر والبصمة تمر باختبار رجوع.

### Task 4 — REST/SignalR الأصليان مع الحفاظ على Voice Calls v2

**Files:** VoiceApiClient/VoiceSignalingClient لكل منصة، VoiceProtocol tests، fixtures؛ لا UI.

**Consumes:** store وcontract fixtures. **Produces:** answer/reconcile/RTC/heartbeat مستقلة عن Dart.

- [ ] اكتب اختبارات serialization للـheaders والمسارات والـrequest/response الفعلية، وUTF-8 limits لا عدد characters.
- [ ] اكتب اختبارات event parsing للـenvelope الموحد والlegacy المطلوب فقط؛ messageId/callId فارغان أو generation غير صالح مرفوضان.
- [ ] نفّذ APIs الحالية فقط، وnetwork config مصدر واحد للبيئة مطابق لـNetworkConstants؛ لا hardcode baseURL آخر داخل coordinator.
- [ ] نفّذ hub listeners قبل start/bind؛ auth يجلب آخر token من المخزن.
- [ ] نفّذ reconnect → rebind → get events afterSequence / snapshot reconcile، ولا تعيد answer لمجرد reconnect.
- [ ] عالج timeout/401/403/404/409 وفق العقد؛ إذا answer response ضاعت بعد قبول السيرفر استعلم عن الحالة قبل إعادة أثر غير idempotent.
- [ ] heartbeat/reports retries محدودة بعمر lifecycle/generation، مع cancellation عند terminal.

```text
Given: server accepted answer, HTTP response lost.
When: client reconciles and sees accepted, winner=currentSession.
Expect: continue media setup once; do not reject or create a second answer attempt.
```

**Gate:** جميع fixtures متطابقة على المنصتين، واختبار sandbox hub يثبت bind/offer/answer/ICE/reconnect.

### Task 5 — Android: استقبال مستقل وTelecom وخدمة المكالمة

**Files:** Android platform files وmanifest وGradle؛ CallNotificationController وVoiceMessagingService وTelecomCallController وVoiceCallService، مع native tests.

**Consumes:** coordinator/session/protocol. **Produces:** وصول/رد/رفض/إنهاء دون Flutter engine.

- [ ] افحص merged manifest وخدمة FirebaseMessaging التابعة لـFlutterFire؛ اختبر dispatcher واحد يمتلك voice messages ويفوض الرسائل العادية لمسارها القائم بالطريقة المدعومة.
- [ ] لا تسجيل خدمتين لـMESSAGING_EVENT مع توقع أن الرسالة ستصل إليهما تلقائيًا؛ لا استدعاء FlutterFire internal API غير موثقة بلا compatibility test.
- [ ] اكتب اختبار routing لرسالة ordinary وvoice وmalformed؛ ordinary تظهر مرة وتُفتح على route الصحيح.
- [ ] نفّذ voice payload parser وإضافة المكالمة للنظام وتنبيهها بسرعة؛ caller image/display lookup لا يمنع العرض.
- [ ] أضف Telecom registration/permissions المطلوبة وCallStyle notification وforeground service types الملائمة. لا تكتف بإضافة permission نصيًا.
- [ ] وجّه notification actions وTelecom callbacks لنفس coordinator مع PendingIntent آمن ومحدد call/lifecycle.
- [ ] افحص full-screen capability رسميًا؛ لا startActivity مباشر غير مسموح من الخلفية، ولا overlays workaround.
- [ ] اجعل foreground notification وservice lifecycle يبدأان ضمن حدود النظام؛ لا تنتظر شبكة لإتمام مطلب system callback.
- [ ] اختبر notifications denied/full-screen denied/channel muted وSIM call موجودة والسماعة.

```text
Given: Flutter engine creation deliberately delayed 15 seconds in a QA-only build.
When: a real high-priority data push arrives, user answers at second 2.
Expect: incoming UI, answer attempt and native media preparation happen before Flutter-ready.
```

**Gate:** فحص log يثبت عدم إنشاء Flutter engine على مسار الرد المطلوب للصوت. fallback الخاص بالإشعارات العادية يعمل دون duplication.

### Task 6 — iOS: PushKit/CallKit وجلسة الصوت الأصلية

**Files:** AppDelegate، Calling/VoipPushRegistry وCallKitController وcoordinator، Info.plist/entitlements، XCTest.

**Consumes:** coordinator/store/protocol. **Produces:** دعوة VoIP ومعالجة call actions مستقلة عن Flutter.

- [ ] اكتب اختبارات push → reportNewIncomingCall وترتيب completion باستخدام fake provider؛ network delayed لا يمنع report.
- [ ] أنشئ provider/registry مبكرًا في application lifecycle، وليس في SceneDelegate أو Flutter bridge initializer فقط.
- [ ] نفّذ token update/invalidation وتسجيل environment الصحيح، دون انتظار notification alert permission.
- [ ] نفّذ stable mapping من callId إلى UUID native، بما فيه duplicate push ونهاية المكالمة.
- [ ] نفّذ CXAnswerCallAction/CXEndCallAction/CXSetMutedCallAction وprovider reset، مع fulfill/fail مرة واحدة وبالحدود الزمنية النظامية.
- [ ] اربط `didActivate` و`didDeactivate` بمحرك الصوت؛ لا تفعّل session يدويًا لمنافسة CallKit.
- [ ] عند الاتصال ينطبق الفرق بين platform action accepted وserver accepted وmedia ready؛ لا انتظار Flutter ولا اعتبار fulfill إثبات صوت.
- [ ] تعامل مع cancellation/stale push مع الالتزام بواجب reporting للـcallback/OS المستخدم؛ لا return قبل report لمجرد local terminal إذا النظام يلزم الإبلاغ، ثم reconcile/end حسب العقد.
- [ ] اختبر Focus وlock وbackground/system termination وصلاحيات mic والـprotected data.
- [ ] افحص توقيع build الفعلي وAPNs development/production؛ لا تغيير entitlements لنسخة release بالتخمين.

```text
Given: PushKit invite while Flutter is not running and display REST takes 8 seconds.
Expect: CallKit reporting occurs before REST completes; VoIP completion called once.
When: user answers and CallKit activates audio session.
Expect: native media can proceed with zero Flutter channel calls.
```

**Gate:** iPhone حقيقي يستقبل عبر APNs actual VoIP token، ولا crash بسبب missed report أو double completion، ولا تبعية للـFlutter engine.

### Task 7 — WebRTC والصوت على المنصتين

**Files:** VoiceMediaEngine وcoordinator/platform audio adapters؛ dependency linkage؛ native media tests.

**Consumes:** ICE config، offer/ICE queues، accepted state، platform audio activation. **Produces:** two-way audio وmute/route/cleanup.

- [ ] اكتب tests لحاجز permission+accept قبل بدء capture، ولـICE-before-offer وlate callbacks وend-during-createPeer.
- [ ] اربط نسخة واحدة من native WebRTC SDK، ثم prove release linkage دون duplicate symbols/classes.
- [ ] أنشئ factory مسبقًا عند دعوة حية؛ لا getUserMedia في Dart، ولا تنقل PeerConnection لFlutter.
- [ ] طبّق SDP answer وICE generation/messageId والـqueue وفق fixtures. لا تفترض أن offer موجود قبل الرد.
- [ ] على Android، Telecom يملك اختيار endpoints؛ لا AudioSwitch/AudioManager route controller آخر ينافسه. تأكد من إعداد WebRTC audio device بما يتوافق مع هذا القرار.
- [ ] على iOS، RTCAudioSession/AVAudioSession يتبع CallKit activation/deactivation. اختبر interruptions/route changes.
- [ ] أرسل connecting/connected reports حسب المعنى الفعلي للعقد. قياس RTP مستمر يساعد التشخيص، وليس شرط وصول speech غير صامت لأن المستخدم قد لا يتكلم.
- [ ] نفّذ mute/unmute، earpiece/speaker، wired/Bluetooth، وانقطاع السماعة، وإغلاق الشاشة.
- [ ] اختبر end أثناء getIceServers/createPeer/setRemoteDescription/sendAnswer/rebind؛ لا موارد تبقى ولا تأثير على المكالمة التالية.
- [ ] اختبر process restart مع snapshot محفوظة active: لا ادعاء peer جاهزة من التخزين، ولا إعادة تشغيل ميكروفون من دون شروط النظام/الإذن/القبول الصالح.

```text
Given: call A ends while createPeer completes asynchronously.
When: callback returns after call B is ringing.
Expect: close only A's newly returned peer; keep B and its notification unchanged.
```

**Gate:** صوت مسموع في الاتجاهين مع remote test endpoint فعلي، لا indicator وحده. identity peer ثابتة عند فتح/إغلاق Flutter.

### Task 8 — شاشات Compose وربط شاشات Flutter

**Files:** Kotlin calling/ui، native Android resources، شاشات/widgets/CallingViewModel وvoice_navigation_coordinator المذكورة في §9، tests UI.

**Consumes:** state snapshots والأوامر، Figma mapping. **Produces:** واجهة متسقة بدون تكرار navigation أو التحكم.

- [ ] اكتب widget tests وCompose UI tests للرد مرتين، connecting، permissionRequired، end، route unavailable، الاسم الطويل وavatar failure.
- [ ] نفّذ شاشات Compose بالتصميم المعتمد وتوكنز/خطوط/موارد محلية؛ لا محاولة تحميل asset من Flutter وقت cold-start.
- [ ] حدّث Flutter ViewModel لاستخدام usecases والـnative state؛ إزالة حقول تقرأ VoiceWebRtcService مباشرة.
- [ ] اجعل source واحدًا للـnavigation حسب snapshot/lifecycle؛ لا route push من manager ومن screen listener في الوقت نفسه.
- [ ] افتتاح Flutter أثناء مكالمة قائمة يطلب snapshot ويعرضها فقط؛ لا answer ولا getUserMedia ولا reconnect إجباري.
- [ ] ظهور Compose وFlutter ينظم بالـpresentation context؛ إغلاق Compose لا ينهي المكالمة، وإغلاق Flutter لا يوقف الخدمة.
- [ ] أصلح ضمن الشاشات المعدلة فقط أي hardcoded strings/colors أو private widgets تخالف قواعد المشروع؛ لا cleanup لباقي UI.
- [ ] اختبر TalkBack/VoiceOver، large text، RTL/LTR، theme، rotation الآمن، والعودة إلى route السابق دون كسر payment/deep link.

```text
Given: native snapshot connected, muted=true, peerIdentity=P1.
When: Flutter attaches, rebuilds, detaches and reattaches.
Expect: mute remains true, peerIdentity=P1, answerRequests remains 1.
```

**Gate:** لا فقد للصوت أو إعادة اتصال بسبب تغيير surface، ولا أزرار تعمل على callId قديم.

### Task 9 — فلو إذن الميكروفون بعد تأكيد الوجبة

**Files:** VoicePermissionService، setup ViewModel/Event/State/widgets، calendar_screen_effects/coordinator، delivery reminder widget، ARB/native localized resources، tests calendar/permission.

**Consumes:** MealsConfirmedEffect بعد نجاح API، system permission state. **Produces:** إذن مجهز قبل أول مكالمة وفشل محترم إذا غاب.

- [ ] اكتب test: confirm failed لا يعرض prompt؛ confirm success يعرض بعد إغلاق confirmation sheet؛ confirm آخر لا يكرره.
- [ ] اكتب test: permission granted لا explainer، defer لا system prompt، denied لا يفشل confirm، settings return يعيد check.
- [ ] نفّذ granted/notDetermined/denied/permanentlyDenied/restricted بفرق المنصتين؛ لا iOS default true.
- [ ] أضف CTA للتفعيل في delivery context الحالي، مع flags scoped إلى account+installation وتحديث system status كل مرة يلزم.
- [ ] نفّذ fallback الرد دون إذن بمهل النظام/السيرفر؛ لا تحجز CXAction أثناء انتظار إعدادات مفتوحة بلا نهاية.
- [ ] ضع كل النصوص في localization المعتمدة؛ رسالة usage في iOS تشرح التحدث مع المندوب، وليست طلب وصول مبهم.
- [ ] اختبر auto-reset/one-time permission ومستخدمًا سحب الإذن من Settings أثناء/قبل المكالمة.

```text
Given: first successful meal confirm, permission notDetermined.
When: confirmation sheet is dismissed, then user chooses Later.
Expect: meal remains confirmed, explainer recorded as shown, microphone not requested/opened.
```

**Gate:** لا تغير في DTO/API تأكيد الوجبة، ولا modal double-stack ولا طلب mic بدون فعل واضح.

### Task 10 — التحويل النهائي وإزالة ازدواجية المسار القديم

**Files:** VoiceCallManager/CallKit/SignalR/WebRTC services، PushNotificationService، main/DI، pubspec فقط إن لزم، اختبارات calling/push الحالية.

**Consumes:** نجاح المهام السابقة على المنصتين. **Produces:** تشغيل موحد production path.

- [ ] قبل cutover اكتب اختبار app bootstrap يثبت native engine only على Android/iOS، واختبار ordinary notifications القديم.
- [ ] أبقِ مسارًا واحدًا لكل تثبيت طوال المكالمة؛ لا toggle من legacy إلى native أثناء مكالمة حية.
- [ ] امنع Dart background handler من showCallkitIncoming أو معالجة voice actions عند تمكين المسار الأصلي.
- [ ] امنع PushNotificationService.initialize/registerCurrentToken من تهيئة legacy manager أو force-register جلسة منافسة.
- [ ] أوقف legacy timers/heartbeat/reports وplugin event subscriptions للمكالمات على المنصتين.
- [ ] audit references قبل إزالة الحزم؛ لا تحذف preview/test helpers أو استخدامًا خارج calling دون بديل.
- [ ] regenerate DI/JSON/localizations، شغّل targeted suite ثم full app suite.
- [ ] افحص APK/IPA وnative dependency tree: provider واحد، WebRTC binary واحدة، manifest services غير متعارضة.
- [ ] راجع diff: كل ملف يتبع بندًا من الخطة؛ أي تعديل غير متعلق يُستبعد دون حذف تغييرات المستخدم.

```text
At steady state per call:
native coordinators = 1
active peers = 1
heartbeat owners = 1
legacy Dart hubs = 0
legacy Dart peers = 0
platform incoming calls for callId = 1
```

**Gate:** السيناريو cold answer يعمل عند تأخير Flutter عمدًا، ثم تُزال أي QA delays من release، مع استمرار ordinary push/login/payment.

### Task 11 — الاختبارات النهائية والأداء والرجوع في تطبيق اليوزر

**Files:** integration/native tests، ملف نتائج التحقق، أي bugfix داخل النطاق أعلاه فقط.

**Produces:** دليل جاهزية أو قائمة واضحة بموانع الإغلاق؛ لا ادعاء اكتمال في غياب iPhone/Mac أو backend capability.

- [ ] شغّل كل المجموعات الآلية في §12 وسجّل النتائج قبل الاختبارات اليدوية.
- [ ] نفّذ المصفوفة §13 على physical Android وiPhone مع الطرف الآخر test endpoint أو تطبيق مندوب قائم دون تعديله.
- [ ] أعد اختبار full user app في §14، مع calls أثناء checkout/auth/deep link حيث يلزم.
- [ ] اجمع الأداء §15 في release/profile بدون debugger attached، وقارنه بالـbaseline.
- [ ] راجع تسريب الميكروفون/الخدمة/peer/timers بعد نهاية المكالمة وبعد logout.
- [ ] أي فشل جديد: reproduce → failing test إن كان ممكنًا → fix → targeted regression. إذا لمس auth/push/media ownership، أعد كذلك بواباتها المتأثرة.
- [ ] أنهِ تقرير §16 واربط commit/build/device/OS بكل دليل. لا تصف blocked/not-run بأنه pass.

## 12. أوامر الاختبارات والبناء

تُشغّل عند التنفيذ في workspace الميزة، وليست أوامر تم تشغيلها على كود جديد أثناء إعداد الخطة.

### Flutter

```powershell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter test test/features/calling
flutter test test/core/services
flutter test test/calendar_confirm_meals_test.dart test/calendar_screen_effects_test.dart
flutter test
flutter analyze
flutter build apk --release
```

`dart format` يطبّق على قائمة ملفات Dart المعدلة فقط؛ لا format شامل يغيّر ملفات غير مطلوبة. `flutter pub get` لا يبرر ترقية lockfile عشوائيًا.

### Android من مجلد android

```powershell
.\gradlew.bat :app:testDebugUnitTest :app:lintDebug
.\gradlew.bat :app:connectedDebugAndroidTest
.\gradlew.bat :app:dependencies --configuration debugRuntimeClasspath
.\gradlew.bat :app:assembleRelease
```

على Mac تستخدم `./gradlew`. تؤكد flavors/variants من المشروع قبل اختيار task بديل. إذا لم تنشأ instrumentation test dependencies/runner بعد، فهي جزء من مهمة الاختبار الأصلية، ولا نسجل غيابها كنجاح.

### iOS على Mac/Xcode

```bash
xcodebuild -list -project ios/Runner.xcodeproj
xcrun simctl list devices available
flutter build ios --release --no-codesign
```

بعد تحديد scheme وdestination الفعليين من الأمر الأول، نفّذ `xcodebuild test` على RunnerTests بمحاكٍ مدعوم، وphysical-device tests لتوصيل VoIP والصوت والتوقيع. استخدم workspace بدل project إذا كان dependency manager الفعلي يولّده. لا نضع UDID أو scheme وهميًا في التقرير.

تحقق Archive موقّع وإرسال APNs production على build داخلي معتمد إن كان مطلوبًا للتسليم؛ نجاح `--no-codesign` وحده لا يثبت إشعارات production.

### اختبارات البرانش الموجودة

`test/features/calling/voice_call_signalr_service_test.dart`، `voice_calls_v2_unit_test.dart`، `calling_view_model_test.dart`، `test/voice_calls_v2_unit_test.dart`، `test/calling_feature_test.dart` تراجع وتحدث لتختبر السلوك الجديد؛ لا حذف tests لأنها تمنع تصرفًا صحيحًا ولا الإبقاء على source-string assertions كبديل لاختبارات سلوك.

## 13. مصفوفة اختبار المكالمات

كل صف يطبّق على كل منصة حيث ينطبق؛ نتيجة منفصلة لكل device/OS/build. محور الاختبار هو سلوك تطبيق اليوزر؛ الطرف الآخر مجرد مصدر دعوة/صوت قائم.

| ID | السيناريو | النتيجة المطلوبة في اليوزر |
|---|---|---|
| C01 | التطبيق مفتوح | MealMate incoming، رد واحد وصوت أصلي |
| C02 | التطبيق background والشاشة مفتوحة | تنبيه مكالمة متوافق مع النظام، actions تعمل |
| C03 | الشاشة مقفولة | Android full-screen إذا مسموح / iOS CallKit؛ الرد لا ينتظر Flutter |
| C04 | العملية أنهى النظام وجودها | وصول دعوة أصلية وإكمال الاتصال دون تشغيل Dart كشرط |
| C05 | swipe من recent apps | اختبار مسجل منفصل لكل OS/OEM؛ لا تعميم النتيجة |
| C06 | Android Force stop / iOS force-quit | توثيق قيود النظام، وعدم بيع وعد باستقبال مضمون |
| C07 | بعد reboot قبل وبعد أول unlock | لا crash/storage corruption؛ سلوك platform موثق |
| C08 | Flutter delayed 15s في QA | native UI/answer/media تعمل قبل ready؛ الأدلة زمنية |
| C09 | accept من notification/Compose/Flutter/سماعة | كلها نفس coordinator وrequest واحد |
| C10 | decline/timeout/caller cancel | توقف الرنين/UI ولا مكالمة شبحية |
| C11 | نهاية من اليوزر | end واحد وتنظيف فوري محلي حتى لو REST بطيء |
| C12 | نهاية عن بعد | إغلاق كل surfaces والميكروفون والnotification |
| C13 | رد مرتين/رد مع cancel في نفس الوقت | لا double peer ولا active وهمي؛ reconcile |
| C14 | duplicate/out-of-order push/hub | sequence صحيح ولا إحياء terminal |
| C15 | offer/ICE قبل readiness أو generation قديم | buffering/ignore محدد بلا crash أو خلط calls |
| C16 | اتصال جديد بعد السابق مباشرة | callbacks القديمة لا تؤثر على الجديد |
| C17 | مكالمة ثانية/قبول من جهاز آخر | احترام busy/winner contract دون قطع الجهاز الفائز |
| C18 | فتح/غلق Flutter أثناء المكالمة | نفس peer/مدة/mute/route؛ لا answer جديد |
| C19 | Wi-Fi، cellular، شبكتان مختلفتان وTURN | صوت في الاتجاهين؛ فشل TURN يظهر واضحًا |
| C20 | تبديل Wi-Fi↔cellular وفقد مؤقت | reconnect ضمن السياسة ثم recovery/fail؛ لا رنين جديد |
| C21 | answer HTTP response ضائعة/409 | reconciliation ولا إعادة قبول عمياء |
| C22 | auth/voice session منتهية | refresh قانوني أو fail واضح، لا loop أو حساب مجهول |
| C23 | logout/account switch أثناء call/refresh | تنظيف ومنع callbacks لحساب قديم |
| C24 | notification permission denied | iOS call route يعمل؛ Android exemption مثبت على الأجهزة المدعومة |
| C25 | full-screen denied/channel muted/Focus | لا إجبار لشاشة أو رنين مخالف لإعداد النظام؛ fallback موثق |
| C26 | mic notDetermined/denied/permanentlyDenied/restricted | permission flow واضح، لا connected صامت |
| C27 | mic revoked/one-time expired | recheck وعدم افتراض true |
| C28 | mute/speaker/wired/Bluetooth/disconnect headset | state تتزامن وتوجيه الصوت صحيح |
| C29 | مكالمة شريحة أو تطبيق اتصال آخر/interruptions | لا استحواذ صوت غير مسموح، pause/end وفق دعمنا |
| C30 | اسم طويل/صورة مفقودة/REST display بطيء | العرض والرد لا يتأخران بسبب المحتوى |
| C31 | عربي/إنجليزي/large text/TalkBack/VoiceOver | labels وترتيب واتجاه قابل للاستخدام |
| C32 | 20 دورة مكالمة متتالية لكل منصة | لا crash/peer/timer/service/microphone leak |
| C33 | دعوة متأخرة بعد انتهاء deadline | لا ringing مستمر لمكالمة انتهت؛ التزام iOS reporting |
| C34 | first meal confirmation permission defer/deny | الوجبة مؤكدة، ولا prompt مع كل وجبة |
| C35 | incoming أثناء permission sheet أو checkout | لا dialogs/routes متراكبة ولا خسارة العملية الأصلية |

التغطية الدنيا للأجهزة: Android حقيقي مرجعي Android 13+ وجهاز Android 14+ من مصنع مختلف، مع محاكٍ لأدنى إصدار مدعوم عند الحاجة؛ iPhone حقيقي على إصدار حالي وآخر مدعوم متاح، وSimulator لاختبارات الـstate/UI. قائمة الـOS الفعلية تحدد بعد dependency gate؛ لا نغيّر الحد الأدنى للتطبيق للحصول على pass.

## 14. رجوع بقية تطبيق اليوزر

المطلوب تغطية رحلة الاستخدام الأساسية بالكامل، وليس ادعاء فحص كل احتمال ممكن. لكل مجموعة: existing automated tests + smoke عملي بالخطوات التالية ونتيجة مكتوبة.

| المجموعة | خطوات التحقق |
|---|---|
| startup/session | fresh install، onboarding، دخول، OTP، remembered/unremembered session، cold relaunch، انتهاء token |
| auth/security | refresh متزامن، logout ثم login بحساب آخر، biometric login إذا مفعّل، لا جلسة مكالمة لحساب سابق |
| home/navigation | فتح tabs والرجوع والبحث، عدم القفز لشاشة call قديمة، route محفوظ بعد إنهاء المكالمة |
| subscriptions | اختيار البرنامج/الباقة/العنوان والدفع/التفعيل بما هو موجود فعليًا؛ لا تغيير state عند رفض mic |
| calendar/meals | تحميل الأيام، اختيار/حفظ/تأكيد الوجبات، تأكيد فاشل، إعادة فتح اليوم، prompt مرة واحدة بعد success |
| family flows | اختيار/مراجعة وجبات الأسرة وتأكيدها إن كانت رحلة منفصلة؛ لا افتراض أن calendar effect يغطيها تلقائيًا |
| addresses | عرض/اختيار/تعديل العنوان وlocation permission؛ لا خلطه بإذن الميكروفون |
| payment/deep links | بدء checkout ثم callback success/fail، return من المتصفح، incoming call في الوسط ثم الرجوع لنفس عملية الدفع |
| ordinary push | foreground/background/terminated، tap وcold-start navigation، token refresh، رفض alerts ثم قبولها لاحقًا |
| notification preferences | حفظ التفضيلات والتأكد من أن voice registration لا يعطل إشعارات الطلبات |
| profile/settings | تغيير اللغة/theme إن مدعوم، الاسم والصورة، permissions/settings return |
| network/errors | offline/timeout/unauthorized؛ Core error widgets الحالية تستمر ولا تتكسر بسبب native error mapping |
| locale/UI | RTL/LTR، جميع locales المفعلة، font scale، accessibility، عدم إعادة بناء الشاشة كاملة مع timer فقط |
| update/install | ترقية نسخة قديمة على نفس الجهاز دون logout مفاجئ، migration session، لا duplicate registration بعد upgrade |

لو ميزة جانبية غير مهيأة بحساب الاختبار، تسجل الحالة blocked مع السبب بدل pass شكلي. bug سابق منفصل لا يُصلح بلا نطاق؛ bug جديد بسبب التغيير يمنع إغلاق المهمة.

## 15. الأداء: ما نقيسه وما لا نعد به

سجل monotonic timestamps محليًا لكل مكالمة:

```text
t_push_received
t_platform_reported
t_incoming_visible        (إن أمكن قياس الظهور الحقيقي)
t_answer_tapped
t_answer_request_sent
t_answer_acknowledged
t_hub_bound
t_peer_ready
t_audio_session_active
t_transport_connected
t_first_inbound_rtp
t_first_outbound_rtp
t_flutter_ready
t_call_cleaned
```

- لا نطرح ساعات جهازين مختلفين لحساب latency دون clock synchronization موثق.
- `t_first_rtp` لا يثبت وحده أن المستخدم سمع؛ يوجد فحص مسموع للاتجاهين، مع silence/DTX في الحسبان.
- نجري 20 محاولة لكل منصة في ظروف موثقة، تشمل 10 cold starts، ونسجل failures مع النجاح لا نستبعدها من الأرقام.
- acceptance هندسي ثابت: call answer/media execution لا تعتمد على `t_flutter_ready`، ويثبت ذلك باختبار تأخير Flutter.
- أهداف قياس أولية، وليست وعودًا: tap-to-local-feedback ≤150ms، tap-to-answer-dispatch ≤300ms عند session جاهزة وعقد يسمح بالقبول المباشر، tap-to-two-way-audio p95 ≤2s على شبكة الاختبار المستقرة مع إذن سابق.
- إذا العقد يفرض bind جديدًا أو الشبكة تمنع تحقيق الهدف، لا نغير العتبة بعد رؤية النتائج؛ نوثق السبب والقياس ويحتاج tradeoff قرارًا صريحًا قبل إعلان تحقيق هدف السرعة.
- لا hardcoded connecting timeout من الخطة. القيمة تأتي من contract gate وتُختبر بclock وهمي؛ زمن client وحده لا يمدد ring deadline على السيرفر.
- لا wakelock/خدمة/ميكروفون بعد cleanup؛ فترة CPU/network في الخمول ترجع baseline.
- رفض permissions وForce stop والاتصال المقطوع تختبر كسلوك failure صحيح، لا كنجاح صوت مطلوب.

## 16. معايير الإغلاق والتقرير المطلوب من المنفّذ

لا يكتب المنفذ «اكتملت» قبل استكمال الآتي:

- [ ] Android cold-call حقيقي دون اعتماد على Flutter مثبت بالقياسات والصوت في الاتجاهين.
- [ ] iPhone PushKit/CallKit/audio الحقيقي مثبت على جهاز موقّع، وليس Simulator فقط.
- [ ] peer واحد وstate owner واحد لكل call، وFlutter attach/detach لا يغير الاتصال.
- [ ] التخلص من كل موارد المكالمة عند end/reject/cancel/timeout/logout.
- [ ] اختبارات race/duplicates/generation/session winner وrefresh/logout ناجحة.
- [ ] الأذونات تعمل على المنصتين، مع فلو الوجبة ورفض/تخطي/Settings/lock.
- [ ] ordinary notifications وauth/calendar/payment regression ناجحة أو baseline failures موثقة بوضوح لا تسببها الميزة.
- [ ] analyzer وunit/widget/native tests وبناء release ناجحان، مع native dependency resolution خالٍ من WebRTC مكرر.
- [ ] Figma/اللغات/RTL/accessibility/rebuild behavior تمت مراجعتها بالأدلة، أو يظل الجانب غير المتحقق غير مكتمل.
- [ ] لا بيانات حساسة في logs أو notifications أو backups ولا API/UI bypass لقواعد المشروع.
- [ ] QA instrumentation delays غير موجودة في release، ولا debug signing يُقدّم على أنه store-ready signing.
- [ ] كل external dependency لازمة للـend-to-end إما مثبتة أو مسجلة blocker تمنع ادعاء الإكمال الكامل.

صيغة التقرير:

```text
Build/commit:
Baseline commit:
Platform/device/OS:
Scenario IDs:
Commands + exit codes:
Automated results:
Manual audible audio results:
Latency samples / p50 / p95 / failures:
Native ownership and Flutter-delay evidence:
Regression results by group:
Known pre-existing failures:
Blocked / NOT RUN with exact reason:
Changed files and why:
Remaining risks / acceptance not met:
```

صيغة حالة كل اختبار واحدة من `PASS / FAIL / BLOCKED / NOT RUN`. «لم أجد أخطاء في القراءة» ليست `PASS` لاختبار جهاز.

## 17. حدود ما يمكن حسمه حاليًا

1. لا تعديل كود في هذه المرحلة. حفظ هذه الوثيقة فقط؛ لا checkout للبرانش ولا تثبيت native dependencies.
2. لا نملك من مراجعة المصدر دليلًا أن دعوة السيرفر الحالية data-only أو أن answer يعمل قبل bind أو أن PushKit backend مكتمل.
3. بيئة إعداد الخطة Windows؛ اختبار Swift/Xcode والتوقيع وصوت iPhone يتطلب Mac وiPhone حقيقيين أثناء التنفيذ.
4. لم يُفحص Figma في جلسة التخطيط؛ لا نقدم مقاسات/ألوان/لقطات بوصفها معتمدة.
5. Native يقلل اعتماد الصوت على بداية Flutter؛ لا يتجاوز قيود النظام أو تأخير الشبكة، ولا يقدم ضمان صفر تأخير.

## 18. مراجع أصلية للتحقق عند التنفيذ

- [Android Core-Telecom: service, callbacks, audio endpoints](https://developer.android.com/develop/connectivity/telecom/voip-app/telecom).
- [Android notification permission: self-managed calling exemption](https://developer.android.com/develop/ui/compose/notifications/notification-permission).
- [Android 14 full-screen intent behavior](https://developer.android.com/about/versions/14/behavior-changes-14).
- [Android foreground service background restrictions](https://developer.android.com/develop/background-work/services/fgs/restrictions-bg-start).
- [Firebase Android background notification/data behavior](https://firebase.google.com/docs/cloud-messaging/android/receive-messages).
- [Firebase Android message priority](https://firebase.google.com/docs/cloud-messaging/android-message-priority).
- [Apple PushKit incoming VoIP handling](https://developer.apple.com/documentation/pushkit/responding-to-voip-notifications-from-pushkit).
- [Apple CallKit audio session activation](https://developer.apple.com/documentation/callkit/cxproviderdelegate/provider(_:didactivate:)).
- [Apple CallKit call update fields](https://developer.apple.com/documentation/callkit/cxcallupdate).
- [Apple protected-resource authorization](https://developer.apple.com/documentation/uikit/requesting-access-to-protected-resources).
- [Microsoft SignalR Swift client requirements](https://learn.microsoft.com/en-us/aspnet/core/signalr/swift-client).
- [Microsoft SignalR Java client](https://learn.microsoft.com/en-us/aspnet/core/signalr/java-client).
- [Android AGP built-in Kotlin migration](https://developer.android.com/build/migrate-to-built-in-kotlin).

المراجع مساعدة لعقود المنصات وليست بديلًا لقراءة إصدارات الحزم المقفولة والكود الحالي وعقد السيرفر الحقيقي.
