class TokenMetadataNotFound {
  String error;
  TokenMetadataNotFound(String address)
      : error = 'No token metadata was found for the contract: $address';
}

class TokenIdNotFound {
  String error;
  TokenIdNotFound(int tokenId)
      : error = 'Could not find token metadata for the token ID: $tokenId';
}

class InvalidTokenMetadata {
  String error;
  InvalidTokenMetadata()
      : error =
            'Non-compliance with the TZIP-012 standard. The required property `decimals` is missing.';
}
