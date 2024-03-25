import 'package:flutter/material.dart';

class MyFlexibleAppBar extends StatelessWidget {
  final String title;
  final Widget? leading;

  const MyFlexibleAppBar({
    super.key,
    this.title = '',
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      stretch: true,
      leading: leading,
      elevation: 4,
      onStretchTrigger: () {
        // Function callback for stretch
        return Future<void>.value();
      },
      expandedHeight: 160.0,
      pinned: true,
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
        ],
        centerTitle: false,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        background: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.network(
                'https://howtostartanllc.com/images/business-ideas/business-idea-images/radio-station.jpg',
                fit: BoxFit.cover,
                alignment: Alignment.centerLeft,
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.0, 0.5),
                    end: Alignment.center,
                    colors: <Color>[
                      Color(0x60000000),
                      Color(0x00000000),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}