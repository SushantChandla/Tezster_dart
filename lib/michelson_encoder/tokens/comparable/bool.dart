
import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

class BoolToken extends ComparableToken {
  static String prim = "bool";
  BoolToken(MichelsonV1Expression val, int idx, fac) : super(val, idx, fac);

  @override
  execute(val, {semantics}) {
    return val['prim'].toLowerCase() == 'true' ? true : false;
  }

  encode(List<dynamic> args) {
    var val = args[args.length - 1];
    return {"prim": val != null ? "True" : "False"};
  }

  @override
  encodeObject(val) {
    return {"prim": val != null ? 'True' : 'False'};
  }

  @override
  extractSchema() {
    return BoolToken.prim;
  }

  toBigMapKey(val) {
    return {
      'key': encodeObject(val),
      'type': {"prim": BoolToken.prim},
    };
  }

  @override
  toKey(dynamic val) {
    return encodeObject(val);
  }

  compare(val1, val2) {
    if ((val1 != null && val2 != null) || (val1 == null && val2 == null)) {
      return 0;
    } else if (val1 != null) {
      return 1;
    } else {
      return -1;
    }
  }
}
