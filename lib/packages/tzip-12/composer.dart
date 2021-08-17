import 'package:tezster_dart/packages/tzip-12/contract-abstraction.dart';

const ABSTRACTION_KEY = Symbol("Tzip12ContractAbstractionObjectKey");

getTzip12(v, context) {
  return Tzip12ContractAbstraction(v, context);

}

tzip12(abs, context) {
  abs.functions['tzip16'] = getTzip12(abs, context);
}
