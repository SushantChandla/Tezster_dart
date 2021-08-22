import 'package:tezster_dart/michelson_encoder/schema/storage.dart';

class BigMapAbstraction {
  BigInt id;
  BigMapAbstraction(BigInt id) {
    this.id = id;
  }

  toJSON() {
    return this.id.toString();
  }

  toString() {
    return this.id.toString();
  }

  get<T>(keyToEncode, Schema schema, {block}) async {
    try {
      var id = await getBigMapKeyByID(this.id.toString(), keyToEncode, schema,
          block: block);
      return id;
    } catch (e) {
      if (e.status == 404) {
        return null;
      } else {
        throw e;
      }
    }
  }

  static getBigMapKeyByID(id, keyToEncode, schema, {block}) async {
    var _key = schema.EncodeBigMapKey(keyToEncode).key;
    var _type = schema.EncodeBigMapKey(keyToEncode).type;
    // var packed  = await this.context. .packData({ data: key, type });

    // const encodedExpr = encodeExpr(packed);

    // const bigMapValue = block? await this.context.rpc.getBigMapExpr(id.toString(), encodedExpr, { block: String(block) }) : await this.context.rpc.getBigMapExpr(id.toString(), encodedExpr);

    // return schema.ExecuteOnBigMapValue(bigMapValue, smartContractAbstractionSemantic(this)) as T;
  }
}
