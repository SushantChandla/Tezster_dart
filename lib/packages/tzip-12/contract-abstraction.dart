import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';
import 'package:tezster_dart/packages/taquito/context.dart';
import 'package:tezster_dart/packages/taquito/src/contract/contract.dart';
import 'package:tezster_dart/packages/tzip-16/tzip16-contract-abstraction.dart';

var tokenMetadataBigMapType = MichelsonV1Expression()
  ..prim = 'big_map'
  ..args = [
    MichelsonV1Expression()..prim = 'nat',
    MichelsonV1Expression()
      ..prim = 'pair'
      ..args = [
        MichelsonV1Expression()
          ..prim = 'nat'
          ..annots = ['%token_id'],
        MichelsonV1Expression()
          ..prim = 'map'
          ..args = [
            MichelsonV1Expression()..prim = 'string',
            MichelsonV1Expression()..prim = 'bytes'
          ]
          ..annots = ['%token_info'],
      ]
      ..annots = ['%token_metadata']
  ];

class Tzip12ContractAbstraction {
  Tzip16ContractAbstraction _tzip16ContractAbstraction;
  ContractAbstraction contractAbstraction;
  Context context;
  Tzip12ContractAbstraction(this.context, this.contractAbstraction)
      : _tzip16ContractAbstraction =
            Tzip16ContractAbstraction(contractAbstraction, context);

  getContractMetadata() async {
    try {
      var contractMetadata = await _tzip16ContractAbstraction.getMetadata();
      return contractMetadata.metadata;
    } catch (err) {
      // The contract is not compliant with Tzip-016. There is no contract metadata.
    }
  }

  isTzip12Compliant() async {
    var isCompliant = false;
    var metadata = await this.getContractMetadata();
    if (metadata) {
      var tzip12Interface =
          metadata.interfaces.where((x) => {x.substring(0, 8) == "TZIP-012"});
      isCompliant =
          (tzip12Interface && tzip12Interface.length != 0) ? true : false;
    }
    return isCompliant;
  }
}
