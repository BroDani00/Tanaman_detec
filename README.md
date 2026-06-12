# tanaman_detect

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

berikut adalah STRUKTURNYA

C:.
│   .flutter-plugins-dependencies
│   .gitignore
│   .metadata
│   analysis_options.yaml
│   pubspec.lock
│   pubspec.yaml
│   README.md
│
├───.dart_tool
│   │   package_config.json
│   │   package_graph.json
│   │   version
│   │
│   └───extension_discovery
│           vs_code.json
│
├───android
│   │   .gitignore
│   │   build.gradle.kts
│   │   gradle.properties
│   │   settings.gradle.kts
│   │
│   ├───app
│   │   │   build.gradle.kts
│   │   │
│   │   └───src
│   │       ├───debug
│   │       │       AndroidManifest.xml
│   │       │
│   │       ├───main
│   │       │   │   AndroidManifest.xml
│   │       │   │
│   │       │   ├───kotlin
│   │       │   │   └───com
│   │       │   │       └───example
│   │       │   │           └───tanaman_detect
│   │       │   │                   MainActivity.kt
│   │       │   │
│   │       │   └───res
│   │       │       ├───drawable
│   │       │       │       launch_background.xml
│   │       │       │
│   │       │       ├───drawable-v21
│   │       │       │       launch_background.xml
│   │       │       │
│   │       │       ├───mipmap-hdpi
│   │       │       │       ic_launcher.png
│   │       │       │
│   │       │       ├───mipmap-mdpi
│   │       │       │       ic_launcher.png
│   │       │       │
│   │       │       ├───mipmap-xhdpi
│   │       │       │       ic_launcher.png
│   │       │       │
│   │       │       ├───mipmap-xxhdpi
│   │       │       │       ic_launcher.png
│   │       │       │
│   │       │       ├───mipmap-xxxhdpi
│   │       │       │       ic_launcher.png
│   │       │       │
│   │       │       ├───values
│   │       │       │       styles.xml
│   │       │       │
│   │       │       └───values-night
│   │       │               styles.xml
│   │       │
│   │       └───profile
│   │               AndroidManifest.xml
│   │
│   └───gradle
│       └───wrapper
│               gradle-wrapper.properties
│
├───assets
│   └───images
│           cabai.jpg
│           jagung.jpg
│           padi.jpg
│
├───ios
│   │   .gitignore
│   │
│   ├───Flutter
│   │       AppFrameworkInfo.plist
│   │       Debug.xcconfig
│   │       Release.xcconfig
│   │
│   ├───Runner
│   │   │   AppDelegate.swift
│   │   │   Info.plist
│   │   │   Runner-Bridging-Header.h
│   │   │   SceneDelegate.swift
│   │   │
│   │   ├───Assets.xcassets
│   │   │   ├───AppIcon.appiconset
│   │   │   │       Contents.json
│   │   │   │       Icon-App-1024x1024@1x.png
│   │   │   │       Icon-App-20x20@1x.png
│   │   │   │       Icon-App-20x20@2x.png
│   │   │   │       Icon-App-20x20@3x.png
│   │   │   │       Icon-App-29x29@1x.png
│   │   │   │       Icon-App-29x29@2x.png
│   │   │   │       Icon-App-29x29@3x.png
│   │   │   │       Icon-App-40x40@1x.png
│   │   │   │       Icon-App-40x40@2x.png
│   │   │   │       Icon-App-40x40@3x.png
│   │   │   │       Icon-App-60x60@2x.png
│   │   │   │       Icon-App-60x60@3x.png
│   │   │   │       Icon-App-76x76@1x.png
│   │   │   │       Icon-App-76x76@2x.png
│   │   │   │       Icon-App-83.5x83.5@2x.png
│   │   │   │
│   │   │   └───LaunchImage.imageset
│   │   │           Contents.json
│   │   │           LaunchImage.png
│   │   │           LaunchImage@2x.png
│   │   │           LaunchImage@3x.png
│   │   │           README.md
│   │   │
│   │   └───Base.lproj
│   │           LaunchScreen.storyboard
│   │           Main.storyboard
│   │
│   ├───Runner.xcodeproj
│   │   │   project.pbxproj
│   │   │
│   │   ├───project.xcworkspace
│   │   │   │   contents.xcworkspacedata
│   │   │   │
│   │   │   └───xcshareddata
│   │   │           IDEWorkspaceChecks.plist
│   │   │           WorkspaceSettings.xcsettings
│   │   │
│   │   └───xcshareddata
│   │       └───xcschemes
│   │               Runner.xcscheme
│   │
│   ├───Runner.xcworkspace
│   │   │   contents.xcworkspacedata
│   │   │
│   │   └───xcshareddata
│   │           IDEWorkspaceChecks.plist
│   │           WorkspaceSettings.xcsettings
│   │
│   └───RunnerTests
│           RunnerTests.swift
│
├───lib
│   │   main.dart
│   │
│   ├───models
│   │       user_model.dart
│   │
│   ├───screens
│   │       login_screen.dart
│   │       panduan_cerdas.dart
│   │       register_screen.dart
│   │
│   ├───services
│   │       auth_service.dart
│   │
│   ├───utils
│   │       constants.dart
│   │       validators.dart
│   │
│   └───widgets
│           custom_button.dart
│           custom_textfield.dart
│           plant_card.dart
│
├───linux
│   │   .gitignore
│   │   CMakeLists.txt
│   │
│   ├───flutter
│   │       CMakeLists.txt
│   │       generated_plugins.cmake
│   │       generated_plugin_registrant.cc
│   │       generated_plugin_registrant.h
│   │
│   └───runner
│           CMakeLists.txt
│           main.cc
│           my_application.cc
│           my_application.h
│
├───macos
│   │   .gitignore
│   │
│   ├───Flutter
│   │       Flutter-Debug.xcconfig
│   │       Flutter-Release.xcconfig
│   │       GeneratedPluginRegistrant.swift
│   │
│   ├───Runner
│   │   │   AppDelegate.swift
│   │   │   DebugProfile.entitlements
│   │   │   Info.plist
│   │   │   MainFlutterWindow.swift
│   │   │   Release.entitlements
│   │   │
│   │   ├───Assets.xcassets
│   │   │   └───AppIcon.appiconset
│   │   │           app_icon_1024.png
│   │   │           app_icon_128.png
│   │   │           app_icon_16.png
│   │   │           app_icon_256.png
│   │   │           app_icon_32.png
│   │   │           app_icon_512.png
│   │   │           app_icon_64.png
│   │   │           Contents.json
│   │   │
│   │   ├───Base.lproj
│   │   │       MainMenu.xib
│   │   │
│   │   └───Configs
│   │           AppInfo.xcconfig
│   │           Debug.xcconfig
│   │           Release.xcconfig
│   │           Warnings.xcconfig
│   │
│   ├───Runner.xcodeproj
│   │   │   project.pbxproj
│   │   │
│   │   ├───project.xcworkspace
│   │   │   └───xcshareddata
│   │   │           IDEWorkspaceChecks.plist
│   │   │
│   │   └───xcshareddata
│   │       └───xcschemes
│   │               Runner.xcscheme
│   │
│   ├───Runner.xcworkspace
│   │   │   contents.xcworkspacedata
│   │   │
│   │   └───xcshareddata
│   │           IDEWorkspaceChecks.plist
│   │
│   └───RunnerTests
│           RunnerTests.swift
│
├───test
│       widget_test.dart
│
├───web
│   │   favicon.png
│   │   index.html
│   │   manifest.json
│   │
│   └───icons
│           Icon-192.png
│           Icon-512.png
│           Icon-maskable-192.png
│           Icon-maskable-512.png
│
└───windows
    │   .gitignore
    │   CMakeLists.txt
    │
    ├───flutter
    │   │   CMakeLists.txt
    │   │   generated_plugins.cmake
    │   │   generated_plugin_registrant.cc
    │   │   generated_plugin_registrant.h
    │   │
    │   └───ephemeral
    │       └───.plugin_symlinks
    └───runner
        │   CMakeLists.txt
        │   flutter_window.cpp
        │   flutter_window.h
        │   main.cpp
        │   resource.h
        │   runner.exe.manifest
        │   Runner.rc
        │   utils.cpp
        │   utils.h
        │   win32_window.cpp
        │   win32_window.h
        │
        └───resources
                app_icon.ico


├───lib
│   │   main.dart
│   │
│   ├───models
│   │       user_model.dart
│   │
│   ├───screens
│   │       login_screen.dart
│   │       panduan_cerdas.dart
│   │       register_screen.dart
│   │
│   ├───services
│   │       auth_service.dart
│   │
│   ├───utils
│   │       constants.dart
│   │       validators.dart
│   │
│   └───widgets
│           custom_button.dart
│           custom_textfield.dart
│           plant_card.dart