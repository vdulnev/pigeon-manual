// After regenerating, copy ios/Runner/messages.g.swift → macos/Runner/messages.g.swift.
// Pigeon has no separate macOS Swift output (confirmed through v26); swiftOut targets
// iOS but the generated file supports both platforms via #if os(iOS)/#elseif os(macOS).
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

@EventChannelApi()
abstract class CounterEventApi {
  int onCount();
}
