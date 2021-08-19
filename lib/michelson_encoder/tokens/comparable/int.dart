import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

class IntToken extends ComparableToken {
  static String prim = 'int';
  IntToken(MichelsonV1Expression val, int idx, fac) : super(val, idx, fac);

  @override
  execute(val, {semantics}) {
    return BigInt.parse((val[val.keys.toList().first]));
  }

  @override
  encodeObject(val) {
    _isValid(val);
    return {int: BigInt.parse(val)};
  }

  _isValid(val) {
    var bigNumber = BigInt.tryParse(val);
    if (bigNumber == null) {
      throw Exception('$val is not a number');
    } else {
      return null;
    }
  }

  @override
  extractSchema() {
    return IntToken.prim;
  }

  toBigMapKey(val) {
    return {
      'key': int.parse(val),
      'type': {prim: IntToken.prim},
    };
  }

  @override
  toKey(dynamic val) {
    return val;
  }

  compare(int1, int2) {
    int o1 = int1.runtimeType == int ? int1 : int.tryParse(int1);
    int o2 = int1.runtimeType == int ? int1 : int.tryParse(int1);
    if (o1 == o2) {
      return 0;
    }

    return o1 < o2 ? -1 : 1;
  }

  @override
  encode(List args) {
    // TODO: implement encode
    throw UnimplementedError();
  }
}
