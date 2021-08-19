
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

class NatToken extends ComparableToken {
  static String prim = 'nat';

  NatToken(dynamic val, int idx, var fac)
      : super(
            val.runtimeType == List
                ? {'prim': NatToken.prim, 'args': val}
                : val,
            idx,
            fac);

  _isValid(bigNumber) {
    if (bigNumber.runtimeType != int) {
      return new Exception("Value is not a number: $val");
    } else if (bigNumber < 0) {
      return new Exception("Value cannot be negative: $val");
    } else {
      return null;
    }
  }

  @override
  execute(val, {semantics}) {
    return val[val.keys.first];
  }

  @override
  extractSchema() {
    return NatToken.prim;
  }

  @override
  encodeObject(val) {
    var err = this._isValid(val);

    if (err != null) {
      throw err;
    }

    return {'int': val};
  }

  @override
  toKey(dynamic val) {
    return int.tryParse(val.values.toList().first) ?? 0;
  }

  @override
  encode(List args) {
    // TODO: implement encode
    throw UnimplementedError();
  }
}
