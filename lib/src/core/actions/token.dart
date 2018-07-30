library petitparser.core.actions.token;

import 'package:petitparser/src/core/combinators/delegate.dart';
import 'package:petitparser/src/core/contexts/context.dart';
import 'package:petitparser/src/core/contexts/result.dart';
import 'package:petitparser/src/core/parser.dart';
import 'package:petitparser/src/core/token.dart';

/// A parser that answers a token of the result its delegate parses.
class TokenParser<T> extends DelegateParser<Token<T>> {
  TokenParser(Parser delegate) : super(delegate);

  @override
  Result<Token<T>> parseOn(Context context) {
    var result = delegate.parseOn(context);
    if (result.isSuccess) {
      var token = Token<T>(
          result.value, context.buffer, context.position, result.position);
      return result.success(token);
    } else {
      return result.failure(result.message);
    }
  }

  @override
  TokenParser<T> copy() => TokenParser<T>(delegate);
}
