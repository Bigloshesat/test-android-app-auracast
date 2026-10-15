# ArtSound / Bluesonix（kele 蓝牙 App）

Flutter 客户端。**蓝牙协议勿改**，除非有明确产品需求。

## 本地运行

```bash
flutter pub get
flutter run
# Debug APK（云端/CI 同命令）
flutter build apk --debug
```

## 固定 debug 签名（重要）

云端每次用随机 debug.keystore 会导致用户升级时 `INSTALL_FAILED_UPDATE_INCOMPATIBLE`，必须卸载重装。

本仓库已提交固定 keystore：

| 项 | 值 |
|----|----|
| 路径 | `android/app/keystore/debug.keystore` |
| storePassword / keyPassword | `android` |
| alias | `androiddebugkey` |
| Gradle | `android/app/build.gradle` → `signingConfigs.debug` |

**后续所有云端 debug APK 必须用同一 keystore。** 不要删除或重新生成该文件；新环境可从仓库或 store 备份 `artifacts/keystore/debug.keystore` 恢复。

## 开机动画

- 资源：`assets/videos/boot-logo-clean.mp4`
- Flutter：`ArtIntro`（`video_player`）播完再进主界面
- Native：`launch_background` 为黑色，去掉白屏闪一下

## 查找页扩散圈

`SearchRipples`：`maxRadius = max(width, height) * (1/3)`（竖屏即高度的 1/3）。
