class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    window.rootViewController = loginViewController
    window.makeKeyAndVisible
    window.rootViewController.wantsFullScreenLayout = true
    true
  end

  def window
    @window ||= UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  end

  def loginViewController
    @loginViewController ||= LoginViewController.alloc.init
  end

  def doStuffViewController
    @doStuffViewController ||= DoStuffViewController.alloc.init
  end
end
