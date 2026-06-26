import 'package:flutter/material.dart';

class Interactive3DCard extends StatefulWidget {
  final Widget child;
  final double maxTiltAngle;
  final double depth;

  const Interactive3DCard({
    super.key,
    required this.child,
    this.maxTiltAngle = 0.15,
    this.depth = 0.001,
  });

  @override
  State<Interactive3DCard> createState() => _Interactive3DCardState();
}

class _Interactive3DCardState extends State<Interactive3DCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tiltAnimation;
  
  double _currentXAngle = 0;
  double _currentYAngle = 0;
  double _currentGlareX = 0.5;
  double _currentGlareY = 0.5;
  double _currentOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _tiltAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _tiltAnimation.addListener(() {
      setState(() {
        _currentXAngle = Tween<double>(begin: _currentXAngle, end: 0).evaluate(_tiltAnimation);
        _currentYAngle = Tween<double>(begin: _currentYAngle, end: 0).evaluate(_tiltAnimation);
        _currentOpacity = Tween<double>(begin: _currentOpacity, end: 0).evaluate(_tiltAnimation);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    if (_controller.isAnimating) _controller.stop();

    final width = constraints.maxWidth;
    final height = constraints.maxHeight;
    
    if (width <= 0 || height <= 0) return;

    final xPos = details.localPosition.dx;
    final yPos = details.localPosition.dy;

    setState(() {
      _currentYAngle = widget.maxTiltAngle * ((xPos - width / 2) / (width / 2));
      _currentXAngle = -widget.maxTiltAngle * ((yPos - height / 2) / (height / 2));
      _currentGlareX = (xPos / width).clamp(0.0, 1.0);
      _currentGlareY = (yPos / height).clamp(0.0, 1.0);
      _currentOpacity = 0.4;
    });
  }

  void _onPanEnd() {
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final transform = Matrix4.identity()
          ..setEntry(3, 2, widget.depth)
          ..rotateX(_currentXAngle)
          ..rotateY(_currentYAngle);

        return GestureDetector(
          onPanUpdate: (details) => _onPanUpdate(details, constraints),
          onPanEnd: (_) => _onPanEnd(),
          onPanCancel: _onPanEnd,
          child: Transform(
            transform: transform,
            alignment: FractionalOffset.center,
            child: Stack(
              children: [
                widget.child,
                Positioned.fill(
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: _currentOpacity.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: RadialGradient(
                            center: Alignment(_currentGlareX * 2 - 1, _currentGlareY * 2 - 1),
                            radius: 1.2,
                            colors: [
                              Colors.white.withValues(alpha: 0.3),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.6],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
