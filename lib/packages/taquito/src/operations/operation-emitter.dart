import 'package:tezster_dart/packages/taquito-rpc/src/taquito-rpc.dart';
import 'package:tezster_dart/packages/taquito/context.dart';

abstract class OperationEmitter {
  Context context;
  OperationEmitter(Context context) {
    this.context = context;
  }
  RpcClient rpc() {
    return this.context.rpc;
  }
}
