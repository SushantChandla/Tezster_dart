import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-utils/src/taquito-utils.dart';
import 'package:tezster_dart/packages/taquito-utils/src/validators.dart';

class KeyHashToken extends ComparableToken {
  static String prim = 'key_hash';

  KeyHashToken(dynamic val, int idx, var fac) : super(val, idx, fac);

  _isValid(value){
    if (validateKeyHash(value) != ValidationResult.VALID) {
      return  Exception("KeyHash is not valid: $value");
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
  toKey(String val) {
    if (val != null) {
      return val;
    }

    return encodeKeyHash(val);
  }
}
