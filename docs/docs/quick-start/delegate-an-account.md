---
sidebar_position: 4
---

# Delegate an Account
One of the most exciting features of Tezos is delegation. This is a means for non-"baker" (non-validator) accounts to participate in the on-chain governance process and receive staking rewards. It is possible to delegate both implicit and originated accounts. For implicit addresses, those starting with tz1, tz2 and tz3, simply call sendDelegationOperation. Originated accounts, that is smart contracts, must explicitly support delegate assignment, but can also be deployed with a delegate already set.

```dart
// Choosing the rpc-sever to use
var server = '';

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

//Delegation Operation
var result = await TezsterDart.sendDelegationOperation(
      server,
      signer,
      keyStore,
      'tz1RVcUP9nUurgEJMDou8eW3bVDs6qmP5Lnc',//Delegate to
      10000,
    );

print("Applied operation ===> $result['appliedOp']");
print("Operation groupID ===> $result['operationGroupID']");
```