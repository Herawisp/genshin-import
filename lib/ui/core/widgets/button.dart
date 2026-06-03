import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';

enum ButtonVariant { 
  primary, neutral, error
}

class CustomButton extends StatefulWidget {
  final String label;
  final Future<void> Function()? onPressed;
  final ButtonVariant variant;
  final bool oneShot;
  final bool outlined;
  final Widget? icon;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.oneShot = false,
    this.outlined = false,
    this.icon,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

/* =================================================================================================== */
/* =================================================================================================== */

class _CustomButtonState extends State<CustomButton> {
  
  /* ================================================================================================= */
  final WidgetStatesController _controller = WidgetStatesController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleStateChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleStateChange);
    _controller.dispose();
    super.dispose();
  }

  void _handleStateChange() {
    if (!mounted) return;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  /* ================================================================================================= */
  (Color, Color, Color) _getButtonColors(BuildContext context) {
    switch (widget.variant) {
      case ButtonVariant.primary:
        return (context.myColors.primary!, context.myColors.primaryVariant!, context.myColors.neutralLightest!);
      case ButtonVariant.neutral:
        return (context.myColors.neutralLightest!, context.myColors.neutralLight!, context.myColors.primary!);
      case ButtonVariant.error:
        return (context.myColors.error!, context.myColors.errorVariant!, context.myColors.neutralLightest!);
    }
  }

  /* ================================================================================================= */
  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null || _isLoading;
    final (buttonColor, shadowColor, textColor) = _getButtonColors(context);

    final isPressed = _controller.value.contains(WidgetState.pressed);
    final visuallyPressed = isPressed || _isLoading;

    const double buttonHeight = 50.0;
    const double depth = 4.0;

    return SizedBox(
      height: buttonHeight + depth,
      width: double.infinity,

      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,

            // THE SHADOW PART
            child: Container(
              height: buttonHeight,
              decoration: BoxDecoration(
                color: isDisabled ? Colors.transparent : shadowColor,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 60),
            top: visuallyPressed ? depth : 0,
            left: 0,
            right: 0,
            
            // THE TOP BUTTON PART
            child: SizedBox(
              height: buttonHeight,

              child: FilledButton(
                statesController: _controller,
                onPressed: isDisabled ? null : _handlePress,

                style: FilledButton.styleFrom(
                  backgroundColor: isDisabled ? context.myColors.neutralLight : buttonColor,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: widget.outlined ? BorderSide(
                      color: shadowColor,
                      width: 2.0,
                    ): BorderSide.none,
                  ),
                ),

                // BUTTON CONTENTS (TEXT, ICON, LOADING ICON)
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 8,
                  children: [

                    if (_isLoading)
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(context.myColors.neutralLightest!),
                        ),
                      )
                    else if (widget.icon != null)
                      widget.icon!,
                    
                    Text(
                      widget.label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handlePress() async {
    if (_isLoading) return;

    if (widget.oneShot) {
      setState(() => _isLoading = true);
    }

    try {
      if (widget.onPressed != null) {
        await widget.onPressed!();
      }
    } finally {
      if (mounted && widget.oneShot) {
        setState(() => _isLoading = false);
      }
    }
  }
}