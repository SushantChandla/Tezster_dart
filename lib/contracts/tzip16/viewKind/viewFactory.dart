import 'package:tezster_dart/contracts/tzip16/viewKind/michelsonStorage-view.dart';
import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';

const Map ViewImplementationType = {
  'MICHELSON_STORAGE': 'michelsonStorageView',
  'REST_API_QUERY': 'restApiQuery'
};

class ViewFactory {
  getView(String? viewName, viewImplementation) {
    if (_isMichelsonStorageView(viewImplementation)) {
      var viewValues =
          viewImplementation[ViewImplementationType['MICHELSON_STORAGE']];
      if (viewValues['returnType'] == null || viewValues['code'] == null) {
        print(
            '${viewName} is missing mandatory code or returnType property therefore it will be skipped.');
        return;
      }
      return () {
        var view = MichelsonStorageView(
            viewName: viewName,
            returnType: MichelsonV1Expression.j(viewValues['returnType']),
            code: (viewValues['code'] as List)
                .map((e) => MichelsonV1Expression.j(e))
                .toList(),
            viewParameterType: MichelsonV1Expression.j(viewValues['parameter']));
        return view;
      };
    }
  }

  getImplementationType(viewImplementation) {
    return viewImplementation.keys.first;
  }

  _isMichelsonStorageView(viewImplementation) {
    return this.getImplementationType(viewImplementation) ==
        ViewImplementationType['MICHELSON_STORAGE'];
  }
}
