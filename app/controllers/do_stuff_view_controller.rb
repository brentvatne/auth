class DoStuffViewController < UIViewController

  def init; self; end

  def title
    'Sample Authentication App'
  end

  def viewDidAppear(animated)
    if Api::SampleClient.authenticated?
      logoutButton.enabled = true
    else
      logoutButton.enabled = false
    end
  end

  def viewDidLoad
    super

    self.view.backgroundColor = UIColor.whiteColor
    view.addSubview(getDataButton)
    view.addSubview(logoutButton)
    view.addSubview(backgroundLabel)
    view.addSubview(contentLabel)

    watchForGetDataPress
    watchForLogoutPress
  end

  def watchForGetDataPress
    getDataButton.when(UIControlEventTouchUpInside) do
      getDataButton.enabled = false
      Api::SampleClient.fetchIndex do |success, result|
        getDataButton.enabled = true
        if success
          contentLabel.text = result
        end
      end
    end
  end

  def watchForLogoutPress
    logoutButton.when(UIControlEventTouchUpInside) do
      logoutButton.enabled = false
      Api::SampleClient.clearToken
    end
  end

  def backgroundLabel
    @backgroundLabel ||= begin
      _label = UILabel.alloc.initWithFrame [[0, 60], [320, 360]]
      _label.backgroundColor = 'black'.to_color
      _label
    end
  end

  def contentLabel
    @contentLabel ||= begin
      _label = UILabel.alloc.initWithFrame [[10, 70], [300, 350]]
      _label.backgroundColor = 'black'.to_color
      _label.textColor = 'white'.to_color
      _label.text = "..."
      _label.lineBreakMode = UILineBreakModeWordWrap
      _label.font = UIFont.fontWithName('Arial', size:11)
      _label.numberOfLines = 0
      _label
    end
  end

  def getDataButton
    @getDataButton ||= begin
      _button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
      _button.setTitle("Get some data!", forState:UIControlStateNormal)
      _button.sizeToFit
      _button.frame = [[10, 17], [145, 30]]
      _button
    end
  end

  def logoutButton
    @logoutButton ||= begin
      _button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
      _button.setTitle("Log out", forState:UIControlStateNormal)
      _button.sizeToFit
      _button.frame = [[165, 17], [145, 30]]
      _button
    end
  end
end
