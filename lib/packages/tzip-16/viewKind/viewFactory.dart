import 'package:tezster_dart/packages/tzip-16/metadata-interface.dart';
import 'package:tezster_dart/packages/tzip-16/viewKind/michelsonStorage-view.dart';

class ViewFactory {
  getView(String viewName, rpc, contract, viewImplementation) {
    if (_isMichelsonStorageView(viewImplementation)) {
      var viewValues =
          viewImplementation[ViewImplementationType['MICHELSON_STORAGE']];
      if (viewValues.returnType == null || viewValues.code == null) {
        print(
            '${viewName} is missing mandatory code or returnType property therefore it will be skipped.');
        return;
      }
      return () {
        var view = MichelsonStorageView(
            viewName: viewName,
            contract: contract,
            rpc: rpc,
            returnType: viewValues.returnType,
            code: viewValues.code,
            viewParameterType: viewValues.parameter);
        return view;
      };
    }
  }

  getImplementationType(viewImplementation) {
    return viewImplementation.keys()[0];
  }

  _isMichelsonStorageView(viewImplementation) {
    return this.getImplementationType(viewImplementation) ==
        ViewImplementationType['MICHELSON_STORAGE'];
  }
}
