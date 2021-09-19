import 'dart:convert';

import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/schema/storage.dart';

var michelsonMapTypeSymbol = Symbol('michelson-map-type-symbol');

bool isMapType(
  MichelsonV1Expression value,
) =>
    value.args != null && value.args is List && value.args.length == 2;

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
    return obj != null && obj.michelsonMapTypeSymbol == true;
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
    return jsonEncode(_keySchema.encodeObject(key));
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
    MichelsonV1Expression t = MichelsonV1Expression.j(mapType.args[0]);

    _keySchema = new Schema(t);

    t = MichelsonV1Expression.j(mapType.args[1]);
    _valueSchema = new Schema(t);
  }

  Iterable<K> keys() sync* {
    for (var key in _keyMap.values) {
      yield key;
    }
  }

  Iterable<T> values() sync* {
    for (var data in _valueMap.values) {
      yield data;
    }
  }

  Iterable entries() sync* {
    for (var key in this._valueMap.keys) {
      yield [this._keyMap[key], this._valueMap[key]];
    }
  }

  get(K key, [String encodedKey]) {
    this._assertTypecheckKey(key);
    if (encodedKey != null) return _valueMap[encodedKey];
    var strKey = this.serializeDeterministically(key);
    return this._valueMap[strKey];
  }
}
