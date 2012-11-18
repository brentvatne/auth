class DoStuffViewController < UIViewController

  def init; self; end

  def viewDidLoad
    super

    self.view.backgroundColor = UIColor.whiteColor
    view.addSubview(getDataButton)
    view.addSubview(backgroundLabel)
    view.addSubview(contentLabel)
    watchForGetDataPress
  end

  def watchForGetDataPress
    getDataButton.when(UIControlEventTouchUpInside) do
      contentLabel.text = Api::SampleClient.token
      contentLabel.sizeToFit
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
      _label.sizeToFit
      _label
    end
  end

  def getDataButton
    @getDataButton ||= begin
      _button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
      _button.setTitle("Get some data!", forState:UIControlStateNormal)
      _button.sizeToFit
      _button.frame = [[10, 20], [300, 30]]
      _button
    end
  end
end
