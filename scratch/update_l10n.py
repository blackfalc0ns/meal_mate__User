import json

def insert_keys_in_arb(file_path, new_keys):
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    target_idx = -1
    for idx, line in enumerate(lines):
        if '"meal_details_optional_notes_title":' in line:
            target_idx = idx
            break

    if target_idx == -1:
        print(f"Target not found in {file_path}")
        return

    new_lines = []
    for k, v in new_keys.items():
        escaped_v = json.dumps(v, ensure_ascii=False)
        new_lines.append(f'  "{k}": {escaped_v},\n')

    lines[target_idx:target_idx] = new_lines

    with open(file_path, 'w', encoding='utf-8', newline='') as f:
        f.writelines(lines)
    print(f"Updated {file_path}")

ar_keys = {
    "calendar_confirm_meals": "تأكيد الوجبات",
    "calendar_confirm_selections": "تأكيد الاختيارات",
    "calendar_confirm_selection_header": "تأكيد اختيار الوجبات",
    "calendar_confirm_meals_success": "تم إرسال الوجبات للمطعم للمراجعة",
    "calendar_confirmed_sheet_title": "تم تأكيد الوجبات",
    "calendar_confirmed_sheet_subtitle": "تم حفظ اختياراتك بنجاح وسيتم تجهيز وجباتك لليوم المحدد",
    "calendar_confirmed_sheet_status_label": "الحالة",
    "calendar_status_awaiting_restaurant": "في انتظار تأكيد المطعم",
    "calendar_confirmed_sheet_note": "يمكنك تعديل الوجبات قبل موعد الإغلاق اليومي",
    "calendar_confirmed_sheet_back_to_calendar": "العودة للتقويم",
    "calendar_confirmed_sheet_view_meals": "عرض الوجبات",
    "calendar_error_box_incomplete": "يرجى اختيار كل الوجبات المطلوبة أولاً",
    "calendar_error_selection_locked": "تم قفل هذا اليوم ولم يعد قابلاً للتعديل",
    "calendar_error_day_unavailable": "هذا اليوم غير متاح حالياً",
    "calendar_error_fulfillment_not_ready": "الاشتراك غير جاهز حالياً، يرجى إعادة المحاولة لاحقاً"
}

en_keys = {
    "calendar_confirm_meals": "Confirm Meals",
    "calendar_confirm_selections": "Confirm Selections",
    "calendar_confirm_selection_header": "Confirm Meal Selection",
    "calendar_confirm_meals_success": "Meals sent to the restaurant for review",
    "calendar_confirmed_sheet_title": "Meals Confirmed",
    "calendar_confirmed_sheet_subtitle": "Your selections have been saved successfully and meals will be prepared for the selected day.",
    "calendar_confirmed_sheet_status_label": "Status",
    "calendar_status_awaiting_restaurant": "Awaiting Restaurant Confirmation",
    "calendar_confirmed_sheet_note": "You can edit meals before the daily cutoff time.",
    "calendar_confirmed_sheet_back_to_calendar": "Back to Calendar",
    "calendar_confirmed_sheet_view_meals": "View Meals",
    "calendar_error_box_incomplete": "Please select all required meals first",
    "calendar_error_selection_locked": "This day is locked and can no longer be edited",
    "calendar_error_day_unavailable": "This day is currently unavailable",
    "calendar_error_fulfillment_not_ready": "Subscription is not ready yet, please try again later"
}

insert_keys_in_arb('lib/core/l10n/app_ar.arb', ar_keys)
insert_keys_in_arb('lib/core/l10n/app_en.arb', en_keys)
