public enum Mode {
    case freeform
    case predefinedSize
}

public class AppResizer: NSObject {

    // MARK: - Shared Instance

    public static let sharedInstance = AppResizer()


    // MARK: - Properties

    private var mainWindow: UIWindow?
    private var resizingWindow: ResizingWindow?
    private var mode = Mode.freeform


    // MARK: - Enable

    public func enable(mainWindow: UIWindow, mode: Mode = Mode.freeform) {
        self.mainWindow = mainWindow
        self.mode = mode

        self.mode == Mode.predefinedSize ? addPredefinedWindow() : addSliderWindow()

        registerWindowToValueChange()
        activateWindow()
    }


    // MARK: - Update

    func updateWindow(resizedSize: CGSize) {
        guard
            let baseFrame = resizingWindow?.frame,
            let window = mainWindow else {
                return
        }
        UIView.animate(withDuration: 0.3) {
            window.frame = CGRect(x: 0,
                                  y: 0,
                                  width: resizedSize.width,
                                  height: resizedSize.height)
        }
    }


    // MARK: - Private

    private func registerWindowToValueChange() {
        resizingWindow?.resizingValueDidChange = {
            self.updateWindow(resizedSize: $0)
        }

        resizingWindow?.windowDidRotate = {
            self.updateWindow(resizedSize: $0)
        }
    }

    private func activateWindow() {
        resizingWindow?.enable()
    }

    private func addSliderWindow() {

        resizingWindow = {
            let newWindow = SliderWindow(frame: UIScreen.main.bounds)
            newWindow.rootViewController = UIViewController()
            newWindow.rootViewController?.view.backgroundColor = .clear
            newWindow.makeKeyAndVisible()
            return newWindow
        }()

    }

    private func addPredefinedWindow() {

        resizingWindow = {
            let newWindow = DevicesListWindow(frame: UIScreen.main.bounds)
            newWindow.rootViewController = UIViewController()
            newWindow.rootViewController?.view.backgroundColor = .clear
            newWindow.makeKeyAndVisible()
            return newWindow
        }()
    }
}
