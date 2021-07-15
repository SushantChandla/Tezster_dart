import 'package:tezster_dart/packages/taquito/src/contract/contract.dart';

class EstimationProvider {}

class StorageProvider {
  getStorage<T>(String contract, var schema) {}
  getSaplingDiffById(String id, int block) {}
}

abstract class ContractProvider extends StorageProvider {
  Future<List<dynamic>> at<T extends ContractAbstraction<ContractProvider>>(
      String address,
      {contractAbstractionComposer});
}
