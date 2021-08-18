import 'package:tezster_dart/packages/taquito/context.dart';
import 'package:tezster_dart/packages/taquito/src/contract/interface.dart';
import 'package:tezster_dart/packages/taquito/src/operations/operation-emitter.dart';

class RPCEstimateProvider extends OperationEmitter
    implements EstimationProvider {
  RPCEstimateProvider(Context context) : super(context);

  static const int ALLOCATION_STORAGE = 257;
  static const int ORIGINATION_STORAGE = 257;
  static const int OP_SIZE_REVEAL = 128;
}
