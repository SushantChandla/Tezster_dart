---
sidebar_position: 5
---

# Operation confirmation
No wonder it's really important to await for confirmation for any on chain interactions. Hence, we have provided `awaitOperationConfirmation` method with this release that developers can leverage for their advantage to confirm the originated contract's operations id. We have set an example for you how to use it.

```dart
print("Operation groupID ===> $result['operationGroupID']");

var groupId = result['operationGroupID'];//get the operation ID

var confirmationResult = await TezsterDart.awaitOperationConfirmation(
        serverInfo, network, groupId, 5);

print('Originated contract at $confirmationResult');
```