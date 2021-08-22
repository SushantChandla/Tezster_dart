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
    script = await HttpHelper.performGetRequest(rpcServer,
        "chains/$chain/blocks/$block/context/contracts/$address/script");
    contractSchema = Schema.fromFromScript(script);
    contractStorage = await HttpHelper.performGetRequest(rpcServer,
        "chains/$chain/blocks/$block/context/contracts/$address/storage");
    var storageResponse = MichelsonV1Expression.j(contractStorage);
    return contractSchema.execute(
        storageResponse, _smartContractAbstractionSemantic());
  }

  dynamic _smartContractAbstractionSemantic() {
    return {
      'big_map': (val, code) {
        if (val is MichelsonV1Expression) return {};
        if (val == null || !val.containsKey('int') || val['int'] == null) {
          return {};
        } else {
          return BigMapAbstraction(BigInt.from(double.parse(val['int'])));
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

  Future getSaplingDiffById(String id, {block = 'head', chain = 'main'}) async {
    var saplingState = await HttpHelper.performGetRequest(
        rpcServer, "chains/$chain/blocks/$block/context/sapling/$id/get_diff");
    return saplingState;
  }
}
