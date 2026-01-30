import 'package:flutter/material.dart';

class MarkdownText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;

  const MarkdownText(
    this.text, {
    super.key,
    required this.style,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final List<TextSpan> spans = [];
    final pattern = RegExp(r'\*\*(.*?)\*\*');
    int lastIndex = 0;

    for (final match in pattern.allMatches(text)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex)));
    }

    return Text.rich(
      TextSpan(children: spans),
      style: style,
      textAlign: textAlign,
    );
  }
}
