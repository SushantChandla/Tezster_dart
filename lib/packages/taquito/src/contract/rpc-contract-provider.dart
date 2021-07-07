import 'package:tezster_dart/packages/taquito-michelson-encoder/src/schema/storage.dart';
import 'package:tezster_dart/packages/taquito/context.dart';
import 'package:tezster_dart/packages/taquito/src/contract/contract.dart';
import 'package:tezster_dart/packages/taquito/src/contract/interface.dart';
import 'package:tezster_dart/packages/taquito/src/contract/semantic.dart';
import 'package:tezster_dart/packages/taquito/src/operations/operation-emitter.dart';

class RpcContractProvider extends OperationEmitter
    implements ContractProvider, StorageProvider {
  RpcContractProvider(Context context, EstimationProvider estimator)
      : super(context);

  Future<T> getStorage<T>(String contract, var schema) async {
    if (schema == null) {
      schema = await this.rpc().getScript(contract);
    }

    Schema contractSchema;
    if (Schema.isSchema(schema)) {
      contractSchema = schema;
    } else {
      contractSchema = Schema.fromRPCResponse(schema);
    }

    var storage = await this.rpc().getStorage(contract);
    return contractSchema.execute(
        storage, smartContractAbstractionSemantic(this)) as T;
  }

  Future<List<dynamic>> at<T extends ContractAbstraction<ContractProvider>>(
    String address,
  ) async {
    var script; // = await rpc().getScript(address);
    var entrypoints = await this.rpc().getEntrypoints(address);
    var blockHeader = await this.rpc().getBlockHeader();
    var chainId = blockHeader.chainId;
    var abs = new ContractAbstraction(
        address, script, this, this, entrypoints, chainId);
    return [abs, context];
  }
}
