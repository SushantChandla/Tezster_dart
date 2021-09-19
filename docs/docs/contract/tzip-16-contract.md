---
sidebar_position: 3
---

# Tzip 16 
A standard for accessing contract metadata in JSON format in on-chain storage or off-chain using IPFS or HTTP(S).

You can get the instance of Tzip16Contract by passing tzip16 in the `getContract` method.

```dart
Tzip16Contract tzip12Contract = TezsterDart.getContract(
        'https://mainnet.api.tez.ie', 'KT1RJ6PbjHpwc3M5rw5s2Nbmefwbuwbdxton',
        contractType: ContractType.Tzip16);// pasing contract type here
    var metaData = await tzip12Contract.getMetadata();
    print(metaData);
```

