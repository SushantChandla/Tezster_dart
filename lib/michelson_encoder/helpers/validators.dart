import 'dart:typed_data';

import 'package:bs58check/bs58check.dart' as bs58check;
import 'package:tezster_dart/michelson_encoder/helpers/constants.dart';

enum ValidationResult {
  NO_PREFIX_MATCHED,
  INVALID_CHECKSUM,
  INVALID_LENGTH,
  VALID,
}

List<String?> implicitPrefix = [
  prefixLowercase['TZ1'],
  prefixLowercase['TZ2'],
  prefixLowercase['TZ3']
];
List<String?> contractPrefix = [prefixLowercase['KT1']];

isValidPrefix(value) {
  if (value is String) {
    return prefix.containsKey(value);
  }
  return false;
}

validatePrefixedValue(value, List prefixes) {
  var match = RegExp("^(${prefixes.join('|')})").allMatches(value);

  if (match == null || match.isEmpty) {
    return ValidationResult.NO_PREFIX_MATCHED;
  }

  var prefixKey = match.first.group(0)!.toUpperCase();

  if (!isValidPrefix(prefixKey)) {
    return ValidationResult.NO_PREFIX_MATCHED;
  }

  // Remove annotation from contract address before doing the validation
  var contractAddress = RegExp(r"/^(KT1\w{33})(\%(.*))?/").allMatches(value);
  if (contractAddress != null && contractAddress.isNotEmpty) {
    value = contractAddress.first.group(0);
  }

  // decodeUnsafe return undefined if decoding fail
  Uint8List decoded = bs58check.decode(value);
  if (decoded == null) {
    return ValidationResult.INVALID_CHECKSUM;
  }

  decoded = decoded.sublist(prefix[prefixKey]!.length);
  if (decoded.length != prefixLength[prefixKey]) {
    return ValidationResult.INVALID_LENGTH;
  }

  return ValidationResult.VALID;
}

ValidationResult validateAddress(value) {
  return validatePrefixedValue(value, [...implicitPrefix, ...contractPrefix]);
}

validateKeyHash(value) {
  return validatePrefixedValue(value, implicitPrefix);
}
