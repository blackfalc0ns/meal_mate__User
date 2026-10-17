# Dietary Preferences Backend Issue

## المشكلة

عند حفظ تفضيلات الأكل للعضو، request الحفظ يرجع نجاحًا، لكن بيانات الـ summary/current flow لا تعكس الحفظ.

## Request الحفظ

```http
PUT /api/v1/customer/family-subscription-flow/members/6246f972-5e50-464e-87c6-005f4de26c7b/dietary
```

الـ response:

```text
Status: 200 OK
response: true
```

المستخدم اختار: **آكل كل شيء**.

## Response الحالي في summary/current flow

```json
{
  "dietaryPreferences": [],
  "dietaryCompleted": false,
  "hasNoDietaryRestriction": false,
  "selectedDietaryOptionCodes": []
}
```

هذا يعني أن الـ summary ما زال يعتبر أن التفضيلات لم يتم اختيارها، رغم نجاح request الحفظ.

## المقارنة مع الحساسية

حفظ الحساسية يظهر بشكل صحيح:

```json
{
  "allergies": [],
  "allergiesCompleted": true,
  "hasNoAllergies": true,
  "selectedAllergyOptionCodes": ["NO_ALLERGIES"]
}
```

## المطلوب مراجعته في الـ backend

1. التأكد من حفظ request الخاص بالـ dietary فعليًا.
2. التأكد من أن اختيار “آكل كل شيء” يُرسل ويُحفظ كالتالي:

```json
{
  "dietaryPreferenceCodes": ["NONE"]
}
```

3. تحديث القيم التالية بعد الحفظ:

```json
{
  "dietaryCompleted": true,
  "hasNoDietaryRestriction": true,
  "selectedDietaryOptionCodes": ["NONE"]
}
```

4. مراجعة هل القيمة الصحيحة لعدم وجود قيود هي `NONE` أم code مختلف.
5. التأكد أن endpoint summary/current flow يستخدم نفس `memberId`.
6. التأكد من عدم إرجاع بيانات قديمة من cache.
7. مراجعة mapping بين جدول/حقل dietary وبين حقول summary.

## الخلاصة

الـ dietary save endpoint يرجع نجاحًا، لكن summary/current flow يرجع أن التفضيلات غير مكتملة. المطلوب تتبع عملية الحفظ والقراءة لنفس العضو، لأن المشكلة تبدو في persistence أو mapping أو cache داخل الـ backend.
