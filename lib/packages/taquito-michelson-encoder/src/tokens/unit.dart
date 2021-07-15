import 'package:tezster_dart/packages/taquito-michelson-encoder/src/taquito-michelson-encoder.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

class UnitToken extends ComparableToken {
  static String prim = 'unit';

  UnitToken(MichelsonV1Expression val, int idx, var fac) : super(val, idx, fac);

  @override
  execute(val, {var semantics}) {
    return unitValue;
  }

  @override
  extractSchema() {
    return UnitToken.prim;
  }

  @override
  encodeObject(args) {
    return {'prim': 'Unit'};
  }

  @override
  toKey(String val) {
    return unitValue;
  }
}
