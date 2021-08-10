import 'package:tezster_dart/packages/taquito-michelson-encoder/src/schema/storage.dart';
import 'package:tezster_dart/packages/taquito/src/contract/big-map.dart';
import 'package:tezster_dart/packages/taquito/src/contract/interface.dart';
import 'package:tezster_dart/packages/taquito/src/contract/sapling-state-abstraction.dart';

dynamic smartContractAbstractionSemantic(ContractProvider provider) {
  return {
    'big_map': (val, code) {
      if (val == null || !val.containsKey('int') || val['int'] == null) {
        return {};
      } else {
        var schema = Schema(code);
        return BigMapAbstraction(BigInt.from(double.parse(val['int'])), schema, provider);
      }
    },
    'sapling_state': (val) {
      if (val == null || !val.containsKey('int') || val['int'] == null) {
        return {};
      } else {
        return SaplingStateAbstraction(val['int'], provider);
      }
    }
  };
}
