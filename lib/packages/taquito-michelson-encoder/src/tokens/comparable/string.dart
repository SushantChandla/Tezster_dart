import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

class StringToken extends ComparableToken {
  static String prim = 'string';

  StringToken(MichelsonV1Expression val, int idx, fac) : super(val, idx, fac);

  @override
  encodeObject(val) {
    return {'string': val};
  }

  @override
  execute(val, {semantics}) {
    return val[val.keys.toList()[0]];
  }

  @override
  extractSchema() {
    return StringToken.prim;
  }

  @override
  toKey(val) {
    return val;
  }
}
