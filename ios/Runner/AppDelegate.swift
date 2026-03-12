import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let messenger = engineBridge.applicationRegistrar.messenger()
    ExampleHostApiSetup.setUp(binaryMessenger: messenger, api: PlatformNameHandler())
    OnCountStreamHandler.register(with: messenger, streamHandler: CounterStreamHandler())
    PingHostApiSetup.setUp(binaryMessenger: messenger, api: PingHostHandler(messenger: messenger))
  }
}

private class PlatformNameHandler: ExampleHostApi {
  func getPlatformName() throws -> String {
    return "iOS"
  }
}

private class PingHostHandler: PingHostApi {
  private let messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
  }

  func requestPing() throws {
    PingFlutterApi(binaryMessenger: messenger).onPong(message: "Pong from iOS!") { _ in }
  }
}

private class CounterStreamHandler: OnCountStreamHandler {
  private var timer: Timer?
  private var count: Int64 = 0

  override func onListen(withArguments arguments: Any?, sink: PigeonEventSink<Int64>) {
    count = 0
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      guard let self else { return }
      sink.success(self.count)
      self.count += 1
    }
  }

  override func onCancel(withArguments arguments: Any?) {
    timer?.invalidate()
    timer = nil
  }
}
