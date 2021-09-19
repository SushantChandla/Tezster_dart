---
sidebar_position: 1
---

# Deploy a contract
 With this release we are excited to include the feature of trestles chain interactions, including contract deployment a user can directly write smart contracts in Michelson language and deploy it on Tezos chain using the `sendContractOriginationOperation` method in return you'll get an origination id of the deployed contract that can be use to track the contract on chain. We have set an example for you below.

```dart
var server = '';

var contract = """parameter string;
    storage string;
    code { DUP;
        DIP { CDR ; NIL string ; SWAP ; CONS } ;
        CAR ; CONS ;
        CONCAT;
        NIL operation; PAIR}""";

var storage = '"Sample"';

var keyStore = KeyStoreModel(
      publicKey: 'edpkvQtuhdZQmjdjVfaY9Kf4hHfrRJYugaJErkCGvV3ER1S7XWsrrj',
      secretKey:
          'edskRgu8wHxjwayvnmpLDDijzD3VZDoAH7ZLqJWuG4zg7LbxmSWZWhtkSyM5Uby41rGfsBGk4iPKWHSDniFyCRv3j7YFCknyHH',
      publicKeyHash: 'tz1QSHaKpTFhgHLbqinyYRjxD5sLcbfbzhxy',
    );

var signer = await TezsterDart.createSigner(
        TezsterDart.writeKeyWithHint(keyStore.secretKey, 'edsk'));

var result = await TezsterDart.sendContractOriginationOperation(
      server,
      signer,
      keyStore,
      0,
      null,
      100000,
      1000,
      100000,
      contract,
      storage,
      codeFormat: TezosParameterFormat.Michelson,
    );

print("Operation groupID ==> $result['operationGroupID']");

```