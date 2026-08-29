import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown/markdown.dart' as m;
import 'package:markdown_widget/markdown_widget.dart';

SpanNodeGeneratorWithTag latexGenerator = SpanNodeGeneratorWithTag(
    tag: _latexTag,
    generator: (e, config, visitor) =>
        LatexNode(e.attributes, e.textContent, config));

const _latexTag = 'latex';

class LatexSyntax extends m.InlineSyntax {
  // Regex to match $...$ or $$...$$ or \(...\) or \[...\]
  LatexSyntax() : super(r'(\$\$[\s\S]+?\$\$)|(\$[\s\S]+?\$)|(\\\[[\s\S]+?\\\])|(\\\([\s\S]+?\\\))');

  @override
  bool onMatch(m.InlineParser parser, Match match) {
    final input = match.input;
    final matchValue = input.substring(match.start, match.end);
    String content = '';
    bool isInline = true;

    if (matchValue.startsWith('\$\$') && matchValue.endsWith('\$\$')) {
      content = matchValue.substring(2, matchValue.length - 2);
      isInline = false;
    } else if (matchValue.startsWith('\\[') && matchValue.endsWith('\\]')) {
      content = matchValue.substring(2, matchValue.length - 2);
      isInline = false;
    } else if (matchValue.startsWith('\\(') && matchValue.endsWith('\\)')) {
      content = matchValue.substring(2, matchValue.length - 2);
      isInline = true;
    } else if (matchValue.startsWith('\$') && matchValue.endsWith('\$')) {
      content = matchValue.substring(1, matchValue.length - 1);
      isInline = true;
    }

    m.Element el = m.Element.text(_latexTag, matchValue);
    el.attributes['content'] = content;
    el.attributes['isInline'] = '$isInline';
    parser.addNode(el);
    return true;
  }
}

class LatexNode extends SpanNode {
  final Map<String, String> attributes;
  final String textContent;
  final MarkdownConfig config;
  final double? maxWidth;

  LatexNode(this.attributes, this.textContent, this.config, {this.maxWidth});

  @override
  InlineSpan build() {
    final content = attributes['content'] ?? '';
    final isInline = attributes['isInline'] == 'true';
    final style = parentStyle ?? config.p.textStyle;
    
    if (content.isEmpty) return TextSpan(style: style, text: textContent);
    
    final latex = Math.tex(
      content,
      mathStyle: isInline ? MathStyle.text : MathStyle.display,
      textStyle: style.copyWith(
        color: style.color ?? Colors.black, // Fallback to black if null
      ),
      textScaleFactor: 1,
      onErrorFallback: (error) {
        return Text(
          textContent,
          style: style.copyWith(color: Colors.red),
        );
      },
    );

    return WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: !isInline
              ? Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: latex,
                    ),
                  ),
                )
              : (maxWidth != null 
                  ? ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth!),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: latex,
                      ),
                    )
                  : latex),
        ));
  }
}
