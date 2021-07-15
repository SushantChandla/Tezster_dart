import 'package:tezster_dart/packages/taquito-rpc/src/taquito-rpc.dart';
import 'package:tezster_dart/packages/taquito/context.dart';
import 'package:tezster_dart/packages/taquito/src/contract/interface.dart';
import 'package:tezster_dart/packages/taquito/src/wallet/wallet.dart';

class SetProviderOptions {
  RpcClient rpc;
}

class TezosToolkit {
  Context _context;
  RpcClient _rpcClient;
  Wallet _wallet;

  TezosToolkit(String rpc) {
    _rpcClient = new RpcClient(rpc);
    _context = new Context(rpc);
    _wallet = Wallet(_context);
    setProvider(rpc: _rpcClient);
  }

  setProvider({RpcClient rpc}) {
    setRpcProvider(rpc);
  }

  setRpcProvider(RpcClient rpc) {
    if (rpc.runtimeType == RpcClient) {
      _rpcClient = rpc;
    }
  }

  ContractProvider get contract {
    return _context.contract;
  }

  get wallet {
    return this._wallet;
  }
}
