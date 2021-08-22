import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/tokens/bigmap.dart';
import 'package:tezster_dart/michelson_encoder/tokens/createToken.dart';
import 'package:tezster_dart/michelson_encoder/tokens/or.dart';
import 'package:tezster_dart/michelson_encoder/tokens/pair.dart';
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

var schemaTypeSymbol = Symbol('schema-type-symbol');

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
      _bigMap = _root as BigMapToken;
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
      var x = this._root.encodeObject(val);
      if (x != null) return true;
    } catch (ex) {
      return false;
    }
    return false;
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

  findFirstInTopLevelPair<T extends MichelsonV1Expression>(storage, valueType) {
    return _findValue(_root.val, storage, valueType);
  }

  _findValue(schema, storage, valueToFind) {
    if (_deepEqual(valueToFind, schema)) {
      return storage;
    }

    if (schema is List ||
        (schema is MichelsonV1Expression && schema.prim == 'pair') ||
        schema is Map && schema['prim'] == 'pair') {
      var sch = collapse(schema);
      var str = collapse(storage, prim: 'Pair');
      // if (sch['args'] == null || str['args'] == null) {
      //   throw new Exception('Tokens have no arguments'); // unlikely
      // }
      return _findValue(sch[0], str[0], valueToFind) ||
          _findValue(sch[1], str[1], valueToFind);
    }
  }

  _deepEqual(a, b) {
    var ac1 = collapse(a);
    var bc1 = collapse(b);
    if (ac1 is List && bc1 is List) {
      for (int i = 0; i < ac1.length; i++) {
        var ac = ac1[i];
        var bc = bc1[i];
        if (!(ac['prim'] == bc['prim'] &&
            (ac['args'] == null && bc['args'] == null ||
                ac['args'] != null &&
                    bc['args'] != null &&
                    ac['args'].length == ac['args'].length &&
                    allListEqual(ac['args'], bc['args']) &&
                    (ac['annots'] == null && bc['annots'] == null ||
                        ac['annots'] != null &&
                            bc['annots'] != null &&
                            ac['annots'].length == bc['annots'].length &&
                            allListEqual(ac['annots'], bc['annots']))))) {
          return false;
        }
      }
      return true;
    }
    return false;
    // else if (ac.runtimeType == bc.runtimeType) {
    //   if (ac is List) {
    //     if (ac.length != bc.length) return false;
    //     for (int i = 0; i < ac.length; i++) {
    //       if (ac[i] != bc[i]) {
    //         return false;
    //       }
    //     }
    //     return true;
    //   }
    // }
    // return false;
  }

  bool allListEqual(List a, List b) {
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  // static fromRPCResponse(ScriptResponse script) {
  //   var storage;
  //   if (script != null) {
  //     storage =
  //         script.code.firstWhere((element) => element['prim'] == 'storage');
  //   }
  //   if (storage == null) {
  //     throw new Exception("Invalid rpc response passed as arguments");
  //   }

  //   MichelsonV1Expression data = MichelsonV1Expression();
  //   data.prim = storage['args'][0]['prim'];
  //   data.args = storage['args'][0]['args'];

  //   return Schema(data);
  // }

  static fromFromScript(Map<String, dynamic> script) {
    if (!script.containsKey('code')) {
      throw Exception('InvalidScript');
    }
    var storage =
        script['code'].firstWhere((element) => element['prim'] == 'storage');
    if (storage == null) {
      throw new Exception("Invalid rpc response passed as arguments");
    }

    MichelsonV1Expression data = MichelsonV1Expression.j(storage['args'][0]);

    return Schema(data);
  }

  executeOnBigMapValue(key, semantics) {
    if (this._bigMap == null) {
      throw Exception("No big map schema");
    }

    return this._bigMap.valueSchema.execute(key, semantics);
  }
}
