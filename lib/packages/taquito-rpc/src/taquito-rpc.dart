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

  _createURL(String path) {
    if (url.substring(url.length - 1, url.length) == '/') {
      return url.substring(0, url.length - 1);
    } else {
      return url;
    }
  }

  Future<ScriptResponse> getScript(String address,
      {String block = defaultRPCOptions}) async {
    return this.httpBackend.createRequest<ScriptResponse>(
          url: this._createURL(
              '/chains/${this.chain}/blocks/$block/context/contracts/$address}/script'),
          methods: "GET",
        );
  }
}
