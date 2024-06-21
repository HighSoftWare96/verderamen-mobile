import 'package:flutter/material.dart';

class TransparentButton extends StatelessWidget {
  final String? text;
  final TextStyle? textStyle;
  final IconData? icon;
  final EdgeInsets? padding;
  final void Function()? onPressed;

  const TransparentButton(
      {super.key,
      this.onPressed,
      this.textStyle,
      this.icon,
      this.padding,
      this.text});

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
        key: UniqueKey(),
        child: Padding(
            padding: padding ?? const EdgeInsets.only(),
            child: GestureDetector(
                onTap: onPressed,
                child: Row(
                  children: [
                    if (icon != null)
                      Icon(
                        icon,
                        color: textStyle?.color,
                      ),
                    if (text != null)
                      Text(
                        text!,
                        style: textStyle,
                      )
                  ],
                ))));
  }
}


// black: #212626
// green1: #678C30
// green2: #8FA66D
// brown1: #BF8C60
// brown2: #8C593B