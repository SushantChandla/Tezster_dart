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

  bool isNumeric(s) {
    if (s == null) {
      return false;
    }
    // ignore: deprecated_member_use
    var integer;
    try {
      integer = int.parse(s.toString()) != null;
      return true;
    } catch (e) {
      return false;
    }
    // return int.parse(s.toString()) != null;
  }

  typecheck(val) {
    if (!(val is int)) val = isNumeric(val) ? int.parse(val) : val;
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

  FindFirstInTopLevelPair<T extends MichelsonV1Expression>(storage, valueType) {
    return _findValue(_root.val, storage, valueType);
  }

  _findValue(schema, storage, valueToFind) {
    if (_deepEqual(valueToFind, schema)) {
      return storage;
    }
    if (schema is List || schema['prim'] == 'pair') {
      var sch = collapse(schema);
      var str = collapse(storage, prim: 'Pair');
      if (sch.args == null || str.args == null) {
        throw new Exception('Tokens have no arguments'); // unlikely
      }
      return _findValue(sch.args[0], str.args[0], valueToFind) ||
          _findValue(sch.args[1], str.args[1], valueToFind);
    }
  }

  _deepEqual(a, b) {
    var ac = collapse(a);
    var bc = collapse(b);
    return ac.prim == bc.prim &&
        (ac.args == null && bc.args == null ||
            ac.args != null &&
                bc.args != null &&
                ac.args.length == bc.args.length &&
                ac.args.every((v, i) => _deepEqual(v, bc.args[i]))) &&
        (ac.annots == null && bc.annots == null ||
            ac.annots != null &&
                bc.annots != null &&
                ac.annots.length == bc.annots.length &&
                ac.annots.every((v, i) => v == bc.annots[i]));
  }
}
