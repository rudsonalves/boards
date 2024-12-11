import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final Widget widget;
  final bool isAdOwner;

  const ChatBubble({
    super.key,
    required this.widget,
    required this.isAdOwner,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        if (isAdOwner) SizedBox(width: 40),
        if (!isAdOwner)
          ChatBubbleTriangle(
            isAdOwner: isAdOwner,
            isRight: false,
          ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
            decoration: BoxDecoration(
              color: isAdOwner
                  ? colorScheme.onPrimaryFixedVariant
                  : colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: isAdOwner ? Radius.circular(16) : Radius.zero,
                topRight: Radius.circular(16),
                bottomRight: isAdOwner ? Radius.zero : Radius.circular(16),
              ),
            ),
            child: widget,
          ),
        ),
        if (!isAdOwner) SizedBox(width: 40),
        if (isAdOwner)
          ChatBubbleTriangle(
            isAdOwner: isAdOwner,
            isRight: true,
          ),
      ],
    );
  }
}

class ChatBubbleTriangle extends StatelessWidget {
  final bool isAdOwner;
  final bool isRight;

  const ChatBubbleTriangle({
    super.key,
    required this.isAdOwner,
    required this.isRight,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isAdOwner
        ? colorScheme.onPrimaryFixedVariant
        : colorScheme.surfaceContainerHigh;

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomPaint(
          size: const Size(10, 10), // Adjust size if needed
          painter: _TrianglePainter(
            color: color,
            isAdOwner: isAdOwner,
            isRight: isRight,
          ),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  final bool isAdOwner;
  final bool isRight;

  _TrianglePainter({
    required this.color,
    required this.isAdOwner,
    required this.isRight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    final path = Path();
    if (isRight) {
      // Triangle pointing to the right
      path
        ..moveTo(0, 0)
        ..lineTo(size.width, size.height / 2)
        ..lineTo(0, size.height)
        ..close();
    } else {
      // Triangle pointing to the left
      path
        ..moveTo(size.width, 0)
        ..lineTo(0, size.height / 2)
        ..lineTo(size.width, size.height)
        ..close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
