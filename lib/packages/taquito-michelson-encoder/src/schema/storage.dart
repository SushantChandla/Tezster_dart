import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/bigmap.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/createToken.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/or.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/pair.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

var schemaTypeSymbol = Symbol('taquito-schema-type-symbol');

class Schema {
  Token _root;
  BigMapToken _bigMap;

  bool schemaTypeSymbol = true;

  static isSchema(dynamic obj) {
    return obj != null && obj.schemaTypeSymbol == true;
  }

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

  typecheck(val) {
    if (this._root.runtimeType == BigMapToken && val.runtimeType == int) {
      return true;
    }
    try {
      this._root.encodeObject(val);
      return true;
    } catch (ex) {
      return false;
    }
  }

  _isExpressionExtended(MichelsonV1Expression val) {
    if (val.prim != null && val.args.runtimeType == List) {
      return true;
    }
    return false;
  }

  _removeTopLevelAnnotation(dynamic obj) {
    if (_root.runtimeType == PairToken || _root.runtimeType == OrToken) {
      if (_root.hasAnnotations() && obj is Map && obj.keys.length == 1) {
        return obj[obj.keys.first];
      }
    }
    return obj;
  }

  execute(dynamic val, var semantics) {
    var storage = _root.execute(val, semantics: semantics);
    var data = _removeTopLevelAnnotation(storage);
    return data;
  }

  static fromRPCResponse(ScriptResponse script) {
    var storage;
    if (script != null) {
      storage =
          script.code.firstWhere((element) => element['prim'] == 'storage');
    }
    if (storage == null) {
      throw new Exception("Invalid rpc response passed as arguments");
    }

    MichelsonV1Expression data = MichelsonV1Expression();
    data.prim = storage['args'][0]['prim'];
    data.args = storage['args'][0]['args'];

    return Schema(data);
  }

  executeOnBigMapValue(key, semantics) {
    if (this._bigMap == null) {
      throw Exception("No big map schema");
    }

    return this._bigMap.valueSchema.execute(key, semantics);
  }
}
