class AppDelegate

  # show the do stuff view
  # when you click something, check if authenticated
  # if not, send notification and do nothing
  # app delegate watch for notification and force authentication

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    window.rootViewController = appNavigationController
    window.makeKeyAndVisible
    window.rootViewController.wantsFullScreenLayout = true
    true
  end

  def window
    @window ||= UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  end

  def appNavigationController
    @appNavigationController ||=
      AppNavigationController.alloc.initWithRootViewController(doStuffViewController)
  end

  def loginViewController
    @loginViewController ||= LoginViewController.alloc.init
  end

  def doStuffViewController
    @doStuffViewController ||= DoStuffViewController.alloc.init
  end
end
