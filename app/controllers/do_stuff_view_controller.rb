class DoStuffViewController < UIViewController

  def init; self; end

  def viewDidLoad
    super

    self.view.backgroundColor = UIColor.whiteColor
    view.addSubview(titleLabel)
  end

  def titleLabel
    return @label unless @label.nil?

    labelFrame = CGRectMake(10, 20, 300, 80)
    @label = UILabel.alloc.initWithFrame(labelFrame)
    @label.text = "Do something interesting!"
    @label
  end

end
