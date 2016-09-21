

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

    func updateWindow(horizontaSliderValue: Float, verticalSliderValue: Float) {
        if let baseFrame = self.sliderWindow?.frame, let window = self.mainWindow {
            window.frame = CGRectMake(0, 0, CGFloat(horizontaSliderValue) * baseFrame.width, CGFloat(verticalSliderValue) * baseFrame.height)
        }
    }


    // MARK: - Private

    func addSliderWindow() {

        self.sliderWindow = {
            let newWindow = SliderWindow(frame: UIScreen.mainScreen().bounds)
            newWindow.rootViewController = UIViewController()
            newWindow.rootViewController?.view.backgroundColor = UIColor.clearColor()
            newWindow.makeKeyAndVisible()
            return newWindow
        }()

        self.sliderWindow?.enableSliders()

        self.sliderWindow?.sliderValueDidChange = { horizontalSliderValue, verticalSliderValue in
            self.updateWindow(horizontalSliderValue, verticalSliderValue: verticalSliderValue)
        }

        self.sliderWindow?.windowDidRotate = { horizontalSliderValue, verticalSliderValue in
            self.updateWindow(horizontalSliderValue, verticalSliderValue: verticalSliderValue)
        }
    }


    
}