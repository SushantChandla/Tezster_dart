---
sidebar_position: 4
---

# Tzip 12
You can get the instance of Tzip12Contract by passing tzip12 contract type in the `getContract` method.
You can get Token metaData by calling `getTokenMetadata` on the Tzip12Contract Instance.
```dart
  Tzip12Contract tzip16Contract = TezsterDart.getContract(
        'https://mainnet.api.tez.ie', 'KT1RJ6PbjHpwc3M5rw5s2Nbmefwbuwbdxton',
        contractType: ContractType.Tzip12);
    var tokenData=await tzip12Contract.getTokenMetadata(1392);
    print(tokenData);
```

