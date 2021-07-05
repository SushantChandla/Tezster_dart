import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/bigmap.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/createToken.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

class Schema {
  Token _root;
  BigMapToken _bigMap;
  Schema(MichelsonV1Expression val) {
    _root = createToken(val, 0);
    if (_root.runtimeType == BigMapToken) {
      _bigMap = _root;
    } else if (_isExpressionExtended(val) && val.prim == 'pair') {
      var exp = val.args[0];
      if (_isExpressionExtended(exp) && exp.prim == 'big_map') {
        _bigMap = new BigMapToken(exp, 0, createToken(exp, 0));
      }
    }
  }

  _isExpressionExtended(MichelsonV1ExpressionExtended val) {
    if (val.prim != null && val.args.runtimeType == List) {
      return true;
    }
    return false;
  }

  static fromRPCResponse(ScriptResponse script) {
    MichelsonV1ExpressionExtended storage;
    if (script != null) {
      storage = script.code.firstWhere((element) => element.prim == 'storage');
    }
    if (storage != null) {
      throw new Exception("Invalid rpc response passed as arguments");
    }

    return Schema(storage.args[0]);
  }
}
