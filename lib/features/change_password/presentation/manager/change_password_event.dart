import 'package:meal_meat_user/features/change_password/domain/entities/change_customer_password_request_entity.dart';

sealed class ChangePasswordEvent {
  const ChangePasswordEvent();
}

class SubmitChangePasswordEvent extends ChangePasswordEvent {
  const SubmitChangePasswordEvent(this.request);

  final ChangeCustomerPasswordRequestEntity request;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubmitChangePasswordEvent &&
          runtimeType == other.runtimeType &&
          request == other.request;

  @override
  int get hashCode => request.hashCode;
}

class ClearChangePasswordFeedbackEvent extends ChangePasswordEvent {
  const ClearChangePasswordFeedbackEvent();
}
