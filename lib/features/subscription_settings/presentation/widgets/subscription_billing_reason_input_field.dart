import 'package:flutter/material.dart';

class SubscriptionBillingReasonInputField extends StatefulWidget {
  const SubscriptionBillingReasonInputField({
    required this.labelText,
    required this.onChanged,
    super.key,
  });

  final String labelText;
  final ValueChanged<String> onChanged;

  @override
  State<SubscriptionBillingReasonInputField> createState() =>
      _SubscriptionBillingReasonInputFieldState();
}

class _SubscriptionBillingReasonInputFieldState
    extends State<SubscriptionBillingReasonInputField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(labelText: widget.labelText),
      maxLines: 2,
      onChanged: widget.onChanged,
    );
  }
}
