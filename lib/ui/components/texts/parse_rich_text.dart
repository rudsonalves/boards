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

/// Parses a string and applies bold (**) and italic (*) formatting to it.
RichText parseRichText(String text, TextStyle defaultStyle) {
  final spans = <TextSpan>[];
  final regex = RegExp(r'\*\*(.*?)\*\*|\*(.*?)\*|(.+?)');

  for (final match in regex.allMatches(text)) {
    if (match.group(1) != null) {
      // Bold (**text**)
      spans.add(TextSpan(
        text: match.group(1),
        style: defaultStyle.copyWith(fontWeight: FontWeight.bold),
      ));
    } else if (match.group(2) != null) {
      // Italic (*text*)
      spans.add(TextSpan(
        text: match.group(2),
        style: defaultStyle.copyWith(fontStyle: FontStyle.italic),
      ));
    } else if (match.group(3) != null) {
      // Normal text
      spans.add(TextSpan(
        text: match.group(3),
        style: defaultStyle,
      ));
    }
  }

  return RichText(
    text: TextSpan(
      children: spans,
      style: defaultStyle,
    ),
  );
}

// Example usage in a Flutter widget:
class RichTextExample extends StatelessWidget {
  const RichTextExample({super.key});

  @override
  Widget build(BuildContext context) {
    const exampleText = 'This is **bold** and this is *italic*.';
    final defaultStyle = TextStyle(fontSize: 16, color: Colors.black);

    return Scaffold(
      appBar: AppBar(title: const Text('Rich Text Example')),
      body: Center(
        child: parseRichText(exampleText, defaultStyle),
      ),
    );
  }
}
