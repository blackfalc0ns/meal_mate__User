# تعديلات Voice Calls v2 — تطبيق العميل فقط

طبّق هذه التعديلات على التنفيذ الحالي داخل ريبو العميل. لا تعِد تنفيذ الخطة القديمة. راجع الموجود أولًا وتجاوز البنود المنفذة بشكل صحيح. حافظ على قواعد المشروع وstructure داخل lib/features/calling وعلى ApiServices وDI وAuth وerror widgets الحالية.

## 1. بيانات شاشة المكالمة

أضف GET /api/v2/voice-calls/{callId}/display باستخدام JWT وAccept-Language: ar أو en؛ لا يحتاج voice-device headers.

الاستجابة:

```json
{
  "callId": "<uuid>",
  "tripStopId": "<uuid>",
  "driverName": "<string>",
  "driverImageUrl": "<relative URL or null>",
  "driverRole": "<localized string>",
  "vehicleType": "<string>",
  "plateNumber": "<string>",
  "deliveryAddress": "<string>",
  "deliveryZone": "<string>",
  "orderCode": "<string>",
  "mealSummary": "<string>",
  "slotLabel": "<string>",
  "boxCount": 1,
  "stopStatus": "PickedUp"
}
```

- أضف nullable Response DTO وMapper وDomain Entity وApiServices method وDataSource/Repository/UseCase وViewModel intent/state حسب conventions الموجودة، بدون DTO في UI.
- حمّل البيانات بعد معرفة callId، ولا تؤخر native call reporting أو الرنين أو الرد حتى وصول HTTP.
- اعرض اسم السواق وصورته والعنوان في شاشة العميل، واستبدل fake data. driverRole مترجم من الباك؛ stopStatus كود يحتاج ترجمة عند عرضه.
- driverImageUrl نسبي؛ resolve عبر base URL الموجود باستخدام URI. null أو فشل الصورة = placeholder الحالي.
- غياب السواق قد ينتج اسمًا فارغًا وصورة null؛ اعرض fallback مترجمًا. deliveryAddress يأتي مع fallback إلى zone من الباك.
- عند تغيير اللغة أعد الطلب بـAccept-Language الجديد. تجاهل responses لحساب أو callId أو لغة لم تعد الحالية، ونظف البيانات عند logout/نهاية المكالمة.
- فشل display لا يمنع الرد ولا ينهي الصوت؛ اعرض fallback. 404 لا يبرر تجربة endpoint أقل أمانًا.
- لا تستخدم live-tracking كبديل؛ فحص ملكيته غير مكتمل حسب الباك. لا رقم هاتف في display.

## 2. تسجيل FCM

PUT /api/v1/customers/me/device-tokens أصبح يرجع HTTP 200:

```json
{"fcmDeviceTokenId":"<guid>"}
```

- احتفظ بالـrequest الحالي؛ عدّل void/204-only إلى DTO دفاعي وmapper وتمرير المعرف لتسجيل المكالمات.
- إعادة نفس FCM token ترجع نفس registry ID؛ يمكن استعادة استجابة ضائعة بإعادة نفس token.
- لا تستخدم raw token أو GUID عشوائي كـfcmDeviceTokenId. افصل التخزين حسب الحساب وامسحه عند logout.
- iOS يحتاج FCM ID للتنظيف وapnsVoipToken للوارد، وكلاهما يُرسل في devices/register.

## 3. إعدادات الربط المؤكدة

- Base URL: https://maelmate.runasp.net؛ استخدم network configuration الحالية.
- Firebase project المتوقع mealmate-bd5b3؛ تحقق من configs الحالية، ولا تضع service account أو مفاتيح APNs في التطبيق.
- Hub: /hubs/voice-call-v2؛ JWT access_token عبر SDK callback، وcontrolProof فقط داخل BindDeviceSession، مع إخفاء token من logs.
- RTC envelope: messageId, callId, negotiationGeneration, senderDeviceSessionId, sentAtUtc, payload. الحد الكلي للحب 400KB، SDP 65536 وICE 4096 UTF-8 bytes.
- ICE URLs وusername/credential من الباك، honor expiry/TTL الفعلي (default 3600 seconds)، بدون TURN secret أو ports hardcoded.
- capabilityVersion لم يُحسم في الرد الجديد: العقد 2 والمثال 1. لا downgrade تلقائيًا عند 403؛ وثّق التعارض.

## 4. تصحيح التعافي والصلاحيات

- 401: استخدم JWT refresh الحالي أولًا. لا تفترض توفر refresh endpoint غير موجود.
- 403: قد يكون رفض صلاحيات أو جهازًا غير فائز أو session منتهية؛ reconcile وصنّف السبب قبل register، ولا تعِد تسجيل كل 403.
- لا تدوّر session أثناء مكالمة قائمة لإعادة answer/end/ICE؛ rotation يبطل التحكم القديم. اتبع الحالة الرسمية ولا تعد المستخدم باستمرار الصوت.
- renewal عند launch/resume عندما يسمح النظام بالتنفيذ، وليس timer خلفية مضمونًا؛ قد لا يصل push لجلسة انتهت.
- لا تستخدم display أو incoming كتصريح لبدء media على جهاز answered-elsewhere.

## 5. المراجعة المطلوبة

- اختبر nullable display، الصور النسبية، تغيير اللغة، response متأخر، fallback، و404/timeout بدون قطع مكالمة.
- اختبر FCM 200/ID، logout/account switching، JWT refresh و403 بدون rotation أعمى.
- شغّل build_runner إذا تغيرت generated models/Retrofit/DI، ثم format وanalyze والاختبارات المناسبة.
- راجع عدم تسريب tokens/proof/phone/address في logs/cache، وعدم تعديل UI أو ملفات غير مرتبطة.
- سلّم تقرير الملفات المعدلة، نتائج checks، وما يحتاج جهازًا حقيقيًا أو تأكيد الباك. لا تدّع نجاح صوت/Push من unit tests.
