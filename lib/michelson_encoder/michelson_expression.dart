class MichelsonV1Expression {
  String prim;
  List<dynamic> args;
  List<dynamic> annots;
  MichelsonV1Expression({this.prim, this.args, this.annots});
  MichelsonV1Expression.j(var j)
      : annots = j['annots'],
        args = j['args'],
        prim = j['prim'];
}
