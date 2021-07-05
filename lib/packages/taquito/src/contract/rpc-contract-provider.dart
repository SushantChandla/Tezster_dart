import 'package:tezster_dart/packages/taquito/context.dart';
import 'package:tezster_dart/packages/taquito/src/contract/contract.dart';
import 'package:tezster_dart/packages/taquito/src/contract/interface.dart';
import 'package:tezster_dart/packages/taquito/src/operations/operation-emitter.dart';

class RpcContractProvider extends OperationEmitter
    implements ContractProvider, StorageProvider {
  RpcContractProvider(Context context, EstimationProvider estimator)
      : super(context);

  Future<T> at<T extends ContractAbstraction<ContractProvider>>(
      String address,
      contractAbstractionComposer(
          ContractAbstraction<ContractProvider> abs, Context context)) async {
    var script = await this.rpc.getScript(address);
  }
}
