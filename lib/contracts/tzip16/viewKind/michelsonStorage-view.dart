import 'package:tezster_dart/contracts/contract.dart';
import 'package:tezster_dart/contracts/tzip16/errors.dart';
import 'package:tezster_dart/helper/http_helper.dart';
import 'package:tezster_dart/michelson_encoder/michelson_expression.dart';
import 'package:tezster_dart/michelson_encoder/schema/parameter.dart';

abstract class View {
  Future<dynamic> executeView(args);
}

class MichelsonStorageView implements View {
  String? viewName;
  MichelsonV1Expression? returnType;
  List<MichelsonV1Expression?>? code;
  MichelsonV1Expression? viewParameterType;
  Contract? contract;
  MichelsonStorageView(
      {this.code,
      this.contract,
      this.returnType,
      this.viewName,
      this.viewParameterType});

  findForbiddenInstructionInViewCode(List<dynamic> code) {
    if (!(code is List<MichelsonV1Expression>)) {
      code = code.map((e) => MichelsonV1Expression.j(e)).toList();
    }
    const illegalInstructions = [
      'AMOUNT',
      'CREATEcontract',
      'SENDER',
      'SET_DELEGATE',
      'SOURCE',
      'TRANSFER_TOKENS'
    ];

    for (var forbiddenInstruction in illegalInstructions) {
      for (var instruction in code) {
        if (instruction.prim == forbiddenInstruction) {
          throw new ForbiddenInstructionInViewCode(forbiddenInstruction);
        }
        if (instruction.args != null && instruction.args!.length != 0) {
          this.findForbiddenInstructionInViewCode(instruction.args!);
        }
      }
    }
  }

  _illegalUseOfSelfInstruction(List<dynamic> code) {
    if (!(code is List<MichelsonV1Expression>)) {
      code = code.map((e) => MichelsonV1Expression.j(e)).toList();
    }
    for (var instruction in code) {
      if (instruction.prim == 'SELF') {
        var index = code.indexOf(instruction);
        var nextInstruction =
            code[index + 1] != null ? code[index + 1].prim : null;
        if (nextInstruction != 'ADDRESS') {
          throw new ForbiddenInstructionInViewCode(
              'the instruction SELF should only be used before ADDRESS');
        }
      }
      if (instruction.args != null && instruction.args!.length != 0) {
        _illegalUseOfSelfInstruction(instruction.args!);
      }
    }
  }

  _adaptViewCodeToContext(List<dynamic> code, String contractBalance,
      String blockTimeStamp, String chainId) {
    var instructionsToReplace = {
      "SELF": [
        MichelsonV1Expression()
          ..prim = 'PUSH'
          ..args = [
            MichelsonV1Expression()..prim = 'address',
            MichelsonV1Expression()..prim = contract!.address
          ],
        MichelsonV1Expression()
          ..prim = 'Contract'
          ..args = [MichelsonV1Expression()..prim = 'unit'],
        MichelsonV1Expression()
          ..prim = 'IF_NONE'
          ..args = [
            MichelsonV1Expression()..prim = 'unit',
            MichelsonV1Expression()..prim = 'FAILWITH'
          ],
      ],
      "BALANCE": [
        MichelsonV1Expression()
          ..prim = 'PUSH'
          ..args = [
            MichelsonV1Expression()..prim = 'mutez',
            MichelsonV1Expression()..prim = contractBalance
          ],
      ],
      "NOW": [
        MichelsonV1Expression()
          ..prim = 'PUSH'
          ..args = [
            MichelsonV1Expression()..prim = 'timestamp',
            MichelsonV1Expression()..prim = blockTimeStamp
          ],
      ],
      "CHAIN_ID": [
        MichelsonV1Expression()
          ..prim = 'PUSH'
          ..args = [
            MichelsonV1Expression()..prim = 'string',
            MichelsonV1Expression()..prim = chainId
          ],
      ]
    };

    code.forEach((x) {
      for (var instruction in instructionsToReplace.keys) {
        if (x.prim == instruction) {
          code[code.indexOf(x)] = instructionsToReplace[instruction];
        }
        if (x.args && x.args.length != 0) {
          _adaptViewCodeToContext(
              x.args, contractBalance, blockTimeStamp, chainId);
        }
      }
    });
    return code;
  }

  _validateArgs(args, ParameterSchema schema, String? viewNameg) {
    List sigs = schema.extractSignatures;

    if (sigs.firstWhere((x) => x.length == args.length, orElse: () {
          return null;
        }) ==
        null) {
      throw new InvalidViewParameterError(viewNameg, sigs, args);
    }
  }

  formatArgsAndParameter(argView) {
    var args = argView;
    var viewParameterType = this.viewParameterType;
    if (viewParameterType == null) {
      viewParameterType = MichelsonV1Expression()
        ..prim = 'Unit'
        ..annots = []
        ..args = [];
    }

    if (viewParameterType.prim == 'unit') {
      if (args.length == 0) {
        args = ['Unit'];
      }
      if (args.length != 0 && args[0] != 'Unit') {
        throw new NoParameterExpectedError(viewName, argView);
      }
    }
    var parameterViewSchema = new ParameterSchema(MichelsonV1Expression()
      ..prim = viewParameterType.prim
      ..annots = viewParameterType.annots
      ..args = viewParameterType.args);
    _validateArgs(args, parameterViewSchema, viewName);
    var arg = parameterViewSchema.encode(args);
    return {"arg": arg, "viewParameterType": viewParameterType};
  }

  @override
  Future executeView(args) async {
    // validate view code against tzip-16 specifications
    findForbiddenInstructionInViewCode(this.code as List<dynamic>);
    _illegalUseOfSelfInstruction(this.code!);

    var formatArgsAndPara = formatArgsAndParameter(args);
    var arg = formatArgsAndPara['arg'];
    var viewParameterType = formatArgsAndPara['viewParameterType'];
    var storageType =
        contract!.script!['code'].firstWhere((x) => x.prim == 'storage');
    var storageArgs = storageType.args[0];
    var storageValue = contract!.script!['storage'];

    // currentContext
    var chainId = await getChainId();
    var contractBalance = (await getBalance(contract!.address)).toString();
    var block = await getBlock();
    var blockTimestamp = block.header.timestamp.toString();
    var protocolHash = block.protocol;

    var code = _adaptViewCodeToContext(
        this.code!, contractBalance, blockTimestamp, chainId);

    if (viewParameterType == null) {
      code.unshift(MichelsonV1Expression()..prim = 'CDR');
    }

    var viewScript = {
      "script": [
        {
          "prim": 'parameter',
          "args": [
            {
              "prim": 'pair',
              "args": ["viewParameterType", "storageArgs"]
            }
          ]
        },
        {
          'prim': 'storage',
          args: [
            {
              'prim': 'option',
              'args': [returnType]
            }
          ]
        },
        {
          'prim': 'code',
          'args': [
            [
              {'prim': 'CAR'},
              code,
              {'prim': 'SOME'},
              {
                'prim': 'NIL',
                'args': [
                  {'prim': 'operation'}
                ]
              },
              {'prim': 'PAIR'}
            ]
          ]
        }
      ],
      'storage': {'prim': 'None'},
      'input': {
        'prim': 'Pair',
        args: [arg, storageValue]
      },
      'amount': '0',
      'chain_id': chainId,
      'balance': '0'
    };

    var result = await runCode(viewScript);
    var viewResultSchema = ParameterSchema(returnType);
    return viewResultSchema.execute(result.storage.args[0]);
  }

  getChainId({String chain = 'main'}) {
    return HttpHelper.performGetRequest(
        contract!.rpcServer, '/chains/$chain/chain_id');
  }

  Future<BigInt> getBalance(address,
      {block = 'head', String chain = 'main'}) async {
    var balance = await HttpHelper.performGetRequest(contract!.rpcServer,
        '/chains/$chain/blocks/$block/context/contracts/$address/balance',
        responseJson: false);
    return BigInt.parse(balance);
  }

  getBlock({block = 'head', String chain = 'main'}) async {
    var response = await HttpHelper.performGetRequest(
        contract!.rpcServer, '/chains/$chain/blocks/$block');
    return response;
  }

  runCode(code, {block = 'head', chain = 'main'}) {
    var response = HttpHelper.performPostRequest(contract!.rpcServer,
        '/chains/$chain/blocks/$block/helpers/scripts/run_code', code);
    return response;
  }

  @override
  String toString() {
    return {
      'viewName': '$viewName',
      'returnType': returnType?.jsonCopy,
      'code': code?.map((e) => e?.jsonCopy).toList(),
      'viewParameterType': viewParameterType?.jsonCopy
    }.toString();
  }
}
