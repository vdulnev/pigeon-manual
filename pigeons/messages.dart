import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/messages.g.dart',
    swiftOut: 'ios/Runner/messages.g.swift',
    kotlinOut:
        'android/app/src/main/kotlin/com/example/pigeon_manual/messages.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.example.pigeon_manual'),
  ),
)
@HostApi()
abstract class ExampleHostApi {
  String getPlatformName();
}
