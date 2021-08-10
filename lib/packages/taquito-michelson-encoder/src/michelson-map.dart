import 'package:tezster_dart/packages/fast-json-stable-stringify/index.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/schema/storage.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

var michelsonMapTypeSymbol = Symbol('taquito-michelson-map-type-symbol');

isMapType(
  MichelsonV1Expression value,
) =>
    {
      value.args != null &&
          value.args.runtimeType == List &&
          value.args.length == 2,
    };

class MichelsonMap<K, T> {
  var _valueMap = new Map<String, T>();
  var _keyMap = new Map<String, K>();
  Schema _keySchema;
  Schema _valueSchema;

  var michelsonMapTypeSymbol = true;

  MichelsonMap(MichelsonV1Expression mapType) {
    if (mapType != null) {
      this.setType(mapType);
    }
  }

  static isMichelsonMap(dynamic obj) {
    return obj && obj.michelsonMapTypeSymbol == true;
  }

  _typecheckKey(K key) {
    if (_keySchema != null) {
      return _keySchema.typecheck(key);
    }

    return true;
  }

  _assertTypecheckKey(K key) {
    if (!_typecheckKey(key)) {
      throw new Exception("key not compliant with underlying michelson type");
    }
  }

  _typecheckValue(T value) {
    if (this._valueSchema != null) {
      return this._valueSchema.typecheck(value);
    }

    return true;
  }

  _assertTypecheckValue(T value) {
    if (!this._typecheckValue(value)) {
      throw new Exception('value not compliant with underlying michelson type');
    }
  }

  serializeDeterministically(K key) {
    return jsonStringify(key);
  }

  set(K key, T value) {
    _assertTypecheckKey(key);
    this._assertTypecheckValue(value);

    var strKey = this.serializeDeterministically(key);
    this._keyMap.addAll({strKey: key});
    this._valueMap.addAll({strKey: value});
  }

  setType(MichelsonV1Expression mapType) {
    if (!isMapType(mapType)) {
      throw new Exception('mapType is not a valid michelson map type');
    }
    MichelsonV1Expression manType = MichelsonV1Expression();
    manType.prim = mapType.args[0]['prim'];
    manType.args = mapType.args[0]['args'];
    manType.annots = mapType.args[0]['annots'];

    _keySchema = new Schema(manType);

    manType.prim = mapType.args[1]['prim'];
    manType.args = mapType.args[1]['args'];
    manType.annots = mapType.args[1]['annots'];

    _valueSchema = new Schema(manType);
  }

  Iterable<K> keys() sync* {
    for (var data in this.entries()) {
      yield data[0];
    }
  }

  Iterable<T> values() sync* {
    for (var data in this.entries()) {
      yield data[1];
    }
  }

  Iterable entries() sync* {
    for (var key in this._valueMap.keys) {
      yield [this._keyMap[key], this._valueMap[key]];
    }
  }

  get(K key) {
    this._assertTypecheckKey(key);

    var strKey = this.serializeDeterministically(key);
    return this._valueMap[strKey];
  }
}
