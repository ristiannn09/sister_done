import 'package:flutter/material.dart';
import '../core/app_colors.dart';

/// Input berbentuk pill sesuai desain, mendukung mode password (toggle mata).
class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmitted;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.onSubmitted,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure = widget.isPassword;

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(color: color),
      );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onFieldSubmitted: widget.onSubmitted,
      style: const TextStyle(fontSize: 14, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 14),
        filled: true,
        fillColor: AppColors.fieldFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        prefixIcon: Icon(widget.icon, color: AppColors.primary, size: 20),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
        enabledBorder: _border(AppColors.fieldBorder),
        focusedBorder: _border(AppColors.primary),
        errorBorder: _border(AppColors.error),
        focusedErrorBorder: _border(AppColors.error),
      ),
    );
  }
}
