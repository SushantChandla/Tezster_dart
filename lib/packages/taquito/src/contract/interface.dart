import 'package:tezster_dart/packages/taquito-michelson-encoder/src/schema/storage.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';
import 'package:tezster_dart/packages/taquito/src/contract/contract.dart';

class EstimationProvider {}

class StorageProvider {
  Future<T> getStorage<T>(String contract, var schema) {}
}

abstract class ContractProvider extends StorageProvider {
  Future<List<dynamic>> at<T extends ContractAbstraction<ContractProvider>>(
    String address,
  );
}
