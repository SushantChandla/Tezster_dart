
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

class TimestampToken extends ComparableToken {
  static String prim = 'timestamp';

  TimestampToken(dynamic val, int idx, var fac) : super(val, idx, fac);

  @override
  execute(val, {semantics}) {
    if (val['string'] != null) {
      return DateTime.parse(val['string'].toString()).toIso8601String();
    } else if (val['int'] != null) {
      int x=int.parse(val['int']);
      return DateTime.fromMillisecondsSinceEpoch(x);
    }
  }

  @override
  extractSchema() {
    return TimestampToken.prim;
  }

  @override
  encodeObject(val) {
    return {'string': val};
  }

  @override
  toKey(dynamic val) {
    return val.values.toList().first;
  }

  @override
  encode(List args) {
    var val = args.removeLast();
    return { 'string': val };
  }

  @override
  Map toBigMapKey(val) {
    return {
      'key': { 'string': val },
      'type': { 'prim': TimestampToken.prim },
    };
  }
}
