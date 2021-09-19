---
sidebar_position: 2
---

# Transfer Balance

The most basic operation on the chain is the transfer of value between two accounts. In this example we have the account we activated above: tz1QSHaKpTFhgHLbqinyYRjxD5sLcbfbzhxy and some random testnet address to test with: tz1RVcUP9nUurgEJMDou8eW3bVDs6qmP5Lnc. Note all amounts are in µtz, as in micro-tez, hence `0.5tz is represented as 500000`. The fee of 1500 was chosen arbitrarily, but some operations have minimum fee requirements.

```dart
// Choosing the rpc-sever to use
var server = 'rpc_server';

// Creating keyStore object with sender's details.
var keyStore = KeyStoreModel(
      publicKey: 'edpkvQtuhdZQmjdjVfaY9Kf4hHfrRJYugaJErkCGvV3ER1S7XWsrrj',
      secretKey:
          'edskRgu8wHxjwayvnmpLDDijzD3VZDoAH7ZLqJWuG4zg7LbxmSWZWhtkSyM5Uby41rGfsBGk4iPKWHSDniFyCRv3j7YFCknyHH',
      publicKeyHash: 'tz1QSHaKpTFhgHLbqinyYRjxD5sLcbfbzhxy',
    );

// Creating singer from the sender's secret key to sign the TransactionOperation.
var signer = await TezsterDart.createSigner(
    TezsterDart.writeKeyWithHint(keyStore.secretKey, 'edsk'));

//TransactionOperation
var result = await TezsterDart.sendTransactionOperation(
      server,
      signer,
      keyStore,
      'tz1RVcUP9nUurgEJMDou8eW3bVDs6qmP5Lnc',//Destination Address
      500000,//Amount To send
      1500,//Fee
    );
    
//Operation Result
print("Applied operation ===> $result['appliedOp']");
print("Operation groupID ===> $result['operationGroupID']");
```