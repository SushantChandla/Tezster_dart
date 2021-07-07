import 'package:tezster_dart/packages/taquito-michelson-encoder/src/schema/storage.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';
import 'package:tezster_dart/packages/taquito/src/contract/big-map.dart';
import 'package:tezster_dart/packages/taquito/src/contract/contract.dart';
import 'package:tezster_dart/packages/taquito/src/contract/interface.dart';

dynamic smartContractAbstractionSemantic(ContractProvider provider) {
  return {
    'big_map': (val, code) {
      if (val != null || val.int == null) {
        return {};
      } else {
        var schema = Schema(code);
        return BigMapAbstraction(val.int, schema, provider);
      }
    }
  };
}
