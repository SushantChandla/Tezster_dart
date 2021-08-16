import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

class LambdaToken extends Token {
  static String prim = 'lambda';

  LambdaToken(MichelsonV1Expression val, int idx, var fac)
      : super(val, idx, fac);

  @override
  execute(val, {semantics}) {
    return val;
    // if (val.string != null) {
    //   return val.string;
    // } else {
    //   return val;
    // }
  }

  @override
  extractSchema() {
    MichelsonV1Expression michelsonV1Expression = MichelsonV1Expression();
    michelsonV1Expression.prim = this.val.args[0]['prim'];
    michelsonV1Expression.args = this.val.args[0]['args'];
    michelsonV1Expression.annots = this.val.args[0]['annots'];
    var leftToken = this.createToken(michelsonV1Expression, this.idx);
    MichelsonV1Expression michelsonV1Expression1 = MichelsonV1Expression();
    michelsonV1Expression1.prim = this.val.args[1]['prim'];
    michelsonV1Expression1.args = this.val.args[1]['args'];
    michelsonV1Expression1.annots = this.val.args[1]['annots'];
    var rightToken = this.createToken(michelsonV1Expression1, this.idx + 1);
    return {
      [LambdaToken.prim]: {
        'parameters': leftToken.extractSchema(),
        'returns': rightToken.extractSchema(),
      },
    };
  }

  @override
  encodeObject(val) {
    return val;
  }

  @override
  encode(List args) {
    // TODO: implement encode
    throw UnimplementedError();
  }
}
