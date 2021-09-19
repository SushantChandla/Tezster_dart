---
sidebar_position: 4
---
# Fundraiser

Once a fundraiser account has been activated it needs to be revealed on-chain. Hence, we have included the facility to reveal the faucet/fundraiser account all you have to do is call the `sendKeyRevealOperation` method, and voila it’s revealed. We have set an example for you how to use it.

```dart
var server = '';

var keyStore = KeyStoreModel(
      publicKeyHash: 'tz1U.....W5MHgi',
      secretKey:
          'edskRp......bL2B6g',
      publicKey: 'edpktt.....U1gYJu2',
    );

var signer = await TezsterDart.createSigner(
        TezsterDart.writeKeyWithHint(keyStore.secretKey, 'edsk'));

var result =
        await TezsterDart.sendKeyRevealOperation(server, signer, keyStore);

print('${result['operationGroupID']}');
```