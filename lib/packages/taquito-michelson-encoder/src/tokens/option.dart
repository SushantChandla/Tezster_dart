import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

class OptionToken extends ComparableToken {
  static String prim = 'option';
  MichelsonV1Expression val;
  int idx;
  var fac;
  OptionToken(MichelsonV1Expression val, int idx, var fac)
      : super(val, idx, fac) {
    this.val = val;
    this.idx = idx;
    this.fac = fac;
  }

  Token subToken() {
    return this.createToken(this.val.args[0], this.idx);
  }

  @override
  extractSchema() {
    var schema = this.createToken(this.val.args[0], 0);
    return schema.extractSchema();
  }

  @override
  extractSignature() {
    var schema = this.createToken(this.val.args[0], 0);
    return [...schema.extractSignature(), []];
  }

  @override
  execute(dynamic val, var semantic) {
    if (val.prim == 'None') {
      return null;
    }

    var schema = this.createToken(this.val.args[0], 0);
    return schema.execute(val.args[0], semantic);
  }
}
