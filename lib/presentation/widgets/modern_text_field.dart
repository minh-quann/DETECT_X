import 'package:flutter/material.dart';

class ModernTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final bool isPassword;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const ModernTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.isPassword = false,
    this.validator,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  State<ModernTextField> createState() => _ModernTextFieldState();
}

class _ModernTextFieldState extends State<ModernTextField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.white;

    final borderColor = isFocused
        ? theme.primaryColor
        : (isDark ? Colors.white.withValues(alpha: 0.2) : Colors.grey[300]!);
    final textColor = isDark ? Colors.white : Colors.black87;
    final iconBgColor = isFocused
        ? theme.primaryColor.withValues(alpha: 0.2)
        : (isDark ? Colors.white.withValues(alpha: 0.15) : Colors.grey[100]!);
    final iconColor = isFocused
        ? theme.primaryColor
        : (isDark ? Colors.white : Colors.grey[600]!);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: borderColor, width: isFocused ? 2 : 1.5),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: theme.primaryColor.withValues(alpha: 0.25),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 4),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(widget.prefixIcon, color: iconColor, size: 20),
          ),
          Expanded(
            child: TextFormField(
              focusNode: _focusNode,
              controller: widget.controller,
              obscureText: widget.isPassword,
              validator: widget.validator,
              keyboardType: widget.keyboardType,
              cursorColor: theme.primaryColor,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: widget.label,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                floatingLabelStyle: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                labelStyle: TextStyle(
                  color: isFocused
                      ? theme.primaryColor
                      : (isDark ? Colors.white70 : Colors.grey[600]!),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                suffixIcon: widget.suffixIcon,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
