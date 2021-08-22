import 'package:tezster_dart/contracts/tzip16/viewKind/michelsonStorage-view.dart';

const Map ViewImplementationType = {
  'MICHELSON_STORAGE': 'michelsonStorageView',
  'REST_API_QUERY': 'restApiQuery'
};

class ViewFactory {
  getView(String viewName, viewImplementation) {
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
