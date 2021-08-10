import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-utils/src/taquito-utils.dart';
import 'package:tezster_dart/packages/taquito-utils/src/validators.dart';

class AddressToken extends ComparableToken {
  static String prim = "address";

  AddressToken(dynamic val, int idx, var fac) : super(val, idx, fac);

  _isValid(value) {
    if (validateAddress(value) != ValidationResult.VALID) {
      return new Exception("Address is not valid: $value");
    }

    return null;
  }

  @override
  execute(val, {semantics}) {
    if (val['string'] != null) {
      return val['string'];
    }

    return encodePubKey(val.bytes);
  }

  @override
  extractSchema() {
    return AddressToken.prim;
  }

  @override
  encodeObject(val) {
    var err = this._isValid(val);
    if (err) {
      throw err;
    }

    return {'string': val};
  }

  @override
  toKey(String val) {
    if (val != null) {
      return val;
    }

    return encodePubKey(val);
  }
}
