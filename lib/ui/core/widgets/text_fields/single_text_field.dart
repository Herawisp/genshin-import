import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';

class SingleTextField extends StatefulWidget {
  final String? labelText;
  final String hintText;
  final String? errorText;
  final String? supportingText;
  final bool isPassword;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingIconPressed;
  final TextEditingController controller;

  const SingleTextField({
    super.key,
    required this.hintText,
    this.labelText,
    this.errorText,
    this.supportingText,
    this.isPassword = false,
    this.trailingIcon,
    this.onTrailingIconPressed,
    required this.controller,
  });

  @override
  State<SingleTextField> createState() => _SingleTextFieldState();
}

/* ======================================================================================= */
/* ======================================================================================= */

class _SingleTextFieldState extends State<SingleTextField> {

  // late FocusNode _focusNode;
  late bool _obscureText = widget.isPassword;

  /* ================================================================================== */
  @override
  void initState() {
    super.initState();
    // _focusNode = FocusNode();
    // _focusNode.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    // _focusNode.dispose();
    super.dispose();
  }

  /* ================================================================================== */
  Widget? _buildSuffixIcon(BuildContext context) {
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        color: context.myColors.neutralDark,
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    
    if (widget.trailingIcon != null) {
      return IconButton(
        icon: Icon(widget.trailingIcon),
        color: context.myColors.neutralDark,
        onPressed: widget.onTrailingIconPressed,
      );
    }

    return null;
  }

  /* ================================================================================== */
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,

      children: [

        // Label text
        if (widget.labelText != null)
        Text(
          widget.labelText!,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: context.myColors.neutralDarkest
          ),
        ),

        // Text field
        TextField(
          controller: widget.controller,
          // focusNode: _focusNode,
          obscureText: _obscureText,

          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.myColors.neutralDarkest
          ),

          cursorColor: context.myColors.primary,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.myColors.neutralDark
            ),

            filled: true,
            fillColor: context.myColors.neutralMidLight,

            contentPadding: const EdgeInsets.all(16),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.myColors.neutralLight!,
                width: 2,
              )
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.myColors.neutralLight!,
                width: 2,
              )
            ),

            suffixIcon: _buildSuffixIcon(context)
          ),
        ),

        // Error text
        if (widget.errorText != null)
        Text(
          widget.errorText!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.myColors.error
          ),
        ),

        // Supporting text
        if (widget.supportingText != null)
        Text(
          widget.supportingText!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.myColors.neutralDarkest
          ),
        ),
      ],
    );
  }
}