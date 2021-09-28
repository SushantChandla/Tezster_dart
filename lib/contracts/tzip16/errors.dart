class BigMapMetadataNotFound {
  String cause;
  BigMapMetadataNotFound()
      : cause =
            'Non-compliance with the TZIP-016 standard. No big map named metadata was found in the contract storage.';
  String toString() {
    return cause;
  }
}

class MetadataNotFound {
  String cause;
  MetadataNotFound(String info)
      : cause = 'No metadata was found in the contract storage. $info';
  String toString() {
    return cause;
  }
}

class UriNotFound {
  String cause;
  UriNotFound()
      : cause =
            'Non-compliance with the TZIP-016 standard. No URI found in the contract storage.';
  String toString() {
    return cause;
  }
}

class InvalidUri {
  String cause;
  InvalidUri(String uri)
      : cause =
            'Non-compliance with the TZIP-016 standard. The URI is invalid: $uri.';
  String toString() {
    return cause;
  }
}

class InvalidMetadata {
  String cause;
  InvalidMetadata(String invalidMetadata)
      : cause =
            'The metadata found at the pointed ressource are not compliant with tzip16 standard: $invalidMetadata.';
  @override
  String toString() {
    return cause;
  }
}

class ProtocolNotSupported {
  String cause;
  ProtocolNotSupported(String? protocol)
      : cause = 'The protocol found in the URI is not supported: $protocol.';
}

class InvalidMetadataType {
  String cause;
  InvalidMetadataType()
      : cause =
            'The contract does not comply with the tzip16 standard. The type of metadata should be bytes.';
  String toString() {
    return cause;
  }
}

class UnconfiguredMetadataProviderError {
  String cause;
  UnconfiguredMetadataProviderError()
      : cause =
            'No metadata provider has been configured. The default one can be configured by calling addExtension(new Tzip16Module()) on your TezosToolkit instance.';
  String toString() {
    return cause;
  }
}

class ForbiddenInstructionInViewCode {
  String cause;
  ForbiddenInstructionInViewCode(String instruction)
      : cause =
            'Error found in the code of the view. It contains a forbidden instruction: $instruction.';
  String toString() {
    return cause;
  }
}

class NoParameterExpectedError {
  String cause;
  NoParameterExpectedError(String? viewName, List args)
      : cause =
            "$viewName Received ${args.length} arguments while expecting no parameter or 'Unit'";
  String toString() {
    return cause;
  }
}

class InvalidViewParameterError {
  String cause;
  InvalidViewParameterError(String? viewName, List args, List sigs)
      : cause =
            "$viewName Received ${args.length} arguments while expecting one of the following signatures $sigs})";
  String toString() {
    return cause;
  }
}
