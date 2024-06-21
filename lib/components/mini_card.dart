import 'package:flutter/material.dart';

class MiniCard extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final double borderRadius;
  final String? iconAsset;
  final double? height;
  final double? width;
  final double padding;
  final String mainText;
  final List<String> secondaryTexts;
  final Color textColor;
  final void Function()? onPressed;

  const MiniCard(
      {super.key,
      required this.backgroundColor,
      this.iconAsset,
      this.width,
      this.textColor = Colors.white,
      this.height,
      this.onPressed,
      this.padding = 20,
      this.mainText = 'N/A',
      this.secondaryTexts = const [],
      this.borderRadius = 20,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
        key: UniqueKey(),
        child: Expanded(
            child: GestureDetector(
              onTap: onPressed,
                child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (iconAsset != null)
                        Image(
                          width: 50,
                          image: AssetImage(iconAsset!),
                        ),
                      Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: textColor),
                      )
                    ],
                  ),
                  Text(
                    mainText,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 35,
                        color: textColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (String text in secondaryTexts)
                        Text(
                          text,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 11,
                              color: textColor),
                        )
                    ],
                  )
                ],
              )),
        ))));
  }
}


// black: #212626
// green1: #678C30
// green2: #8FA66D
// brown1: #BF8C60
// brown2: #8C593B