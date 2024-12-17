import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController textController;
  final String hintText;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final bool isObsecure;
  final VoidCallback? onLeftIconPressed;
  final VoidCallback? onRightIconPressed;

  const AppTextField({
    super.key,
    required this.hintText,
    this.isObsecure = false,
    this.leftIcon,
    this.rightIcon,
    required this.textController,
    this.onLeftIconPressed,
    this.onRightIconPressed,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        right: 20,
        left: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 3,
            offset: const Offset(2, 1),
            color: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
      child: TextField(
        obscureText: widget.isObsecure,
        controller: widget.textController,
        decoration: InputDecoration(
          hintText: widget.hintText,
          prefixIcon: InkWell(
            onTap: () {
              if (widget.onLeftIconPressed != null) {
                widget.onLeftIconPressed!();
              }
            },
            child: Icon(
              widget.leftIcon,
              color: const Color.fromARGB(255, 12, 29, 84),
            ),
          ),
          suffixIcon: InkWell(
            onTap: () {
              if (widget.onRightIconPressed != null) {
                widget.onRightIconPressed!();
              }
            },
            child: Icon(
              widget.rightIcon,
              color: const Color.fromARGB(255, 12, 29, 84),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}