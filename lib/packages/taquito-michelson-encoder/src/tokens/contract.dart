import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';
import 'package:tezster_dart/packages/taquito-utils/src/taquito-utils.dart';
import 'package:tezster_dart/packages/taquito-utils/src/validators.dart';

class ContractToken extends Token {
  static String prim = 'contract';

  ContractToken(MichelsonV1Expression val, int idx, var fac)
      : super(
            val.runtimeType == List
                ? {'prim': ContractToken.prim, 'args': val}
                : val,
            idx,
            fac);

  _isValid(dynamic value) {
    // tz1,tz2 and tz3 seems to be valid contract values (for Unit contract)
    if (validateAddress(value) != ValidationResult.VALID) {
      return new Exception('$value Contract address is not valid');
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
    return ContractToken.prim;
  }

  @override
  encodeObject(args) {
    var err = this._isValid(val);
    if (err) {
      throw err;
    }
    return {'string': val};
  }
}
