library petitparser.core.predicates.any;

import 'package:petitparser/src/core/contexts/context.dart';
import 'package:petitparser/src/core/contexts/result.dart';
import 'package:petitparser/src/core/parser.dart';

/// Returns a parser that accepts any input element.
///
/// For example, `any()` succeeds and consumes any given letter. It only
/// fails for an empty input.
Parser<String> any([String message = 'input expected']) {
  return AnyParser(message);
}

/// A parser that accepts any input element.
class AnyParser extends Parser<String> {
  final String message;

  AnyParser(this.message);

  @override
  Result<String> parseOn(Context context) {
    var position = context.position;
    var buffer = context.buffer;
    return position < buffer.length
        ? context.success(buffer[position], position + 1)
        : context.failure(message);
  }

  @override
  AnyParser copy() => AnyParser(message);

  @override
  bool hasEqualProperties(AnyParser other) =>
      super.hasEqualProperties(other) && message == other.message;
}
