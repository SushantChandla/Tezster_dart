import 'dart:typed_data';

import 'package:tezster_dart/packages/taquito-utils/src/constants.dart';
import 'package:bs58check/bs58check.dart' as bs58check;

enum ValidationResult {
  NO_PREFIX_MATCHED,
  INVALID_CHECKSUM,
  INVALID_LENGTH,
  VALID,
}

List<String> implicitPrefix = [prefixLowercase['TZ1'], prefixLowercase['TZ2'], prefixLowercase['TZ3']];
List<String> contractPrefix = [prefixLowercase['KT1']];

isValidPrefix(value) {
  if (value.runtimeType != String) {
    return false;
  }

  return prefix.containsKey([value.toString().toUpperCase()]);
}

validatePrefixedValue(value, List prefixes) {
  RegExp match = new RegExp("^(\" + ${prefixes.join('|')} + \")\n");
  if (match.stringMatch(value) == null ||
      match.stringMatch(value).length == 0) {
    return ValidationResult.NO_PREFIX_MATCHED;
  }

  var prefixKey = match.stringMatch(value);

  if (!isValidPrefix(prefixKey)) {
    return ValidationResult.NO_PREFIX_MATCHED;
  }

  // Remove annotation from contract address before doing the validation
  RegExp contractAddress = new RegExp("^(KT1\\w{33})(\\%(.*))?");
  if (contractAddress != null) {
    value = contractAddress.stringMatch(value);
  }

  // decodeUnsafe return undefined if decoding fail
  Uint8List decoded = bs58check.decodeRaw(value);
  if (decoded != null) {
    return ValidationResult.INVALID_CHECKSUM;
  }

  decoded = decoded.sublist(prefix[prefixKey].length);
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
