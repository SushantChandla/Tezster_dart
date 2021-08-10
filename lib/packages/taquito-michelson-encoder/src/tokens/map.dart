import 'package:tezster_dart/packages/taquito-michelson-encoder/src/michelson-map.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/tokens/token.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';

class MapToken extends Token {
  static String prim = 'map';

  MapToken(dynamic val, int idx, var fac) : super(val, idx, fac);

  get valueSchema {
    MichelsonV1Expression data = MichelsonV1Expression();
    data.prim = this.val.args[1]['prim'];
    data.args = this.val.args[1]['args'];
    data.annots = this.val.args[1]['annots'];
    return this.createToken(data, 0);
  }

  ComparableToken get keySchema {
    MichelsonV1Expression data = MichelsonV1Expression();
    data.prim = this.val.args[0]['prim'];
    data.args = this.val.args[0]['args'];
    data.annots = this.val.args[0]['annots'];
    return this.createToken(data, 0);
  }

  isValid(dynamic value) {
    if (MichelsonMap.isMichelsonMap(value)) {
      return null;
    }

    return Exception('Value must be a MichelsonMap');
  }

  @override
  execute(val, {semantics}) {
    var map = new MichelsonMap(this.val);

    val.forEach((current) => map.set(this.keySchema.toKey(current.args[0]),
        this.valueSchema.execute(current.args[1], semantics)));
    return map;
  }

  @override
  extractSchema() {
    return {
      'map': {
        'key': this.keySchema.extractSchema(),
        'value': this.valueSchema.extractSchema(),
      },
    };
  }

  @override
  encodeObject(args) {
    MichelsonMap<dynamic, dynamic> val = args;

    var err = this.isValid(val);
    if (err != null) {
      throw err;
    }

    val.keys().toList().sort();
    List<Map> data = [];
    val.keys().toList().forEach((key) {
      data.add({
        'prim': "Elt",
        'args': [
          this.keySchema.encodeObject(key),
          this.valueSchema.encodeObject(val.get(key))
        ]
      });
    });

    return data;
  }
}
