---
sidebar_position: 3
---

# Get Contract Storage
You can get the contract storage by creating the instance of Contract object and calling `getStorage`  method on it.
In most cases you won't need this, for production level apps we usually use `blockchain indexers` to get contract storage.


```dart
 var contract = TezsterDart.getContract(
        "https://mainnet.api.tez.ie", "KT1DLif2x9BtK6pUq9ZfFVVyW5wN2kau9rkW");
    Map storage = await contract.getStorage();
```