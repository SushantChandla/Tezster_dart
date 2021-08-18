class StorageResponse {
  String prim;
  List<dynamic> args;
  List<dynamic> annots;

  StorageResponse(
    String prim,
    List<dynamic> args,
    List<dynamic> annots,
  ) {
    this.prim = prim;
    this.args = args;
    this.annots = annots;
  }
}

class SaplingDiffResponse {
  String root;
  var commitmentsAndCiphertexts;
  List<String> nullifiers;
}

class ScriptResponse extends ScriptedContracts {
  ScriptResponse(List<dynamic> code, dynamic storage) : super(code, storage);
}

class BigMapGetResponse extends MichelsonV1Expression {}

class MichelsonV1ExpressionExtended {
  String prim;
  List<MichelsonV1Expression> args;
  List<String> annots;
}

class MichelsonV1Expression {
  String prim;
  List<dynamic> args;
  List<dynamic> annots;
}

class ScriptedContracts {
  List<dynamic> code;
  dynamic storage;

  ScriptedContracts(List<dynamic> code, dynamic storage) {
    this.code = code;
    this.storage = storage;
  }
}

class EntrypointsResponse {
  Map<String, dynamic> entrypoints;
  EntrypointsResponse(Map<String, dynamic> entrypoints) {
    this.entrypoints = entrypoints;
  }
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
  List<dynamic> fitness;
  String context;
  int priority;
  String proofOfWorkNonce;
  String signature;

  BlockHeaderResponse(
      String protocol,
      String chainId,
      String hash,
      int level,
      int proto,
      String predecessor,
      String timestamp,
      int validationPass,
      String operationHash,
      List<dynamic> fitness,
      String context,
      int priority,
      String proofOfWorkNonce,
      String signature) {
    this.protocol = protocol;
    this.chainId = chainId;
    this.hash = hash;
    this.level = level;
    this.proto = proto;
    this.predecessor = predecessor;
    this.timestamp = timestamp;
    this.validationPass = validationPass;
    this.operationHash = operationHash;
    this.fitness = fitness;
    this.context = context;
    this.priority = priority;
    this.proofOfWorkNonce = proofOfWorkNonce;
    this.signature = signature;
  }
}
