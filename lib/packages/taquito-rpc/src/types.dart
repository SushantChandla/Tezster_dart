class ScriptResponse extends ScriptedContracts {}

class BigMapGetResponse extends MichelsonV1Expression {}

class MichelsonV1ExpressionExtended {
  String prim;
  List<MichelsonV1Expression> args;
  List<String> annots;
}

class MichelsonV1Expression extends MichelsonV1ExpressionExtended {}

class ScriptedContracts {
  List<MichelsonV1Expression> code;
  MichelsonV1Expression storage;
}

class EntrypointsResponse {
  Map<String, String> entrypoints;
  //unreachable?: { path: ('Left' | 'Right')[] };
}
