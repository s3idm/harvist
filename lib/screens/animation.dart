import 'package:simple_animations/simple_animations/controlled_animation.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations/multi_track_tween.dart';


class FadeX extends StatelessWidget {
  final double delay;
  final Widget child;
  final bool reversed ;

  FadeX({this.delay, this.child, this.reversed});

  @override
  Widget build(BuildContext context) {
    bool reverse = reversed ?? false ;

    final tween = MultiTrackTween([
      Track("opacity").add(Duration(milliseconds: 350),Tween(begin: 0.0, end: 1.0),curve: Curves.decelerate),
      Track("translateY").add(Duration(milliseconds: 350), Tween(begin: -100.0, end: 0.0),curve: Curves.decelerate)
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (250 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
          offset: Offset(reverse ? -animation["translateY"] : animation["translateY"] , 0.0,),
          child: child,
        ),
      ),
    );
  }
}
class FadeY extends StatelessWidget {
  final double delay;
  final Widget child;
  final bool reversed ;

  FadeY({this.delay, this.child, this.reversed});

  @override
  Widget build(BuildContext context) {
    bool reverse = reversed ?? false ;

    final tween = MultiTrackTween([
      Track("opacity").add(Duration(milliseconds: 350),Tween(begin: 0.0, end: 1.0),curve: Curves.decelerate),
      Track("translateY").add(Duration(milliseconds: 350), Tween(begin: -100.0, end: 0.0),curve: Curves.decelerate)
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (250 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
          offset: Offset( 0.0,reverse ? -animation["translateY"] : animation["translateY"] ),
          child: child,
        ),
      ),
    );
  }
}

