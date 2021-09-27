import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

class StringToken extends ComparableToken {
  static String prim = 'string';

  StringToken(MichelsonV1Expression? val, int idx, fac) : super(val, idx, fac);

  @override
  encodeObject(val) {
    return {'string': val};
  }

  @override
  execute(val, {semantics}) {
    if (val is MichelsonV1Expression) val = val.jsonCopy;
    return val[val.keys.first];
  }

  @override
  extractSchema() {
    return StringToken.prim;
  }

  @override
  toKey(val) {
    return val;
  }

  @override
  encode(List args) {
    var val = args.removeLast();
    return {'string': val};
  }

  @override
  Map toBigMapKey(val) {
    return {
      'key': {'string': val},
      'type': {'prim': StringToken.prim},
    };
  }
}
