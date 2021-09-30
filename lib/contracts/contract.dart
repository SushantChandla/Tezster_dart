import 'package:tezster_dart/chain/tezos/tezos_node_writer.dart';
import 'package:tezster_dart/contracts/big_map.dart';
import 'package:tezster_dart/contracts/sapling_state_abstraction.dart';
import 'package:tezster_dart/helper/http_helper.dart';
import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/schema/storage.dart';
import 'package:tezster_dart/models/key_store_model.dart';
import 'package:tezster_dart/src/soft-signer/soft_signer.dart';
import 'package:tezster_dart/types/tezos/tezos_chain_types.dart';

class Contract {
  String address;
  String rpcServer;
  Schema? contractSchema;
  Map? script;
  Map? contractStorage;
  Contract({required this.rpcServer, required this.address})
      : assert(rpcServer != null),
        assert(address != null);

  Future<Map> getStorage({
    String block = 'head',
    String chain = 'main',
  }) async {
    await verifySchemaAndStorage(block: block, chain: chain);
    var storageResponse = MichelsonV1Expression.j(contractStorage);
    return (contractSchema!
            .execute(storageResponse, _smartContractAbstractionSemantic())) ??
        {};
  }

  Future<bool> verifySchemaAndStorage({
    String block = 'head',
    String chain = 'main',
  }) async {
    if (contractSchema == null) {
      script = await HttpHelper.performGetRequest(rpcServer,
          "chains/$chain/blocks/$block/context/contracts/$address/script");
      contractSchema = Schema.fromscript(script as Map<String, dynamic>);
    }
    contractStorage = await HttpHelper.performGetRequest(rpcServer,
        "chains/$chain/blocks/$block/context/contracts/$address/storage");
    return true;
  }

  Future<List<String>> listEntrypoints({
    String block = 'head',
    String chain = 'main',
  }) async {
    Map<String, dynamic> response = await HttpHelper.performGetRequest(
        rpcServer,
        "chains/$chain/blocks/$block/context/contracts/$address/entrypoints");
    return response['entrypoints'].keys.toList();
  }

  Future<String> getBalance({
    String block = 'head',
    String chain = 'main',
  }) async {
    return await HttpHelper.performGetRequest(rpcServer,
        "chains/$chain/blocks/$block/context/contracts/$address/balance",
        responseJson: false);
  }

  Future<Map> callEntrypoint({
    required SoftSigner signer,
    required KeyStoreModel keyStore,
    required int amount,
    required int fee,
    required int storageLimit,
    required int gasLimit,
    String entrypoint = 'default',
    dynamic parameters,
    TezosParameterFormat parameterFormat = TezosParameterFormat.Micheline,
    offset = 54,
  }) async {
    Map data = await TezosNodeWriter.sendContractInvocationOperationBatch(
        rpcServer,
        signer,
        keyStore,
        [address],
        [amount],
        fee,
        storageLimit,
        gasLimit,
        [entrypoint],
        [parameters],
        parameterFormat: parameterFormat,
        offset: offset);
    if (!(data['operationGroupID'] is String)) {
      throw Exception(data['operationGroupID'].toString());
    }
    return data;
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
