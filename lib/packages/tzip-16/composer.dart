import 'package:tezster_dart/packages/taquito/context.dart';
import 'package:tezster_dart/packages/taquito/src/contract/contract.dart';
import 'package:tezster_dart/packages/taquito/src/contract/interface.dart';
import 'package:tezster_dart/packages/taquito/src/wallet/wallet.dart';


const ABSTRACTION_KEY = Symbol("Tzip16ContractAbstractionObjectKey");

// tzip16(abs, context) {
//     return {abs, 
//        ()=>{
//             if (!this[ABSTRACTION_KEY]) {
//                 this[ABSTRACTION_KEY] = new Tzip16ContractAbstraction(this, context as MetadataContext);
//             }
            
//             return this[ABSTRACTION_KEY]!
//         },
//     };
// }
