import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    //self.setFrame(windowFrame, display: true)
    self.setFrame(resizeRect(rect: windowFrame, width: 1280, height: 800), display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}

/// 保持矩形中心点不变, 调整矩形的宽高
func resizeRect(rect: NSRect, width: CGFloat, height: CGFloat) -> NSRect {
  return NSRect(x: rect.origin.x + (rect.size.width - width) / 2, y: rect.origin.y + (rect.size.height - height) / 2, width: width, height: height)
}