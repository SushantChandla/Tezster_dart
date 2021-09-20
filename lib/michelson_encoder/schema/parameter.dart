import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/tokens/createToken.dart';
import 'package:tezster_dart/michelson_encoder/tokens/option.dart';
import 'package:tezster_dart/michelson_encoder/tokens/or.dart';
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

class ParameterSchema {
  late Token _root;

  ParameterSchema(MichelsonV1Expression? val) {
    _root = createToken(val, 0);
  }

  get isMultipleEntryPoint {
    return (_root.runtimeType == OrToken ||
        (_root.runtimeType == OptionToken && _root.createToken() == OrToken));
  }

  get hasAnnotation {
    if (this.isMultipleEntryPoint) {
      return this.extractSchema!.keys.first != '0';
    } else {
      return true;
    }
  }

  Map? get extractSchema {
    return _root.extractSchema();
  }

  encode(args) {
    try {
      return _root.encode(args.reverse());
    } catch (ex) {
      throw new Exception(
        'Unable to encode storage object. $ex',
      );
    }
  }

  get extractSignatures {
    return _root.extractSignature();
  }

  execute(val, {semantics}) {
    return _root.execute(val, semantics: semantics);
  }
}
