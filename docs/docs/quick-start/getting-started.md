---
sidebar_position: 2
---

# Getting Started

Add this in your pubspec.yaml file.
```yaml
  dependencies:
    tezster_dart: ^2.1.1
```

#### web setup

Download the [Sodium.js](https://raw.githubusercontent.com/jedisct1/libsodium.js/master/dist/browsers-sumo/sodium.js).

```
  flutter-project
    -lib/
    -pubspec.yaml
    ...
    -web/
      -sodium.js // here
      -index.js
```

and add it to your flutter  web directory. Then in your web/index.html add
```html
<head>
    ...
<script src="sodium.js"></script>
</head>
```

### Import it 
Now in your Dart code, you can use:

```dart
import 'package:tezster_dart/tezster_dart.dart';
```

