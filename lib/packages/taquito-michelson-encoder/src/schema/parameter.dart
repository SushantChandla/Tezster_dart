import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/createToken.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/option.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/or.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

class ParameterSchema {
  Token _root;

  ParameterSchema(MichelsonV1Expression val) {
    _root = createToken(val, 0);
  }

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

  get isMultipleEntryPoint {
    return (_root.runtimeType == OrToken ||
        (_root.runtimeType == OptionToken && _root.createToken() == OrToken));
  }

  get hasAnnotation {
    if (this.isMultipleEntryPoint) {
      return this.extractSchema.keys.first != '0';
    } else {
      return true;
    }
  }

  Map<String, String> get extractSchema {
    return _root.extractSchema();
  }

  get extractSignatures {
    return _root.extractSignature();
  }
}
