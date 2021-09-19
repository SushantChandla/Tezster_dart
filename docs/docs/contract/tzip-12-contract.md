---
sidebar_position: 3
---

# Tzip 12
You can get the instance of Tzip12Contract by passing tzip12 contract type in the `getContract` method.

```dart
  Tzip12Contract tzip16Contract = TezsterDart.getContract(
        'https://mainnet.api.tez.ie', 'KT1RJ6PbjHpwc3M5rw5s2Nbmefwbuwbdxton',
        contractType: ContractType.Tzip12);
    var tokenData=await tzip12Contract.getTokenMetadata(1392);
    print(tokenData);
```

