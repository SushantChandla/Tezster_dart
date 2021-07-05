import 'package:tezster_dart/packages/taquito/context.dart';
import 'package:tezster_dart/packages/taquito/src/contract/contract.dart';

class EstimationProvider {}

class StorageProvider {}

class ContractProvider extends StorageProvider {
  at<T extends ContractAbstraction<ContractProvider>>(
      String address,
      contractAbstractionComposer(
          ContractAbstraction<ContractProvider> abs, Context context)) {}
}
