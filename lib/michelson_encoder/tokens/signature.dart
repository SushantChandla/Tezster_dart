import 'package:tezster_dart/michelson_encoder/helpers/validators.dart';
import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

class SignatureToken extends ComparableToken {
  static String prim = 'signature';
  SignatureToken(MichelsonV1Expression val, int idx, fac)
      : super(val, idx, fac);

  _isValid(val) {
    if (validatePrefixedValue(val, ['edsig', "p2sig", "spsig", "sig"]) !=
        ValidationResult.VALID) {
      throw Exception('Signature $val is not valid');
    }
    return null;
  }

  @override
  execute(val, {semantics}) {
    return val["string"];
  }

  @override
  encodeObject(val) {
    _isValid(val);
    return {String: val};
  }

  @override
  extractSchema() {
    return SignatureToken.prim;
  }

  toBigMapKey(val) {
    return {
      'key': {String: val},
      'type': {prim: SignatureToken.prim},
    };
  }

  @override
  toKey(val) {
    return execute(val);
  }

  @override
  encode(List args) {
    // TODO: implement encode
    throw UnimplementedError();
  }
}
