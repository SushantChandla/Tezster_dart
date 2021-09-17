import 'package:tezster_dart/contracts/big_map.dart';
import 'package:tezster_dart/contracts/sapling_state_abstraction.dart';
import 'package:tezster_dart/helper/http_helper.dart';
import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/schema/storage.dart';

class Contract {
  String address;
  String rpcServer;
  Schema contractSchema;
  Map script;
  Map contractStorage;
  Contract({this.rpcServer, this.address})
      : assert(rpcServer != null),
        assert(address != null);

  Future<Map> getStorage({
    String block = 'head',
    String chain = 'main',
  }) async {
    await verifySchemaAndStorage(block: block, chain: chain);
    var storageResponse = MichelsonV1Expression.j(contractStorage);
    return contractSchema.execute(
        storageResponse, _smartContractAbstractionSemantic());
  }

  Future<bool> verifySchemaAndStorage({
    String block = 'head',
    String chain = 'main',
  }) async {
    if (contractSchema == null) {
      script = await HttpHelper.performGetRequest(rpcServer,
          "chains/$chain/blocks/$block/context/contracts/$address/script");
      contractSchema = Schema.fromFromScript(script);
      print(contractSchema);
    }
    contractStorage = await HttpHelper.performGetRequest(rpcServer,
        "chains/$chain/blocks/$block/context/contracts/$address/storage");
    return true;
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
}
