class LoginViewController < UIViewController

  def init; self; end

  # def presentModallyFromViewController(viewController)
  # end

  def viewDidLoad
    super

    styleView
    addSubviews
    watchForSubmit
  end

  def styleView
    self.view.backgroundColor = backgroundColor
  end

  def watchForSubmit
    submitButton.when(UIControlEventTouchUpInside) do
      disableForm
      Api::SampleClient.authenticate(login, password) do |success, response|
        $stdout.puts 'success!'
      end
    end
  end

  def login
    loginField.text
  end

  def password
    passwordField.text
  end

  def disableForm
    submitButton.enabled  = false
    loginField.enabled    = false
    passwordField.enabled = false
  end

  def enableForm
    submitButton.enabled  = true
    loginField.enabled    = true
    passwordField.enabled = true
  end

  def addSubviews
    self.view.addSubview loginLabel
    self.view.addSubview loginField
    self.view.addSubview passwordLabel
    self.view.addSubview passwordField
    self.view.addSubview submitButton
  end

  def backgroundColor
    '#f0f1f4'.to_color
  end

  def textColor
    '#6f7073'.to_color
  end

  def loginLabel
    @loginLabel ||= begin
      _label = UILabel.alloc.initWithFrame [[10, 20], [100, 20]]
      _label.backgroundColor = backgroundColor
      _label.font = UIFont.fontWithName('Arial Rounded MT Bold', size:15)
      _label.textColor = textColor
      _label.text = "Login"
      _label
    end
  end

  def loginField
    @loginField ||= begin
      _textField = UITextField.alloc.initWithFrame [[10,45], [300, 25]]
      _textField.autocapitalizationType = UITextAutocapitalizationTypeNone
      _textField.borderStyle = UITextBorderStyleRoundedRect
      _textField
    end
  end

  def passwordLabel
    @passwordLabel ||= begin
      _label = UILabel.alloc.initWithFrame [[10, 80], [100, 20]]
      _label.backgroundColor = backgroundColor
      _label.textColor = textColor
      _label.font = UIFont.fontWithName('Arial Rounded MT Bold', size:15)
      _label.text = "Password"
      _label
    end
  end

  def passwordField
    @passwordField ||= begin
      _textField = UITextField.alloc.initWithFrame [[10,105], [300, 25]]
      _textField.autocapitalizationType = UITextAutocapitalizationTypeNone
      _textField.borderStyle = UITextBorderStyleRoundedRect
      _textField.secureTextEntry = true
      _textField
    end
  end

  def submitButton
    @submitButton ||= begin
      _button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
      _button.setTitle("Submit", forState:UIControlStateNormal)
      _button.sizeToFit
      _button.frame = [[10, 150], [300, 30]]
      _button
    end
  end
end
