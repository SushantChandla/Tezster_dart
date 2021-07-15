import 'package:tezster_dart/helper/http_helper.dart';
import 'package:tezster_dart/packages/taquito-http-utils/src/taquito-http-utils.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';


const defaultChain = 'main';
const String defaultRPCOptions = 'head';

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
    StorageResponse storageResponse =
        StorageResponse(response['prim'], response['args'], response['annots']);
    return storageResponse;
  }

  Future<ScriptResponse> getScript(String address,
      {String block = defaultRPCOptions}) async {
    var response = await HttpHelper.performGetRequest(url,
        "chains/${this.chain}/blocks/$block/context/contracts/$address/script");
    ScriptResponse scriptResponse =
        ScriptResponse(response['code'], response['storage']);
    return scriptResponse;
  }

  Future<EntrypointsResponse> getEntrypoints(String contract,
      {String block = defaultRPCOptions}) async {
    var response = await HttpHelper.performGetRequest(url,
        "chains/${this.chain}/blocks/$block/context/contracts/$contract/entrypoints");
    EntrypointsResponse entrypointsResponse =
        EntrypointsResponse(response['entrypoints']);
    return entrypointsResponse;
  }

  Future<BlockHeaderResponse> getBlockHeader(
      {String block = defaultRPCOptions}) async {
    var response = await HttpHelper.performGetRequest(
        url, "chains/${this.chain}/blocks/$block/header");
    BlockHeaderResponse blockHeaderResponse = BlockHeaderResponse(
      response['protocol'],
      response['chain_id'],
      response['hash'],
      response['level'],
      response['proto'],
      response['predecessor'],
      response['timestamp'],
      response['validation_pass'],
      response['operations_hash'],
      response['fitness'],
      response['context'],
      response['priority'],
      response['proof_of_work_nonce'],
      response['signature'],
    );
    return blockHeaderResponse;
  }

  Future<SaplingDiffResponse> getSaplingDiffById(String id,
      {String block = defaultRPCOptions}) async {
    var response = await HttpHelper.performGetRequest(
        url, "chains/${this.chain}/blocks/$block/context/sapling/$id/get_diff");
    return response;
  }
}
