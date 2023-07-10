import 'package:flutter/material.dart';

class MoveOutVerticalWidget extends StatefulWidget {
  final Widget childIn;
  final Curve curveIn;
  final Widget childOut;
  final Curve curveOut;

  const MoveOutVerticalWidget({
    required this.childIn,
    required this.curveIn,
    required this.childOut,
    required this.curveOut,
    super.key,
  });

  @override
  State<MoveOutVerticalWidget> createState() => _MoveOutVerticalWidgetState();
}

class _MoveOutVerticalWidgetState extends State<MoveOutVerticalWidget>
    with TickerProviderStateMixin {
  late final AnimationController _positionedController;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeInAnimation;
  late final Animation<double> _fadeOutAnimation;

  @override
  void initState() {
    super.initState();
    _positionedController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeInAnimation = Tween(begin: 0.0, end: 1.0).animate(_fadeController);
    _fadeOutAnimation = Tween(begin: 1.0, end: 0.0).animate(_fadeController);
  }

  @override
  void dispose() {
    _positionedController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _positionedController.reset();
    _positionedController.forward();
    _fadeController.reset();
    _fadeController.forward();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final biggest = constraints.biggest;

        return Stack(
          children: [
            // move in
            PositionedTransition(
              rect: RelativeRectTween(
                begin: RelativeRect.fromSize(
                  Rect.fromLTWH(
                      0, -biggest.height, biggest.width, biggest.height),
                  Size(biggest.width, biggest.height),
                ),
                end: RelativeRect.fromSize(
                  Rect.fromLTWH(0, 0, biggest.width, biggest.height),
                  Size(biggest.width, biggest.height),
                ),
              ).animate(CurvedAnimation(
                parent: _positionedController,
                curve: Curves.elasticInOut,
              )),
              child: FadeTransition(
                  opacity: _fadeInAnimation, child: widget.childIn),
            ),
            // move out
            PositionedTransition(
              rect: RelativeRectTween(
                begin: RelativeRect.fromSize(
                  Rect.fromLTWH(0, 0, biggest.width, biggest.height),
                  Size(biggest.width, biggest.height),
                ),
                end: RelativeRect.fromSize(
                  Rect.fromLTWH(
                      0, biggest.height, biggest.width, biggest.height),
                  Size(biggest.width, biggest.height),
                ),
              ).animate(CurvedAnimation(
                parent: _positionedController,
                curve: Curves.linear,
              )),
              child: FadeTransition(
                  opacity: _fadeOutAnimation, child: widget.childOut),
            ),
          ],
        );
      },
    );
  }
}
