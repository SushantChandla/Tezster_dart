
import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

class MutezToken extends ComparableToken {
  static String prim = 'mutez';
  MutezToken(MichelsonV1Expression val, int idx, fac) : super(val, idx, fac);

  @override
  execute(val, {semantics}) {
    return BigInt.parse((val[val.keys()[0]]));
  }

  @override
  encodeObject(val) {
    _isValid(val);
    return {int: BigInt.parse(val).toString()};
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
    return MutezToken.prim;
  }

  toBigMapKey(val) {
    return {
      'key': int.parse(val),
      'type': {prim: MutezToken.prim},
    };
  }

  @override
  toKey(dynamic val) {
    return val.values.toList().first;
  }

  compare(mutez1, mutez2) {
    int o1 = mutez1.runtimeType == int ? mutez1 : int.tryParse(mutez1);
    int o2 = mutez2.runtimeType == int ? mutez2 : int.tryParse(mutez2);
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
