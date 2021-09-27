class MichelsonV1Expression {
  String? prim;
  List<dynamic>? args;
  List<dynamic>? annots;
  Map jsonCopy = {};
  MichelsonV1Expression({this.prim, this.args, this.annots});
  MichelsonV1Expression.j(var j) {
    if (j is Map) {
      annots = j['annots'];
      args = j['args'];
      prim = j['prim'];
      jsonCopy = j;
    }
  }
}
