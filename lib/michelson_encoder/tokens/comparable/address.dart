import 'package:tezster_dart/michelson_encoder/helpers/utils.dart';
import 'package:tezster_dart/michelson_encoder/helpers/validators.dart';
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

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
    if (val is String) return val;

    if (val['string'] != null) {
      return val['string'];
    }

    return encodePubKey(val['bytes']);
  }

  @override
  extractSchema() {
    return AddressToken.prim;
  }

  @override
  encodeObject(val) {
    var err = this._isValid(execute(val));
    if (err != null) {
      throw err;
    }

    return {'string': val};
  }

  @override
  toKey(dynamic val) {
    if (val != null) {
      return val;
    }

    return encodePubKey(val);
  }

  @override
  encode(List args) {
    var val = args.removeLast();
    var err = this._isValid(val);
    if (err != null) {
      throw err;
    }
    return {'string': val};
  }
}
