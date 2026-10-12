/// MockAPI text sometimes contains a literal "\n" (backslash + n) instead of a
/// real line break. This turns both kinds into a space (default) or a real
/// new line ([multiline] = true) so the text reads cleanly on screen.
String cleanText(Object? input, {bool multiline = false}) {
  final text = (input ?? '').toString().trim();
  final replacement = multiline ? '\n' : ' ';
  return text.replaceAll(r'\n', replacement).replaceAll('\n', replacement);
}
