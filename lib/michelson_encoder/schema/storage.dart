import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/tokens/bigmap.dart';
import 'package:tezster_dart/michelson_encoder/tokens/createToken.dart';
import 'package:tezster_dart/michelson_encoder/tokens/or.dart';
import 'package:tezster_dart/michelson_encoder/tokens/pair.dart';
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

class Schema {
  Token _root;
  BigMapToken _bigMap;

  bool schemaTypeSymbol = true;

  static isSchema(dynamic obj) {
    return obj != null && obj.schemaTypeSymbol == true;
  }

  dynamic encodeObject(dynamic val) {
    return _root.encodeObject(val);
  }
  
  Schema(MichelsonV1Expression val) {
    _root = createToken(val, 0);
    if (_root is BigMapToken) {
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
    return _findValuei(_root.val.jsonCopy, storage, valueType);
  }

  _findValuei(schema, storage, valuetoFind) {
    if (_deepEqualc(schema, valuetoFind)) {
      return storage;
    }
    if (schema is List || schema['prim'] == 'pair') {
      if (schema['args'] == null && storage['args'] == null) {
        throw new Exception('Tokens have no arguments');
      }
      var sch = collapsec(schema);
      var str = collapsec(storage, prim: 'Pair');
      var s = _findValuei(sch['args'][0], str['args'][0], valuetoFind);
      if (s != null) return s;
      if (sch['args'].length >= 2 && str['args'].length >= 2) {
        var j = _findValuei(sch['args'][1], str['args'][1], valuetoFind);
        if (j != null) return j;
      }
      return null;
    }
  }

  // _findValue(schema, storage, valueToFind) {
  //   if (_deepEqual(valueToFind, schema)) {
  //     return storage;
  //   }

  //   if (schema is List ||
  //       (schema is MichelsonV1Expression && schema.prim == 'pair') ||
  //       schema is Map && schema['prim'] == 'pair') {
  //     MichelsonV1Expression sch = collapse(schema);
  //     MichelsonV1Expression str = collapse(storage, prim: 'Pair');
  //     if (sch.args == null || str.args == null) {
  //       throw new Exception('Tokens have no arguments'); // unlikely
  //     }
  //     var s = _findValue(sch.args[0], str.args[0], valueToFind);
  //     if (s != null) return s;
  //     if (sch.args.length >= 2 && str.args.length >= 2) {
  //       var j = _findValue(sch.args[1], str.args[1], valueToFind);
  //       if (j != null) return j;
  //     }
  //     return null;
  //   }
  // }

  // _deepEqual(a, b) {
  //   var ac = collapse(a);
  //   var bc = collapse(b);
  //   return ac.prim == bc.prim &&
  //       (ac.args == null && bc.args == null ||
  //           ac.args != null &&
  //               bc.args != null &&
  //               ac.args.length == bc.args.length &&
  //               allListEqual(ac.args, bc.args) &&
  //               (ac.annots == null && bc.annots == null ||
  //                   ac.annots != null &&
  //                       bc.annots != null &&
  //                       ac.annots.length == bc.annots.length &&
  //                       allListEqual(ac.annots, bc.annots)));
  // }

  bool allListEqual(List a, List b) {
    for (int i = 0; i < a.length; i++) {
      if (a[i].toString() != b[i].toString()) return false;
    }
    return true;
  }

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

    return this._bigMap.valueSchema.execute(key, semantics: semantics);
  }

  // collapse(val, {prim = PairToken.prim}) {
  //   if (val is List) {
  //     return collapse({'prim': prim, 'args': val}, prim: prim);
  //   }
  //   if (val is Map) {
  //     if (val['args'] != null) return MichelsonV1Expression.j(val);

  //     return collapse(MichelsonV1Expression(
  //       prim: prim,
  //       args: val.values.toList(),
  //     ));
  //   }

  //   if (val.prim == prim && val.args.length > 2) {
  //     return val
  //       ..args = [
  //         val.args[0],
  //         {'prim': prim, 'args': (val.args as List).sublist(1)}
  //       ];
  //   }
  //   return val;
  // }

  _deepEqualc(a, b) {
    return a['prim'] == b['prim'] &&
        (a['args'] == null && b['args'] == null ||
            a['args'] != null &&
                b['args'] != null &&
                a['args'].length == b['args'].length &&
                allListEqual(a['args'], b['args']) &&
                (a['annots'] == null && b['annots'] == null ||
                    a['annots'] != null &&
                        b['annots'] != null &&
                        a['annots'].length == b['annots'].length &&
                        allListEqual(a['annots'], b['annots'])));
  }

  collapsec(val, {prim = PairToken.prim}) {
    if (val is List) {
      return collapse(
        {'prim': prim, 'args': val},
      );
    }
    if (val['prim'] == prim && val['args'].length > 2) {
      var t = val;
      t['args'] = [
        val['args'][0],
        {'prim': prim, 'args': (val['args'] as List).sublist(1)}
      ];
      return t;
    }
    return val;
  }

  encodeBigMapKey(key) {
    if (_bigMap == null) {
      throw new Exception('No big map schema');
    }

    try {
      return _bigMap.keySchema.toBigMapKey(key);
    } catch (ex) {
      throw new Exception('Unable to encode big map key: ' + ex);
    }
  }
}
