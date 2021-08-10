import 'package:tezster_dart/packages/taquito/src/contract/interface.dart';

class SaplingStateAbstraction {
  BigInt id;
  ContractProvider provider;
  SaplingStateAbstraction(BigInt id, ContractProvider provider) {
    this.id = id;
    this.provider = provider;
  }

  getSaplingDiff(int block) async {
    return this.provider.getSaplingDiffById(this.id.toString(), block);
  }

  getId() {
    return this.id.toString();
  }
}
