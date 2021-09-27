import 'package:tezster_dart/michelson_encoder/helpers/validators.dart';
import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

class ChainIDToken extends ComparableToken {
  static String prim = 'chain_id';
  ChainIDToken(MichelsonV1Expression? val, int idx, fac) : super(val, idx, fac);

  _isValid(val) {
    if (validatePrefixedValue(val, ['Net']) != ValidationResult.VALID) {
      throw Exception('ChainID is not valid');
    }
    return null;
  }

  @override
  execute(val, {semantics}) {
    if (val is MichelsonV1Expression) val = val.jsonCopy;
    return val[val.keys.first];
  }

  @override
  encodeObject(val) {
    _isValid(val);
    return {String: val};
  }

  @override
  extractSchema() {
    return ChainIDToken.prim;
  }

  toBigMapKey(val) {
    return {
      'key': {String: val},
      'type': {prim: ChainIDToken.prim},
    };
  }

  @override
  toKey(val) {
    return val;
  }

  @override
  encode(List args) {
    // TODO: implement encode
    throw UnimplementedError();
  }
}
