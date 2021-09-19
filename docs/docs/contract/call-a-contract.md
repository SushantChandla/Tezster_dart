---
sidebar_position: 2
---

# Call a contract

We have also included the feature to call or invoke a deployed contract just use the inbuilt `sendContractInvocationOperation` method in return you'll get an origination id of the invoked contract that can be used to track the contracts on chain. We have set an example for you below.

```dart
var server = '';//rpc

var keyStore = KeyStoreModel(
      publicKey: 'edpkvQtuhdZQmjdjVfaY9Kf4hHfrRJYugaJErkCGvV3ER1S7XWsrrj',
      secretKey:
          'edskRgu8wHxjwayvnmpLDDijzD3VZDoAH7ZLqJWuG4zg7LbxmSWZWhtkSyM5Uby41rGfsBGk4iPKWHSDniFyCRv3j7YFCknyHH',
      publicKeyHash: 'tz1QSHaKpTFhgHLbqinyYRjxD5sLcbfbzhxy',
    );

var signer = await TezsterDart.createSigner(
        TezsterDart.writeKeyWithHint(keyStore.secretKey, 'edsk'));

var contractAddress = 'KT1KA7DqFjShLC4CPtChPX8QtRYECUb99xMY';

var resultInvoke = await TezsterDart.sendContractInvocationOperation(
        server,
        signer,
        keyStore,
        contractAddress,//contract address
        10000,
        100000,
        1000,
        100000,
        '',//paramters
        'entrypoint',  //entrypoint name
        codeFormat: TezosParameterFormat.Michelson);//paramter type

print("Operation groupID ===> $result['operationGroupID']");
```