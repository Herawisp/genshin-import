import 'package:flutter/material.dart';
import 'package:genshin_import/ui/core/themes/theme.dart';

class NavigationItem extends StatefulWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final double size;

  const NavigationItem({
    super.key,
    required this.onPressed,
    required this.icon,
    this.size = 64,
  });

  @override
  State<NavigationItem> createState() => _CustomNavigationItemState();
}

class _CustomNavigationItemState extends State<NavigationItem> {
  final WidgetStatesController _controller = WidgetStatesController();

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

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null;
    final visuallyPressed = _controller.value.contains(WidgetState.pressed);

    const double depth = 4.0;

    return Row(
      children: [
        SizedBox(
          height: widget.size + depth,
          width: widget.size,
          child: Stack(
            children: [
              // 3D BASE SHADOW
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: isDisabled
                        ? context.myColors.primaryVariant
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),

              // INTERACTIVE TOP LAYER
              AnimatedPositioned(
                duration: const Duration(milliseconds: 60),
                top: visuallyPressed ? depth : 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: widget.size,
                  child: FilledButton(
                    statesController: _controller,
                    onPressed: isDisabled ? () {} : widget.onPressed,
                    style: FilledButton.styleFrom(
                      backgroundColor: isDisabled
                          ? context.myColors.primary
                          : Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Icon(
                      widget.icon,
                      size: widget.size * 0.48,
                      color: isDisabled
                          ? context.myColors.neutralLightest
                          : context.myColors.neutralDark,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
