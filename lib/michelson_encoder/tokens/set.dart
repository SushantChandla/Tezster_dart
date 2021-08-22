import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

class SetToken extends Token {
  static String prim = 'set';

  SetToken(MichelsonV1Expression val, int idx, fac) : super(val, idx, fac);

  ComparableToken get keySchema {
    return createToken(MichelsonV1Expression.j(val.args[0]), 0);
  }

  _isValid(value) {
    if (value is List) {
      return null;
    }

    return Exception("$value Value must be an array");
  }

  @override
  encodeObject(args) {
    var err;
    if (args is List) {
      err = _isValid(args);
    } else {
      err = _isValid(args.values.toList());
    }
    if (err != null) {
      throw err;
    }
    return {};
  }

  @override
  execute(val, {semantics}) {
    if (val.length < 1) {
      return val;
    }
    return val.reduce((prev, current) {
      var tempList;
      if (prev is Map)
        tempList = prev.values;
      else {
        tempList = prev;
      }
      return [...tempList, keySchema.execute(current, semantics: semantics)];
    });
  }

  @override
  extractSchema() {
    return SetToken.prim;
  }

  @override
  encode(List args) {
    List val = args[args.length - 1];
    var err = _isValid(val);
    if (err != null) {
      throw err;
    }
    return val.reduce(
        (prev, current) => [...prev, this.keySchema.encodeObject(current)]);
  }
}
