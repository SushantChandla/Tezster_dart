import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

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
// class Tzip12ContractAbstraction {
//     Tzip16ContractAbstraction _tzip16ContractAbstraction;

//     constructor(
//         private contractAbstraction: ContractAbstraction<ContractProvider | Wallet>,
//         private context: MetadataContext
//     ) {
//         this._tzip16ContractAbstraction = new Tzip16ContractAbstraction(this.contractAbstraction, this.context)
//     }
// }