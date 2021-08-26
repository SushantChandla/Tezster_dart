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
    if (bigNumber is String) {
      var x = BigInt.tryParse(bigNumber);
      if (x != null) return true;
    }
    if (bigNumber.runtimeType != int) {
      return new Exception("Value is not a number: $val");
    } else if (bigNumber < 0) {
      return new Exception("Value cannot be negative: $val");
    } else {
      return true;
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

    if (err == null) {
      throw err;
    }

    return {'int': val};
  }

  @override
  toKey(dynamic val) {
    return int.tryParse(val.values.first) ?? 0;
  }

  @override
  encode(args) {
    var val = args.removeLast();

    var err = this._isValid(val);
    if (err != null) {
      throw err;
    }

    return {int: BigInt.from(val)};
  }

  @override
  Map toBigMapKey(val) {
    return {
      'key': {'int': val.toString()},
      'type': {'prim': NatToken.prim},
    };
  }
}
