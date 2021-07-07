import 'package:tezster_dart/packages/taquito-michelson-encoder/src/schema/storage.dart';
import 'package:tezster_dart/packages/taquito/src/contract/interface.dart';

class BigMapAbstraction {
  double id;
  Schema schema;
  ContractProvider provider;
  BigMapAbstraction(double id, Schema schema, ContractProvider provider) {
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
}
