import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/tokens/comparable/int.dart';
import 'package:tezster_dart/michelson_encoder/tokens/contract.dart';
import 'package:tezster_dart/michelson_encoder/tokens/token.dart';

const ticketerType = {"prim": "contract"};
const amountType = {"prim": "int"};

class TicketToken extends Token {
  static String prim = 'ticket';
  TicketToken(MichelsonV1Expression val, int idx, fac) : super(val, idx, fac);

  @override
  encodeObject(args) {
    throw Exception('Encode Ticket Error');
  }

  @override
  execute(val, {semantics}) {
    if (semantics && semantics[TicketToken.prim]) {
      return semantics[TicketToken.prim](val, this.val);
    }
    var ticketer = this.createToken(ticketerType, this.idx);
    var value = this.createToken(this.val!.args![0], this.idx);
    var amount = this.createToken(amountType, this.idx);

    if (val.args.length == 1 && val.args.args != null) {
      return {
        'ticketer': ticketer.Execute(val.args[0], semantics),
        'value': value.Execute(val.args[1].args[0], semantics),
        'amount': amount.Execute(val.args[1].args[1], semantics)
      };
    }
    return {
      'ticketer': ticketer.Execute(val.args[0], semantics),
      'value': value.Execute(val.args[1], semantics),
      'amount': amount.Execute(val.args[2], semantics)
    };
  }

  @override
  extractSchema() {
    var valueSchema = this.createToken(this.val!.args![0], this.idx);
    return {
      'ticketer': ContractToken.prim,
      'value': valueSchema.ExtractSchema(),
      'amount': IntToken.prim
    };
  }

  @override
  encode(List args) {
    // TODO: implement encode
    throw UnimplementedError();
  }
}
