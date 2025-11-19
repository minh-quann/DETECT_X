import 'package:detect_x/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';

class ModernTextField extends StatelessWidget{
  final TextEditingController controller;
  final String label;
  final IconData prefixIcon;
  final bool isPassword;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const ModernTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.prefixIcon,
    this.isPassword = false,
    this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context){
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      borderRadius: 16,
      opacity: 0.05,
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: validator,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon:  Icon(prefixIcon, size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
          floatingLabelBehavior: FloatingLabelBehavior.auto
        ),
      ),
    );
  }
}