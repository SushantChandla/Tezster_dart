import 'package:tezster_dart/michelson_encoder/helpers/utils.dart';
import 'package:tezster_dart/michelson_encoder/helpers/validators.dart';
import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

class KeyToken extends ComparableToken {
  static String prim = 'key';
  KeyToken(MichelsonV1Expression? val, int idx, fac) : super(val, idx, fac);

  _isValid(val) {
    if (validatePrefixedValue(val, ['edpk', 'sppk', 'p2pk']) !=
        ValidationResult.VALID) {
      throw Exception('Key is not valid');
    }
  }

  @override
  execute(val, {semantics}) {
    if (val.containsKey('string')) return val['string'];

    return encodeKeyHash(val['bytes']);
  }

  @override
  encodeObject(val) {
    _isValid(val);
    return {String: val};
  }

  @override
  extractSchema() {
    return KeyToken.prim;
  }

  toBigMapKey(val) {
    return {
      'key': {String: val},
      'type': {prim: KeyToken.prim},
    };
  }

  @override
  toKey(dynamic val) {
    return execute(val);
  }

  @override
  encode(args) {
    var val = args.removeLast();

    var err = _isValid(val);
    if (err != null) {
      throw err;
    }

    return {String: val};
  }
}
