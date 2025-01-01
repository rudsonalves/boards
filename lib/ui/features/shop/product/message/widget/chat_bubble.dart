// Copyright (C) 2025 Rudson Alves
// 
// This file is part of boards.
// 
// boards is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// boards is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with boards.  If not, see <https://www.gnu.org/licenses/>.

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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (isAdOwner) SizedBox(width: 60),
        if (!isAdOwner)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: ChatBubbleTriangle(
              isAdOwner: isAdOwner,
              isRight: false,
            ),
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
        if (!isAdOwner) SizedBox(width: 60),
        if (isAdOwner)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: ChatBubbleTriangle(
              isAdOwner: isAdOwner,
              isRight: true,
            ),
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

    return CustomPaint(
      size: const Size(10, 10),
      painter: _TrianglePainter(
        color: color,
        isAdOwner: isAdOwner,
        isRight: isRight,
      ),
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
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
    } else {
      // Triangle pointing to the left
      path
        ..moveTo(size.width, 0)
        ..lineTo(0, size.height)
        ..lineTo(size.width, size.height)
        ..close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
