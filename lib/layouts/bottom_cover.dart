import 'package:flutter/material.dart';

class BottomCoverLayout extends StatelessWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints)?
      topBuilder;
  final Widget Function(BuildContext context, BoxConstraints constraints)
      bodyBuilder;
  final String backgroundImage;
  final double coverHeightPercentage = .55;

  const BottomCoverLayout(
      {super.key,
      required this.bodyBuilder,
      this.topBuilder,
      required this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            top: false,
            child: LayoutBuilder(builder: (context, constraints) {
              return Stack(alignment: AlignmentDirectional.topStart, children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          Colors.black45.withOpacity(.6), BlendMode.darken),
                      child: Image(
                          image: AssetImage(backgroundImage),
                          fit: BoxFit.cover)),
                ),
                if (topBuilder != null)
                  KeyedSubtree(
                      key: UniqueKey(),
                      child: topBuilder!(context, constraints)),
                ListView(
                  reverse: true,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        minHeight: constraints.minHeight,
                      ),
                      child: Container(
                          width: double.infinity,
                          height: constraints.maxHeight * coverHeightPercentage,
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          child: KeyedSubtree(
                            key: UniqueKey(),
                            child: bodyBuilder(context, constraints),
                          )),
                    )
                  ],
                )
              ]);
            })));
  }
}
