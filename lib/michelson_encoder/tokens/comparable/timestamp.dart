import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

class TimestampToken extends ComparableToken {
  static String prim = 'timestamp';

  TimestampToken(dynamic val, int idx, var fac) : super(val, idx, fac);

  @override
  execute(val, {semantics}) {
    if (val['string'] != null) {
      return DateTime.parse(val['string'].toString()).toIso8601String();
    } else if (val['int'] != null) {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(val['int']));
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
  toKey(String val) {
    return val;
  }
}
