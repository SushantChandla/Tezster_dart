import 'dart:typed_data';

var prefix = {
  'TZ1': new Uint8List.fromList([6, 161, 159]),
  'TZ2': new Uint8List.fromList([6, 161, 161]),
  'TZ3': new Uint8List.fromList([6, 161, 164]),
  'KT': new Uint8List.fromList([2, 90, 121]),
  'KT1': new Uint8List.fromList([2, 90, 121]),

  'EDSK': new Uint8List.fromList([43, 246, 78, 7]),
  'EDSK2': new Uint8List.fromList([13, 15, 58, 7]),
  'SPSK': new Uint8List.fromList([17, 162, 224, 201]),
  'P2SK': new Uint8List.fromList([16, 81, 238, 189]),

  'EDPK': new Uint8List.fromList([13, 15, 37, 217]),
  'SPPK': new Uint8List.fromList([3, 254, 226, 86]),
  'P2PK': new Uint8List.fromList([3, 178, 139, 127]),

  'EDESK': new Uint8List.fromList([7, 90, 60, 179, 41]),
  'SPESK': new Uint8List.fromList([0x09, 0xed, 0xf1, 0xae, 0x96]),
  'P2ESK': new Uint8List.fromList([0x09, 0x30, 0x39, 0x73, 0xab]),

  'EDSIG': new Uint8List.fromList([9, 245, 205, 134, 18]),
  'SPSIG': new Uint8List.fromList([13, 115, 101, 19, 63]),
  'P2SIG': new Uint8List.fromList([54, 240, 44, 52]),
  'SIG': new Uint8List.fromList([4, 130, 43]),

  'NET': new Uint8List.fromList([87, 82, 0]),
  'NCE': new Uint8List.fromList([69, 220, 169]),
  'B': new Uint8List.fromList([1, 52]),
  'O': new Uint8List.fromList([5, 116]),
  'LO': new Uint8List.fromList([133, 233]),
  'LLO': new Uint8List.fromList([29, 159, 109]),
  'P': new Uint8List.fromList([2, 170]),
  'CO': new Uint8List.fromList([79, 179]),
  'ID': new Uint8List.fromList([153, 103]),

  'EXPR': new Uint8List.fromList([13, 44, 64, 27]),
  // Legacy prefix
  'TZ': new Uint8List.fromList([2, 90, 121]),
};

Map<String, String> prefixLowercase = {
  'TZ1': 'tz1',
  'TZ2': 'tz2',
  'TZ3': 'tz3',
  'KT': 'KT',
  'KT1': 'KT1',
  'EDSK2': 'edsk2',
  'SPSK': 'spsk',
  'P2SK': 'p2sk',
  'EDPK': 'edpk',
  'SPPK': 'sppk',
  'P2PK': 'p2pk',
  'EDESK': 'edesk',
  'SPESK': 'spesk',
  'P2ESK': 'p2esk',
  'EDSK': 'edsk',
  'EDSIG': 'edsig',
  'SPSIG': 'spsig',
  'P2SIG': 'p2sig',
  'SIG': 'sig',
  'NET': 'Net',
  'NCE': 'nce',
  'B': 'b',
  'O': 'o',
  'LO': 'Lo',
  'LLO': 'LLo',
  'P': 'P',
  'CO': 'Co',
  'ID': 'id',
  'EXPR': 'expr',
  'TZ': 'TZ',
};

var prefixLength = {
  'TZ1': 20,
  'TZ2': 20,
  'TZ3': 20,
  'KT': 20,
  'KT1': 20,
  'EDPK': 32,
  'SPPK': 33,
  'P2PK': 33,
  'EDSIG': 64,
  'SPSIG': 64,
  'P2SIG': 64,
  'SIG': 64,
  'NET': 4,
  'B': 32,
  'P': 32,
  'O': 32
};
