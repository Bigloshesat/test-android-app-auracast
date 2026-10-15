# Debug keystore（固定）

| 字段 | 值 |
|------|-----|
| File | `debug.keystore` |
| storePassword | `android` |
| keyPassword | `android` |
| keyAlias | `androiddebugkey` |

Wired in `../build.gradle` as `signingConfigs.debug`.

All cloud `flutter build apk --debug` builds must use this file so incremental installs keep the same signature.
