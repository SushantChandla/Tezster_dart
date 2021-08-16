import 'package:tezster_dart/packages/taquito-michelson-encoder/src/schema/parameter.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/taquito-rpc.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';
import 'package:tezster_dart/packages/taquito/src/contract/contract.dart';
import 'package:tezster_dart/packages/tzip-16/errors.dart';

abstract class View {
  Future<dynamic> executeView(args);
}

class MichelsonStorageView implements View {
  String viewName;
  ContractAbstraction contract;
  RpcClient rpc;
  MichelsonV1Expression returnType;
  List<MichelsonV1ExpressionExtended> code;
  MichelsonV1ExpressionExtended viewParameterType;

  MichelsonStorageView(
      {this.code,
      this.contract,
      this.returnType,
      this.rpc,
      this.viewName,
      this.viewParameterType});

  findForbiddenInstructionInViewCode(dynamic code) {
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
        if (instruction.args != null && instruction.args.length != 0) {
          this.findForbiddenInstructionInViewCode(instruction.args);
        }
      }
    }
  }

  _illegalUseOfSelfInstruction(List<MichelsonV1ExpressionExtended> code) {
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
      if (instruction.args != null && instruction.args.length != 0) {
        _illegalUseOfSelfInstruction(
            instruction.args as List<MichelsonV1ExpressionExtended>);
      }
    }
  }

  _adaptViewCodeToContext(List<dynamic> code, String contractBalance,
      String blockTimeStamp, String chainId) {
    var instructionsToReplace = {
      "SELF": [
        MichelsonV1ExpressionExtended()
          ..prim = 'PUSH'
          ..args = [
            MichelsonV1Expression()..prim = 'address',
            MichelsonV1Expression()..prim = contract.address
          ],
        MichelsonV1ExpressionExtended()
          ..prim = 'Contract'
          ..args = [MichelsonV1Expression()..prim = 'unit'],
        MichelsonV1ExpressionExtended()
          ..prim = 'IF_NONE'
          ..args = [
            MichelsonV1Expression()..prim = 'unit',
            MichelsonV1Expression()..prim = 'FAILWITH'
          ],
      ],
      "BALANCE": [
        MichelsonV1ExpressionExtended()
          ..prim = 'PUSH'
          ..args = [
            MichelsonV1Expression()..prim = 'mutez',
            MichelsonV1Expression()..prim = contractBalance
          ],
      ],
      "NOW": [
        MichelsonV1ExpressionExtended()
          ..prim = 'PUSH'
          ..args = [
            MichelsonV1Expression()..prim = 'timestamp',
            MichelsonV1Expression()..prim = blockTimeStamp
          ],
      ],
      "CHAIN_ID": [
        MichelsonV1ExpressionExtended()
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

  _validateArgs(args, ParameterSchema schema, String viewNameg) {
    var sigs = schema.extractSignatures();

    if (!sigs.find((x) => x.length == args.length)) {
      throw new InvalidViewParameterError(viewNameg, sigs, args);
    }
  }

  formatArgsAndParameter(argView) {
    var args = argView;
    var viewParameterType = this.viewParameterType;
    if (viewParameterType == null) {
      viewParameterType = MichelsonV1ExpressionExtended()
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
    findForbiddenInstructionInViewCode(this.code);
    _illegalUseOfSelfInstruction(this.code);

    var formatArgsAndPara = formatArgsAndParameter(args);
    var arg = formatArgsAndPara['arg'];
    var viewParameterType = formatArgsAndPara['viewParameterType'];
    var storageType =
        contract.script.code.firstWhere((x) => x.prim == 'storage');
    var storageArgs = storageType.args[0];
    var storageValue = contract.script.storage;

    // currentContext
    var chainId = await rpc.getChainId();
    var contractBalance = (await rpc.getBalance(contract.address)).toString();
    var block = await rpc.getBlock();
    var blockTimestamp = block.header.timestamp.toString();
    var protocolHash = block.protocol;

    var code = _adaptViewCodeToContext(
        this.code, contractBalance, blockTimestamp, chainId);

    if (viewParameterType == null) {
      code.unshift(MichelsonV1ExpressionExtended()..prim = 'CDR');
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

    var result = await rpc.runCode(viewScript);
    var viewResultSchema = ParameterSchema(returnType);
    return viewResultSchema.execute(result.storage.args[0]);
  }
}
