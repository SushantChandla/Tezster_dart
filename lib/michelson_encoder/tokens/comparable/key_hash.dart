import 'package:tezster_dart/michelson_encoder/helpers/utils.dart';
import 'package:tezster_dart/michelson_encoder/helpers/validators.dart';
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

class KeyHashToken extends ComparableToken {
  static String prim = 'key_hash';

  KeyHashToken(dynamic val, int idx, var fac) : super(val, idx, fac);

  _isValid(value) {
    if (validateKeyHash(value) != ValidationResult.VALID) {
      return Exception("KeyHash is not valid: $value");
    }

    return null;
  }

  @override
  execute(val, {semantics}) {
    if (val['string'] != null) {
      return val['string'];
    }

    return encodeKeyHash(val['bytes']);
  }

  @override
  extractSchema() {
    return KeyHashToken.prim;
  }

  @override
  encodeObject(args) {
    var err = this._isValid(val);

    if (err != null) {
      throw err;
    }
  }

  @override
  toKey(dynamic val) {
    if (val != null && val is String) {
      return val;
    }

    return encodeKeyHash(val);
  }

  @override
  encode(List args) {
    var val = args.removeLast();

    var err = this._isValid(val);
    if (err != null) {
      throw err;
    }

    return {String: val};
  }

  @override
  Map toBigMapKey(val) {
    return {
      'key': {'string': val},
      'type': {'prim': KeyHashToken.prim},
    };
  }
}
