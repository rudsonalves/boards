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
