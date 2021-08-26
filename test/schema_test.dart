import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:tezster_dart/contracts/big_map.dart';
import 'package:tezster_dart/contracts/sapling_state_abstraction.dart';
import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/schema/storage.dart';

void main() {
  dynamic _smartContractAbstractionSemantic() {
    return {
      'big_map': (val, code) {
        if (val is MichelsonV1Expression) return {};
        if (val == null || !val.containsKey('int') || val['int'] == null) {
          return {};
        } else {
          return BigMapAbstraction(
              BigInt.from(double.parse(val['int'])),
              code is MichelsonV1Expression
                  ? Schema(code)
                  : Schema(MichelsonV1Expression.j(code)));
        }
      },
      'sapling_state': (val) {
        if (val == null || !val.containsKey('int') || val['int'] == null) {
          return {};
        } else {
          return SaplingStateAbstraction(val['int']);
        }
      }
    };
  }

  var d = Directory('test/Carthagenet_1/');
  for (FileSystemEntity i in d.listSync()) {
    if (i is File) {
      test('Carthagenet_1 ${i.path} test', () async {
        var data = await i.readAsString();
        var json = jsonDecode(data);
        var schema = Schema.fromFromScript(json);
        var storage = json['storage'];
        MichelsonV1Expression storageResponse;
        if (storage is List) {
          storageResponse = MichelsonV1Expression.j(storage[0]);
        } else {
          storageResponse = MichelsonV1Expression.j(storage);
        }
        var res = schema.execute(
            storageResponse, _smartContractAbstractionSemantic());
      });
    }
  }
}
