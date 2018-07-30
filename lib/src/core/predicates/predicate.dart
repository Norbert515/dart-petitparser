library petitparser.core.predicates.predicate;

import 'package:petitparser/src/core/contexts/context.dart';
import 'package:petitparser/src/core/contexts/result.dart';
import 'package:petitparser/src/core/parser.dart';

/// A generic predicate function returning `true` or `false` for a given
/// [input] argument.
typedef bool Predicate(String input);

/// Returns a parser that reads input of the specified [length], accepts
/// it if the [predicate] matches, or fails with the given [message].
Parser<String> predicate(int length, Predicate predicate, String message) {
  return PredicateParser(length, predicate, message);
}

/// A parser for a literal satisfying a predicate.
class PredicateParser extends Parser<String> {
  /// The length of the input to read.
  final int length;

  /// The predicate function testing the input.
  final Predicate predicate;

  /// The failure message in case of a miss-match.
  final String message;

  PredicateParser(this.length, this.predicate, this.message);

  @override
  Result<String> parseOn(Context context) {
    var start = context.position;
    var stop = start + length;
    if (stop <= context.buffer.length) {
      var result = context.buffer.substring(start, stop);
      if (predicate(result)) {
        return context.success(result, stop);
      }
    }
    return context.failure(message);
  }

  @override
  String toString() => '${super.toString()}[$message]';

  @override
  PredicateParser copy() => PredicateParser(length, predicate, message);

  @override
  bool hasEqualProperties(PredicateParser other) =>
      super.hasEqualProperties(other) &&
      length == other.length &&
      predicate == other.predicate &&
      message == other.message;
}
