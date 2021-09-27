import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

class IntToken extends ComparableToken {
  static String prim = 'int';
  IntToken(MichelsonV1Expression? val, int idx, fac) : super(val, idx, fac);

  @override
  execute(val, {semantics}) {
    if (val is MichelsonV1Expression) {
      return BigInt.parse((val.jsonCopy[val.jsonCopy.keys.toList().first]));
    }
    return BigInt.parse((val[val.keys.toList().first]));
  }

  @override
  encodeObject(val) {
    if (val is Map) {
      val = val['int'];
    }
    _isValid(val);
    if (val is String) return {'int': BigInt.parse(val).toString()};
    return {'int': val};
  }

  _isValid(val) {
    if (val is String) {
      var x = BigInt.tryParse(val);
      if (x != null) return true;
    }
    if (val.runtimeType != int) {
      return Exception("Value is not a number: $val");
    } else {
      return true;
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
    num? o1 =
        int1.runtimeType == int || int1 is BigInt ? int1 : int.tryParse(int1);
    num? o2 =
        int1.runtimeType == int || int1 is BigInt ? int1 : int.tryParse(int1);
    if (o1 == o2) {
      return 0;
    }

    return o1! < o2! ? -1 : 1;
  }

  @override
  encode(List args) {
    // TODO: implement encode
    throw UnimplementedError();
  }
}
