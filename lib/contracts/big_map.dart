import 'dart:convert';

import 'package:tezster_dart/contracts/sapling_state_abstraction.dart';
import 'package:tezster_dart/contracts/utils/utils.dart';
import 'package:tezster_dart/helper/http_helper.dart';
import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/schema/storage.dart';

class BigMapAbstraction {
  BigInt? id;
  BigMapAbstraction(BigInt? id, Schema schema) {
    this.id = id;
    this._bigMapSchema = schema;
  }
  late Schema _bigMapSchema;

  toJSON() {
    return this.id.toString();
  }

  toString() {
    return this.id.toString();
  }

  get<T>(rpc, keyToEncode, {block}) async {
    try {
      var id = await getBigMapKeyByID(rpc, keyToEncode, block: block);
      return id;
    } catch (e) {
      if (e is Map && e['status'] == 404) {
        return null;
      } else {
        throw Exception('Error $e');
      }
    }
  }

  getBigMapKeyByID(String rpc, keyToEncode, {block}) async {
    var _key = _bigMapSchema.encodeBigMapKey(keyToEncode)['key'];
    var _type = _bigMapSchema.encodeBigMapKey(keyToEncode)['type'];
    var res = await _packData(rpc, {'data': _key, 'type': _type});
    var encodedExpr = encodeExpr(res['packed']);

    var bigMapValue = await _getBigMapExpr(rpc, encodedExpr);

    return _bigMapSchema.executeOnBigMapValue(
        bigMapValue, _smartContractAbstractionSemantic()['big_map']);
  }

  _packData(rpc, data, {block = 'head', chain = 'main'}) async {
    dynamic r = await HttpHelper.performPostRequest(
        rpc, '/chains/$chain/blocks/$block/helpers/scripts/pack_data', data,);
    r = jsonDecode(r);
    dynamic formattedGas = r['gas'];
    var tryBigInt = BigInt.tryParse(formattedGas);
    if (tryBigInt != null) {
      formattedGas = tryBigInt;
    }
    r['gas'] = formattedGas;
    return r;
  }

  _getBigMapExpr(rpc, expr, {block = 'head', chain = 'main'}) async {
    return HttpHelper.performGetRequest(
        rpc, '/chains/$chain/blocks/$block/context/big_maps/$id/$expr');
  }
}

dynamic _smartContractAbstractionSemantic() {
  return {
    'big_map': (val, code) {
      if (val is MichelsonV1Expression) return {};
      if (val == null || !val.containsKey('int') || val['int'] == null) {
        return {};
      } else {
        return BigMapAbstraction(
            BigInt.from(
              double.parse(val['int']),
            ),
            code is MichelsonV1Expression
                ? Schema(code)
                : Schema(MichelsonV1Expression.j(code)));
      }
    },
    'sapling_state': (val) {
      if (val == null || !val.containsKey('int') || val['int'] == null) {
        return {};
      } else {
        return SaplingStateAbstraction(val['int']);
      }
    }
  };
}
