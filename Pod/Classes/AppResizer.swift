

public class AppResizer: NSObject {

    // MARK: - Shared Instance

    public static let sharedInstance = AppResizer()


    // MARK: - Properties

    private var mainWindow: UIWindow?
    private var sliderWindow: SliderWindow?


    // MARK: - Enable

    public func enable(mainWindow: UIWindow) {
        self.mainWindow = mainWindow

        self.addSliderWindow()
    }


    // MARK: - Update

    func updateWindow(horizontalSliderValue: Float, verticalSliderValue: Float) {
        if let baseFrame = self.sliderWindow?.frame, let window = self.mainWindow {
            window.frame = CGRect(x: 0,
                                  y: 0,
                                  width: CGFloat(horizontalSliderValue) * baseFrame.width,
                                  height: CGFloat(verticalSliderValue) * baseFrame.height)
        }
    }


    // MARK: - Private

    func addSliderWindow() {

        self.sliderWindow = {
            let newWindow = SliderWindow(frame: UIScreen.main.bounds)
            newWindow.rootViewController = UIViewController()
            newWindow.rootViewController?.view.backgroundColor = .clear
            newWindow.makeKeyAndVisible()
            return newWindow
        }()

        self.sliderWindow?.enableSliders()

        self.sliderWindow?.sliderValueDidChange = {
            self.updateWindow(horizontalSliderValue: $0, verticalSliderValue: $1)
        }

        self.sliderWindow?.windowDidRotate = {
            self.updateWindow(horizontalSliderValue: $0, verticalSliderValue: $1)
        }
    }
}
