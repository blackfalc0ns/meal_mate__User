import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meal_meat_user/config/theme/font_manager.dart';
import 'package:meal_meat_user/config/theme/spacing.dart';
import 'package:meal_meat_user/config/theme/styles_manager.dart';
import 'package:meal_meat_user/core/extensions/extensions.dart';

class AuthOtpCodeField extends StatefulWidget {
  const AuthOtpCodeField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  State<AuthOtpCodeField> createState() => _AuthOtpCodeFieldState();
}

class _AuthOtpCodeFieldState extends State<AuthOtpCodeField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _notifyValueChanged() {
    widget.onChanged(_controllers.map((controller) => controller.text).join());
  }

  void _handleChanged(String value, int index) {
    final digits = value.replaceAll(RegExp(r'\D'), '');

    if (digits.length > 1) {
      _fillFrom(index, digits);
      return;
    }

    if (digits.isNotEmpty) {
      _controllers[index].text = digits;
      _moveToNextField(index);
    } else {
      _controllers[index].clear();
      _moveToPreviousField(index);
    }

    _notifyValueChanged();
  }

  void _fillFrom(int startIndex, String digits) {
    var currentIndex = startIndex;

    for (final digit in digits.split('')) {
      if (currentIndex >= _controllers.length) {
        break;
      }
      _controllers[currentIndex].text = digit;
      currentIndex++;
    }

    final focusIndex = currentIndex.clamp(0, _focusNodes.length - 1);
    if (currentIndex >= _focusNodes.length) {
      _focusNodes.last.unfocus();
    } else {
      FocusScope.of(context).requestFocus(_focusNodes[focusIndex]);
    }

    _notifyValueChanged();
  }

  void _moveToNextField(int index) {
    if (index < _focusNodes.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      return;
    }

    _focusNodes[index].unfocus();
  }

  void _moveToPreviousField(int index) {
    if (index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;

    return Row(
      textDirection: TextDirection.ltr,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 44,
          height: 44,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            maxLength: 1,
            style: getBoldStyle(
              fontFamily: FontConstant.alexandria,
              fontSize: FontSize.size24,
              color: color.onSurface,
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: color.surfaceContainerHighest,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Spacing.inputRadius),
                borderSide: BorderSide(color: color.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Spacing.inputRadius),
                borderSide: BorderSide(color: color.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Spacing.inputRadius),
                borderSide: BorderSide(
                  color: color.primary,
                  width: 1.5,
                ),
              ),
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onTap: () => _controllers[index].selection = TextSelection(
              baseOffset: 0,
              extentOffset: _controllers[index].text.length,
            ),
            onChanged: (value) => _handleChanged(value, index),
          ),
        );
      }),
    );
  }
}

