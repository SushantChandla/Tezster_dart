import 'package:tezster_dart/packages/taquito-michelson-encoder/src/schema/storage.dart';
import 'package:tezster_dart/packages/taquito/src/contract/interface.dart';

class BigMapAbstraction {
  BigInt id;
  Schema schema;
  ContractProvider provider;
  BigMapAbstraction(BigInt id, Schema schema, ContractProvider provider) {
    this.id = id;
    this.schema = schema;
    this.provider = provider;
  }

  toJSON() {
    return this.id.toString();
  }

  toString() {
    return this.id.toString();
  }

  get<T>(keyToEncode, block) async {
    try {
      // var  id = await this.provider.getBigMapKeyByID<T>(this.id.toString(), keyToEncode, this.schema, block);
      return id;
    } catch (e) {
      // if (e instanceof HttpResponseError && e.status === STATUS_CODE.NOT_FOUND) {
      // return undefined;
      // } else {
      // throw e;
      // }
    }
  }
}
