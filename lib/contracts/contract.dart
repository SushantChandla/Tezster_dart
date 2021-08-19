import 'package:tezster_dart/contracts/big-map.dart';
import 'package:tezster_dart/contracts/sapling-state-abstraction.dart';
import 'package:tezster_dart/helper/http_helper.dart';
import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/schema/storage.dart';

class Contract {
  String address;
  String rpcServer;
  Schema contractSchema;
  Contract({this.rpcServer, this.address})
      : assert(rpcServer != null),
        assert(address != null);

  Future<Map> getStorage({
    String block = 'head',
    String chain = 'main',
  }) async {
    var response = await HttpHelper.performGetRequest(rpcServer,
        "chains/$chain/blocks/$block/context/contracts/$address/script");
  
    var schema = Schema.fromFromScript(response);
    var storageResponse = MichelsonV1Expression();
    var storage = await HttpHelper.performGetRequest(rpcServer,
        "chains/$chain/blocks/$block/context/contracts/$address/storage");


    storageResponse.annots = storage['annots'];
    storageResponse.args = storage['args'];
    storageResponse.prim = storage['prim'];
    return schema.execute(storageResponse, _smartContractAbstractionSemantic());
  }

  dynamic _smartContractAbstractionSemantic() {
    return {
      'big_map': (val, code) {
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
}
