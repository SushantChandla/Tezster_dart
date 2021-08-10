import 'dart:typed_data';

var prefix = {
  [prefixLowercase['TZ1']]: new Uint8List.fromList([6, 161, 159]),
  [prefixLowercase['TZ2']]: new Uint8List.fromList([6, 161, 161]),
  [prefixLowercase['TZ3']]: new Uint8List.fromList([6, 161, 164]),
  [prefixLowercase['KT']]: new Uint8List.fromList([2, 90, 121]),
  [prefixLowercase['KT1']]: new Uint8List.fromList([2, 90, 121]),

  [prefixLowercase['EDSK']]: new Uint8List.fromList([43, 246, 78, 7]),
  [prefixLowercase['EDSK2']]: new Uint8List.fromList([13, 15, 58, 7]),
  [prefixLowercase['SPSK']]: new Uint8List.fromList([17, 162, 224, 201]),
  [prefixLowercase['P2SK']]: new Uint8List.fromList([16, 81, 238, 189]),

  [prefixLowercase['EDPK']]: new Uint8List.fromList([13, 15, 37, 217]),
  [prefixLowercase['SPPK']]: new Uint8List.fromList([3, 254, 226, 86]),
  [prefixLowercase['P2PK']]: new Uint8List.fromList([3, 178, 139, 127]),

  [prefixLowercase['EDESK']]: new Uint8List.fromList([7, 90, 60, 179, 41]),
  [prefixLowercase['SPESK']]:
      new Uint8List.fromList([0x09, 0xed, 0xf1, 0xae, 0x96]),
  [prefixLowercase['P2ESK']]:
      new Uint8List.fromList([0x09, 0x30, 0x39, 0x73, 0xab]),

  [prefixLowercase['EDSIG']]: new Uint8List.fromList([9, 245, 205, 134, 18]),
  [prefixLowercase['SPSIG']]: new Uint8List.fromList([13, 115, 101, 19, 63]),
  [prefixLowercase['P2SIG']]: new Uint8List.fromList([54, 240, 44, 52]),
  [prefixLowercase['SIG']]: new Uint8List.fromList([4, 130, 43]),

  [prefixLowercase['NET']]: new Uint8List.fromList([87, 82, 0]),
  [prefixLowercase['NCE']]: new Uint8List.fromList([69, 220, 169]),
  [prefixLowercase['B']]: new Uint8List.fromList([1, 52]),
  [prefixLowercase['O']]: new Uint8List.fromList([5, 116]),
  [prefixLowercase['LO']]: new Uint8List.fromList([133, 233]),
  [prefixLowercase['LLO']]: new Uint8List.fromList([29, 159, 109]),
  [prefixLowercase['P']]: new Uint8List.fromList([2, 170]),
  [prefixLowercase['CO']]: new Uint8List.fromList([79, 179]),
  [prefixLowercase['ID']]: new Uint8List.fromList([153, 103]),

  [prefixLowercase['EXPR']]: new Uint8List.fromList([13, 44, 64, 27]),
  // Legacy prefix
  [prefixLowercase['TZ']]: new Uint8List.fromList([2, 90, 121]),
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
  [prefixLowercase['TZ1']]: 20,
  [prefixLowercase['TZ2']]: 20,
  [prefixLowercase['TZ3']]: 20,
  [prefixLowercase['KT']]: 20,
  [prefixLowercase['KT1']]: 20,
  [prefixLowercase['EDPK']]: 32,
  [prefixLowercase['SPPK']]: 33,
  [prefixLowercase['P2PK']]: 33,
  [prefixLowercase['EDSIG']]: 64,
  [prefixLowercase['SPSIG']]: 64,
  [prefixLowercase['P2SIG']]: 64,
  [prefixLowercase['SIG']]: 64,
  [prefixLowercase['NET']]: 4,
  [prefixLowercase['B']]: 32,
  [prefixLowercase['P']]: 32,
  [prefixLowercase['O']]: 32
};
