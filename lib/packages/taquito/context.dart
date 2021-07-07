import 'package:tezster_dart/packages/taquito-rpc/src/taquito-rpc.dart';
import 'package:tezster_dart/packages/taquito/src/contract/rpc-contract-provider.dart';
import 'package:tezster_dart/packages/taquito/src/contract/rpc-estimate-provider.dart';

class Context {
  RpcClient _rpcClient;
  var estimate;
  var contract;

  Context(String rpc) {
    _rpcClient = RpcClient(rpc);
    estimate = new RPCEstimateProvider(this);
    contract = RpcContractProvider(this, estimate);
  }

  get rpc {
    return this._rpcClient;
  }
}
