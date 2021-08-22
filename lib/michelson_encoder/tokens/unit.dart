import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

class UnitToken extends ComparableToken {
  static String prim = 'unit';

  UnitToken(MichelsonV1Expression val, int idx, var fac) : super(val, idx, fac);

  @override
  execute(val, {var semantics}) {
    return Symbol('');
  }

  @override
  extractSchema() {
    return UnitToken.prim;
  }

  @override
  encodeObject(args) {
    return {'prim': 'unit'};
  }

  @override
  toKey(dynamic val) {
    return Symbol('');
  }

  encode(args) {
    return {prim: 'Unit'};
  }
}
