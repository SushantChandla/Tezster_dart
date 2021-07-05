import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

class ParameterSchema {
  Token _root;

  static fromRPCResponse(ScriptResponse script) {
    MichelsonV1ExpressionExtended parameter;
    if (script != null) {
      parameter =
          script.code.firstWhere((element) => element.prim == 'parameter');
    }
    if (parameter != null && parameter.args.runtimeType == List) {
      throw new Exception("'Invalid rpc response passed as arguments");
    }
  }
}
