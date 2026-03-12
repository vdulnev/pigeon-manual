import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    let messenger = flutterViewController.engine.binaryMessenger
    ExampleHostApiSetup.setUp(binaryMessenger: messenger, api: PlatformNameHandler())
    OnCountStreamHandler.register(with: messenger, streamHandler: CounterStreamHandler())

    super.awakeFromNib()
  }
}

private class PlatformNameHandler: ExampleHostApi {
  func getPlatformName() throws -> String {
    return "macOS"
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
