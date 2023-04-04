import 'package:flutter/material.dart';

class FlatButtonWrapper extends StatelessWidget {
  final double? width;
  final double? height;
  final void Function()? onPressed;
  final Widget child;
  final Color? disabledColor;
  final Color? backgroundColor;
  final VisualDensity? visualDensity;

  const FlatButtonWrapper({
    Key? key,
    this.width,
    this.height,
    required this.child,
    this.onPressed,
    this.disabledColor,
    this.backgroundColor,
    this.visualDensity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      minimumSize:
          (width != null && height != null) ? Size(width!, height!) : null,
      backgroundColor: backgroundColor,
      padding: EdgeInsets.all(0),
      disabledBackgroundColor: disabledColor,
      visualDensity: visualDensity,
    );
    return TextButton(
      style: flatButtonStyle,
      onPressed: onPressed,
      child: child,
    );
  }
}
