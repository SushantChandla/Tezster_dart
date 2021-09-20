import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

class LambdaToken extends Token {
  static String prim = 'lambda';

  LambdaToken(MichelsonV1Expression? val, int idx, var fac)
      : super(val, idx, fac);

  @override
  execute(val, {semantics}) {
    if (val.string != null) {
      return val.string;
    } else {
      return val;
    }
  }

  @override
  extractSchema() {
    MichelsonV1Expression michelsonV1Expression =
        MichelsonV1Expression.j(val!.args![0]);
    var leftToken = this.createToken(michelsonV1Expression, this.idx);
    michelsonV1Expression = MichelsonV1Expression.j(val!.args![1]);
    var rightToken = this.createToken(michelsonV1Expression, this.idx! + 1);
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

  encode(args) {
    var val = args.removeLast();
    return val;
  }
}
