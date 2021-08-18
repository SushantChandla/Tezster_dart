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
    Map<String, dynamic> parameter;
    if (script != null) {
      parameter =
          script.code.firstWhere((element) => element['prim'] == 'parameter');
    }
    if (parameter == null && parameter['args'].runtimeType == List) {
      throw new Exception("'Invalid rpc response passed as arguments");
    }
    MichelsonV1Expression data = MichelsonV1Expression();
    data.prim = parameter['args'][0]['prim'];
    data.args = parameter['args'][0]['args'];

    return ParameterSchema(data);
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

  Map get extractSchema {
    return _root.extractSchema();
  }

  get extractSignatures {
    return _root.extractSignature();
  }
}
