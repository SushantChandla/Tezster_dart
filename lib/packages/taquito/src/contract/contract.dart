import 'dart:convert';

import 'package:tezster_dart/packages/taquito-michelson-encoder/src/schema/parameter.dart';
import 'package:tezster_dart/packages/taquito-michelson-encoder/src/schema/storage.dart';
import 'package:tezster_dart/packages/taquito-rpc/src/types.dart';
import 'package:tezster_dart/packages/taquito/src/contract/interface.dart';

const DEFAULT_SMART_CONTRACT_METHOD_NAME = 'default';

class ContractMethod<T extends ContractProvider> {
  dynamic provider;
  String address;
  ParameterSchema parameterSchema;
  String name;
  List<dynamic> args;
  bool isMultipleEntrypoint = true;
  bool isAnonymous = false;

  ContractMethod(
    T provider,
    String address,
    ParameterSchema parameterSchema,
    String name,
    List<dynamic> args, {
    bool isMultipleEntrypoint = true,
    bool isAnonymous = false,
  }) {
    this.provider = provider;
    this.address = address;
    this.parameterSchema = parameterSchema;
    this.name = name;
    this.args = args;
    this.isMultipleEntrypoint = isMultipleEntrypoint;
    this.isAnonymous = isAnonymous;
  }

  get schema {
    return this.isAnonymous
        ? this.parameterSchema.extractSchema[this.name]
        : this.parameterSchema.extractSchema;
  }
}

class ContractView {
  ContractAbstraction<ContractProvider> currentContract;
  ContractProvider provider;
  String name;
  String chainId;
  ParameterSchema callbackParametersSchema;
  ParameterSchema parameterSchema;
  List<dynamic> args;

  ContractView(
    ContractAbstraction<ContractProvider> currentContract,
    ContractProvider provider,
    String name,
    String chainId,
    ParameterSchema callbackParametersSchema,
    ParameterSchema parameterSchema,
    List<dynamic> args,
  ) {
    this.currentContract = currentContract;
    this.provider = provider;
    this.name = name;
    this.chainId = chainId;
    this.callbackParametersSchema = callbackParametersSchema;
    this.parameterSchema = parameterSchema;
    this.args = args;
  }
}

void validateArgs(List<dynamic> args, ParameterSchema schema, String name) {
  var sigs = schema.extractSignatures();

  if (!sigs.firstWhere((x) => x.length == args.length)) {
    throw Exception(
        "Invalid parameter error $name received ${args.length} arguments while expecting one of the following signatures ${jsonDecode(sigs)}");
  }
}

bool isView(ParameterSchema schema) {
  var sigs = schema.extractSignatures;
  if ((sigs[0][sigs[0].length - 1] == 'contract')) {
    return true;
  }
  return false;
}

isContractProvider(dynamic variableToCheck) {
  return variableToCheck.contractProviderTypeSymbol != null;
}

class ContractAbstraction<T extends ContractProvider> {
  Map<dynamic, dynamic> methods = {};
  Map<String, dynamic> views = {};

  Schema schema;
  ParameterSchema parameterSchema;

  String address;
  ScriptResponse script;
  T provider;
  StorageProvider storageProvider;
  EntrypointsResponse entrypoints;
  String chainId;

  ContractAbstraction(
      String address,
      ScriptResponse script,
      T provider,
      StorageProvider storageProvider,
      EntrypointsResponse entrypoints,
      String chainId) {
    this.address = address;
    this.script = script;
    this.provider = provider;
    this.storageProvider = storageProvider;
    this.entrypoints = entrypoints;
    this.chainId = chainId;

    this.schema = Schema.fromRPCResponse(script);
    this.parameterSchema = ParameterSchema.fromRPCResponse(script);
    _initializeMethods(
        this, address, provider, entrypoints.entrypoints, chainId);
  }
  _initializeMethods(
    ContractAbstraction<T> currentContract,
    String address,
    T provider,
    Map<String, dynamic> entrypoints,
    String chainId,
  ) {
    var parameterSchema = this.parameterSchema;
    var keys = entrypoints.keys;
    if (parameterSchema.isMultipleEntryPoint) {
      keys.forEach((smartContractMethodName) {
        MichelsonV1Expression data = MichelsonV1Expression();
        data.prim = entrypoints[smartContractMethodName]['prim'];
        data.args = entrypoints[smartContractMethodName]['args'] ?? null;
        var smartContractMethodSchema = new ParameterSchema(data);
        var method = (List<dynamic> args) {
          validateArgs(
              args, smartContractMethodSchema, smartContractMethodName);

          return ContractMethod<T>(provider, address, smartContractMethodSchema,
              smartContractMethodName, args);
        };
        this.methods[smartContractMethodName] = method;

        if (isContractProvider(provider)) {
          if (isView(smartContractMethodSchema)) {
            var view = (List<dynamic> args) {
              var entrypointParamWithoutCallback =
                  (entrypoints[smartContractMethodName] as dynamic).args[0];
              var smartContractMethodSchemaWithoutCallback =
                  new ParameterSchema(entrypointParamWithoutCallback);
              var parametersCallback =
                  (entrypoints[smartContractMethodName] as dynamic)
                      .args[1]
                      .args[0];
              var smartContractMethodCallbackSchema =
                  ParameterSchema(parametersCallback);

              validateArgs(args, smartContractMethodSchemaWithoutCallback,
                  smartContractMethodName);
              return ContractView(
                  currentContract,
                  provider,
                  smartContractMethodName,
                  chainId,
                  smartContractMethodCallbackSchema,
                  smartContractMethodSchemaWithoutCallback,
                  args);
            };
            views[smartContractMethodName] = view;
          }
        }
      });

      var anonymousMethods = parameterSchema.extractSchema.keys
          .where((key) => !entrypoints.containsKey(key));

      anonymousMethods.forEach((smartContractMethodName) {
        var method = (List<dynamic> args) {
          validateArgs([smartContractMethodName, ...args], parameterSchema,
              smartContractMethodName);
          return ContractMethod(
              provider, address, parameterSchema, smartContractMethodName, args,
              isMultipleEntrypoint: false, isAnonymous: true);
        };
        this.methods[smartContractMethodName] = method;
      });
    } else {
      var smartContractMethodSchema = this.parameterSchema;
      var method = (List<dynamic> args) {
        validateArgs(args, parameterSchema, DEFAULT_SMART_CONTRACT_METHOD_NAME);
        return new ContractMethod<T>(
          provider,
          address,
          smartContractMethodSchema,
          DEFAULT_SMART_CONTRACT_METHOD_NAME,
          args,
          isMultipleEntrypoint: false,
        );
      };
      this.methods[DEFAULT_SMART_CONTRACT_METHOD_NAME] = method;
    }
  }

  storage<T>() async {
    return await this.storageProvider.getStorage<T>(this.address, this.schema);
  }
}
