import 'package:flutter/material.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/features/auth/presentation/widgets/auth_terms_row.dart';

class AuthTermsSection extends StatefulWidget {
  const AuthTermsSection({
    super.key,
    required this.label,
    this.initialValue = false,
    this.onChanged,
  });

  final String label;
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  @override
  State<AuthTermsSection> createState() => _AuthTermsSectionState();
}

class _AuthTermsSectionState extends State<AuthTermsSection> {
  late bool _accepted;

  @override
  void initState() {
    super.initState();
    _accepted = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: Spacing.sm),
        AuthTermsRow(
          value: _accepted,
          onChanged: (value) {
            setState(() {
              _accepted = value ?? false;
            });
            widget.onChanged?.call(_accepted);
          },
          label: widget.label,
        ),
      ],
    );
  }
}
