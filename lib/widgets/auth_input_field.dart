import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class AuthInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? Function(String?)? validator;
  final bool obscureText;
  final VoidCallback? onToggleVisibility;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;
  final Widget? prefixIcon;

  const AuthInputField({
    super.key,
    this.controller,
    required this.label,
    this.validator,
    this.obscureText = false,
    this.onToggleVisibility,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.enabled = true,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: InputFieldTheme.width,
      height: InputFieldTheme.height,
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onFieldSubmitted: onFieldSubmitted,
        enabled: enabled,
        style: const TextStyle(color: InputFieldTheme.textColor),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: AppTheme.withOpacity(InputFieldTheme.labelColor, InputFieldTheme.labelOpacity)),
          prefixIcon:
              prefixIcon != null
                  ? IconTheme(
                    data: IconThemeData(
                      color: AppTheme.withOpacity(InputFieldTheme.iconColor, InputFieldTheme.iconOpacity),
                    ),
                    child: prefixIcon!,
                  )
                  : null,
          suffixIcon:
              onToggleVisibility != null
                  ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppTheme.withOpacity(InputFieldTheme.iconColor, InputFieldTheme.iconOpacity),
                    ),
                    onPressed: onToggleVisibility,
                  )
                  : null,
          filled: true,
          fillColor: PrimaryButtonTheme.foregroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(InputFieldTheme.borderRadius),
            borderSide: BorderSide(color: InputFieldTheme.enabledBorderColor, width: InputFieldTheme.borderWidth),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(InputFieldTheme.borderRadius),
            borderSide: BorderSide(color: InputFieldTheme.enabledBorderColor, width: InputFieldTheme.borderWidth),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(InputFieldTheme.borderRadius),
            borderSide: const BorderSide(
              color: InputFieldTheme.focusedBorderColor,
              width: InputFieldTheme.focusedBorderWidth,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(InputFieldTheme.borderRadius),
            borderSide: const BorderSide(color: InputFieldTheme.errorBorderColor, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(InputFieldTheme.borderRadius),
            borderSide: const BorderSide(
              color: InputFieldTheme.errorBorderColor,
              width: InputFieldTheme.errorBorderWidth,
            ),
          ),
          contentPadding: InputFieldTheme.contentPadding,
          errorStyle: const TextStyle(color: InputFieldTheme.errorTextColor),
        ),
      ),
    );
  }
}
