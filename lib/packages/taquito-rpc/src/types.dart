class StorageResponse extends MichelsonV1Expression {}

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
  Map<String, MichelsonV1Expression> entrypoints;
  //unreachable?: { path: ('Left' | 'Right')[] };
}

class BlockHeaderResponse {
  String protocol;
  String chainId;
  String hash;
  int level;
  int proto;
  String predecessor;
  String timestamp;
  int validationPass;
  String operationHash;
  List<String> fitness;
  String context;
  int priority;
  String proofOfWorkNonce;
  String signature;
}
