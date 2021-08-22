// import 'package:tezster_dart/packages/taquito/context.dart';
// import 'package:tezster_dart/packages/taquito/src/contract/contract.dart';
// import 'package:tezster_dart/packages/taquito/src/contract/interface.dart';
// import 'package:tezster_dart/packages/taquito/src/wallet/wallet.dart';
// import 'package:tezster_dart/packages/tzip-16/tzip16-contract-abstraction.dart';

// const ABSTRACTION_KEY = Symbol("Tzip16ContractAbstractionObjectKey");

// // tzip16(abs, context) {
// //     return {abs,
// //        ()=>{
// //             if (!this[ABSTRACTION_KEY]) {
// //                 this[ABSTRACTION_KEY] = new Tzip16ContractAbstraction(this, context as MetadataContext);
// //             }

// //             return this[ABSTRACTION_KEY]!
// //         },
// //     };
// // }

// getTzip16(v, context) {
//   if (v[ABSTRACTION_KEY] == null) {
//     // v[ABSTRACTION_KEY] = new Tzip16ContractAbstraction(v, context);
//   }

//   return v[ABSTRACTION_KEY];
// }

// tzip16(abs, context) {
//   abs.functions['tzip16'] = getTzip16(abs, context);
// }
