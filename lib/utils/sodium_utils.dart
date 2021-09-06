import 'dart:typed_data';

abstract class SodiumUtils {
  Uint8List rand(length);

  Uint8List salt();
  Uint8List pwhash(String passphrase, Uint8List salt);

  Uint8List nonce();

  Uint8List close(Uint8List message, Uint8List nonce, Uint8List keyBytes);

  Uint8List open(Uint8List nonceAndCiphertext, Uint8List key);
  Uint8List sign(Uint8List simpleHash, Uint8List key);
  KeyPair publicKey(Uint8List sk);
  KeyPair cryptoSignSeedKeypair(Uint8List seed);
  Uint8List cryptoSignDetached(Uint8List a, Uint8List b);
}

class KeyPair {
  final Uint8List pk, sk;

  const KeyPair({this.pk, this.sk});
}
