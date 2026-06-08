import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';

class DoubleTextField extends StatefulWidget {
  final String labelText;
  final String? errorText;
  final String? supportingText;

  final String topFieldHintText;
  final bool topFieldIsPassword;
  final IconData? topFieldTrailingIcon;
  final VoidCallback? topFieldOnTrailingIconPressed;
  final TextEditingController topFieldController;

  final String bottomFieldHintText;
  final bool bottomFieldIsPassword;
  final IconData? bottomFieldTrailingIcon;
  final VoidCallback? bottomFieldOnTrailingIconPressed;
  final TextEditingController bottomFieldController;

  final ValueChanged<String>? onBottomFieldSubmitted;

  const DoubleTextField({
    super.key,
    required this.labelText,
    required this.topFieldHintText,
    required this.bottomFieldHintText,
    this.errorText,
    this.supportingText,
    this.topFieldIsPassword = false,
    this.topFieldTrailingIcon,
    this.topFieldOnTrailingIconPressed,
    required this.topFieldController,
    this.bottomFieldIsPassword = false,
    this.bottomFieldTrailingIcon,
    this.bottomFieldOnTrailingIconPressed,
    required this.bottomFieldController,
    this.onBottomFieldSubmitted,
  });

  @override
  State<DoubleTextField> createState() => _DoubleTextFieldState();
}

class _DoubleTextFieldState extends State<DoubleTextField> {
  late final FocusNode _topFocusNode;
  late final FocusNode _bottomFocusNode;

  late bool _topObscureText;
  late bool _bottomObscureText;

  @override
  void initState() {
    super.initState();
    _topFocusNode = FocusNode();
    _bottomFocusNode = FocusNode();
    _topObscureText = widget.topFieldIsPassword;
    _bottomObscureText = widget.bottomFieldIsPassword;
  }

  @override
  void dispose() {
    _topFocusNode.dispose();
    _bottomFocusNode.dispose();
    super.dispose();
  }

  OutlineInputBorder _buildOutlineInputBorder({required bool isTop}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.only(
        topLeft: isTop ? Radius.circular(8) : Radius.zero,
        topRight: isTop ? Radius.circular(8) : Radius.zero,
        bottomLeft: isTop ? Radius.zero : Radius.circular(8),
        bottomRight: isTop ? Radius.zero : Radius.circular(8),
      ),
      borderSide: BorderSide(color: context.myColors.neutralLight!, width: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        // Label text
        Text(
          widget.labelText,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: context.myColors.neutralDarkest,
          ),
        ),

        // Stacked text fields
        Column(
          children: [
            // TOP FIELD
            TextField(
              controller: widget.topFieldController,
              focusNode: _topFocusNode,
              obscureText: _topObscureText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.myColors.neutralDarkest,
              ),
              cursorColor: context.myColors.primary,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(_bottomFocusNode);
              },
              decoration: InputDecoration(
                hintText: widget.topFieldHintText,
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.myColors.neutralDark,
                ),
                filled: true,
                fillColor: context.myColors.neutralMidLight,
                contentPadding: const EdgeInsets.all(16),
                enabledBorder: _buildOutlineInputBorder(isTop: true),
                focusedBorder: _buildOutlineInputBorder(isTop: true),
                suffixIcon: widget.topFieldIsPassword
                    ? IconButton(
                        icon: Icon(
                          _topObscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        color: context.myColors.neutralDark,
                        onPressed: () =>
                            setState(() => _topObscureText = !_topObscureText),
                      )
                    : widget.topFieldTrailingIcon != null
                    ? IconButton(
                        icon: Icon(widget.topFieldTrailingIcon),
                        color: context.myColors.neutralDark,
                        onPressed: widget.topFieldOnTrailingIconPressed,
                      )
                    : null,
              ),
            ),

            // BOTTOM FIELD
            Transform.translate(
              offset: const Offset(0, -2),
              child: TextField(
                controller: widget.bottomFieldController,
                focusNode: _bottomFocusNode,
                obscureText: _bottomObscureText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.myColors.neutralDarkest,
                ),
                cursorColor: context.myColors.primary,
                textInputAction: TextInputAction.done,

                onSubmitted: widget.onBottomFieldSubmitted,

                decoration: InputDecoration(
                  hintText: widget.bottomFieldHintText,
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.myColors.neutralDark,
                  ),
                  filled: true,
                  fillColor: context.myColors.neutralMidLight,
                  contentPadding: const EdgeInsets.all(16),
                  enabledBorder: _buildOutlineInputBorder(isTop: false),
                  focusedBorder: _buildOutlineInputBorder(isTop: false),
                  suffixIcon: widget.bottomFieldIsPassword
                      ? IconButton(
                          icon: Icon(
                            _bottomObscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          color: context.myColors.neutralDark,
                          onPressed: () => setState(
                            () => _bottomObscureText = !_bottomObscureText,
                          ),
                        )
                      : widget.bottomFieldTrailingIcon != null
                      ? IconButton(
                          icon: Icon(widget.bottomFieldTrailingIcon),
                          color: context.myColors.neutralDark,
                          onPressed: widget.bottomFieldOnTrailingIconPressed,
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),

        // Error text
        if (widget.errorText != null)
          Text(
            widget.errorText!,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: context.myColors.error),
          ),

        // Supporting text
        if (widget.supportingText != null)
          Text(
            widget.supportingText!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: context.myColors.neutralDarkest,
            ),
          ),
      ],
    );
  }
}
