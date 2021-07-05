import 'package:tezster_dart/packages/taquito-michelson-encoder/src/schema/parameter.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/schema/storage.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';
import 'package:tezster_dart/packages/taquito/src/contract/interface.dart';

class ContractAbstraction<T extends ContractProvider> {
  Schema schema;
  ParameterSchema parameterSchema;

  ContractAbstraction(
      String address,
      ScriptResponse script,
      T provider,
      StorageProvider storageProvider,
      EntrypointsResponse entrypoints,
      String chainId) {
    this.schema = Schema.fromRPCResponse(script);
    this.parameterSchema = ParameterSchema.fromRPCResponse(script);
    _initializeMethods(
        this, address, provider, entrypoints.entrypoints, chainId);
  }
  _initializeMethods(
    ContractAbstraction<T> currentContract,
    String address,
    T provider,
    Map<String, String> object,
    String chainId,
  ) {}
}
