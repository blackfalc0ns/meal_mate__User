# Family Checkout Backend Update Handoff

## الهدف

تحديث فلو الاشتراك العائلي ليتوافق مع عقد الباك الجديد والوصول إلى صفحة Payzah عند اكتمال بيانات الأعضاء المشمولين بالدفع.

## العقد الإجباري

لكل عضو `subscribeNow: true` يجب تنفيذ:

```text
PUT /members/{memberId}/plan
PUT /members/{memberId}/allergies
POST /members/{memberId}/addresses
PUT /members/{memberId}/start-date
PUT /members/{memberId}/checkout-selection
```

استخدم `memberId` الحقيقي في كل طلب.

### start-date

```http
PUT /api/v1/customer/family-subscription-flow/members/{memberId}/start-date
```

```json
{ "startDate": "2026-10-20" }
```

احفظ التاريخ عند اختياره، وانتظر نجاح الطلب، ثم أعد قراءة summary لنفس العضو.

## payloads

الحساسية فقط:

```json
{ "selectedCodes": ["MILK", "EGG"] }
```

أو:

```json
{ "selectedCodes": ["NONE"] }
```

المكونات غير المفضلة فقط:

```json
{ "ingredientCodes": ["INGREDIENT:<guid>"] }
```

أو:

```json
{ "ingredientCodes": ["NONE"] }
```

النظام الغذائي فقط:

```json
{ "dietaryPreferenceCodes": ["KETO"] }
```

أو:

```json
{ "dietaryPreferenceCodes": ["NONE"] }
```

لا تخلط الحقول بين endpointات.

## اختيار الأعضاء للدفع

أضف اختيارًا واضحًا لكل عضو في شاشة الدفع:

```http
PUT /members/{memberId}/checkout-selection
```

```json
{ "subscribeNow": true }
```

- اعتمد على `participantCount` وليس `rosterCount`.
- باقة Small تحتاج عضوين على الأقل.
- لا تحدد عضوًا `InProgress` تلقائيًا.
- بعد التغيير نفذ PUT ثم GET summary.

## checkout

أضف إلى request DTO:

```json
"clientContractVersion": 1
```

ويجب إرسال:

```json
{
  "callbackUrl": "...",
  "errorUrl": "...",
  "paymentMethodId": 3,
  "clientContractVersion": 1,
  "idempotencyKey": "...",
  "batchId": "<آخر summary>",
  "batchVersion": "<آخر summary>"
}
```

إذا ظهر `family.quote_changed`، أعد summary ثم أعد الطلب.

## summary وmemberSchedules

أضف `memberSchedules[]` إلى models واستخدمه في شاشة المراجعة بدل الحساب المحلي:

```text
memberId
paymentDate
firstDeliveryDate
endDate
deliveryDaysCount
mealsPerDay
totalMeals
restaurants[]
```

## أسباب منع الدفع

ادعم التوجيه التالي:

```text
family.min_members          اختيار أعضاء دفع إضافيين
family.start_date_required  شاشة اختيار تاريخ البداية
family.address_required     شاشة العنوان
family.allergies_required   شاشة الحساسية
family.checkout_no_selection اختيار أعضاء الدفع
family.client_update_required إضافة clientContractVersion: 1
family.quote_changed        إعادة summary
restaurant.not_eligible     مراجعة البرنامج/المنطقة
```

## الاختبار

استخدم برنامج `Weight Loss`؛ محتواه مربوط بالكامل. تجنب `Athletic` و`Keto` مؤقتًا لأن الباك أعلن أن المطاعم/الوجبات غير مؤهلة لهما حاليًا.

اختبر:

1. حفظ `NONE` للحساسية.
2. عدم إرسال payload مختلط.
3. حفظ وتعديل start-date بنفس `memberId`.
4. تحديد عضوين وارتفاع `participantCount` إلى 2.
5. منع الدفع عند وجود عضو واحد.
6. إرسال `clientContractVersion: 1` و`batchId` و`batchVersion`.
7. التعامل مع أخطاء start date وquote وrestaurant eligibility.
8. عدم استخدام `managerId`.

## التسلسل النهائي

```text
PUT plan
→ PUT allergies
→ POST address
→ PUT start-date
→ PUT checkout-selection
→ GET summary
→ GET payment-methods
→ POST checkout
```

## معيار الإغلاق

```text
canCheckout: true
participantCount >= effectiveFamilyPackageMinMembers
clientContractVersion: 1
batchId موجود
batchVersion موجود
```

ويتم فتح صفحة Payzah بنجاح.
