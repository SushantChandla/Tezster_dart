import 'package:tezster_dart/helper/http_helper.dart';
import 'package:tezster_dart/packages/taquito-http-utils/src/taquito-http-utils.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

// class RPCOptions {
//   String block;
//   RPCOptions(String block) {
//     this.block = block;
//   }
// }

const defaultChain = 'main';
const String defaultRPCOptions = 'head'; //RPCOptions('head');

class RpcClient {
  String url;
  String chain;
  HttpBackend httpBackend;

  RpcClient(String url, {String chain, HttpBackend httpBackend}) {
    this.url = url;
    this.chain = chain ?? defaultChain;
    this.httpBackend = httpBackend ?? HttpBackend();
  }

  Future<StorageResponse> getStorage(String address,
      {String block = defaultRPCOptions}) async {
    var response = await HttpHelper.performGetRequest(url,
        "chains/${this.chain}/blocks/$block/context/contracts/$address/storage");
    StorageResponse storageResponse;
    storageResponse.prim = response['prim'];
    storageResponse.args = response['args'];
    return storageResponse;
  }

  Future<ScriptResponse> getScript(String address,
      {String block = defaultRPCOptions}) async {
    var response = await HttpHelper.performGetRequest(url,
        "chains/${this.chain}/blocks/$block/context/contracts/$address/script");
    ScriptResponse scriptResponse;
    scriptResponse.code = response['code'];
    scriptResponse.storage = response['storage'];
    return scriptResponse;
  }

  Future<EntrypointsResponse> getEntrypoints(String contract,
      {String block = defaultRPCOptions}) async {
    var response = await HttpHelper.performGetRequest(url,
        "chains/${this.chain}/blocks/$block/context/contracts/$contract/entrypoints");
    EntrypointsResponse entrypointsResponse;
    entrypointsResponse.entrypoints = response['entrypoints'];
    return entrypointsResponse;
  }

  Future<BlockHeaderResponse> getBlockHeader(
      {String block = defaultRPCOptions}) async {
    var response = await HttpHelper.performGetRequest(
        url, "chains/$this.chain/blocks/$block/header");
    BlockHeaderResponse blockHeaderResponse;
    blockHeaderResponse.chainId = response['chian_id'];
    blockHeaderResponse.context = response['context'];
    blockHeaderResponse.fitness = response['fitness'];
    blockHeaderResponse.hash = response['hash'];
    blockHeaderResponse.level = response['level'];
    blockHeaderResponse.operationHash = response['operation_hash'];
    blockHeaderResponse.predecessor = response['[redecessor'];
    blockHeaderResponse.priority = response['priority'];
    blockHeaderResponse.proofOfWorkNonce = response['proof_of_work_nonce'];
    blockHeaderResponse.proto = response['proto'];
    blockHeaderResponse.protocol = response['protocol'];
    blockHeaderResponse.signature = response['signature'];
    blockHeaderResponse.timestamp = response['timestamp'];
    blockHeaderResponse.validationPass = response['validation_pass'];
    return blockHeaderResponse;
  }
}
